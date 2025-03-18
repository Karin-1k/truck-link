import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trucklink/global/appcolors.dart';

import 'package:trucklink/state_managment/drivercontroller/trip_controller.dart';
import 'package:trucklink/state_managment/usercontroller/usertrip_controller.dart';

class UserActivityPage extends StatelessWidget {
  final TripController tripController = Get.put(TripController());
  final UserTripController usertripController = Get.put(UserTripController());

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Activity',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
          backgroundColor: AppColors
              .mainColor, // Set the primary color to AppColors.mainColor
          bottom: TabBar(
            labelStyle:
                TextStyle(fontWeight: FontWeight.w600), // Bolder text for tabs
            unselectedLabelColor: Colors.grey,
            // labelColor: Color,
            tabs: [
              Tab(text: 'Pending'),
              Tab(text: 'Cancelled'),
              Tab(text: 'Completed'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildTripList('PENDING'),
            _buildTripList('CANCELLED'),
            _buildTripList('COMPLETED'),
          ],
        ),
      ),
    );
  }

  Widget _buildTripList(String status) {
    TripStatus tripStatus = _getTripStatusFromString(status);

    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: usertripController.getTripsByStatusWithUserInfo(tripStatus),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
              child: Text("Error: ${snapshot.error}",
                  style: TextStyle(color: Colors.red)));
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
              child: Text("No trips available.",
                  style: TextStyle(color: Colors.grey)));
        }

        var trips = snapshot.data!;

        return ListView.builder(
          padding: EdgeInsets.all(8.0),
          itemCount: trips.length,
          itemBuilder: (context, index) {
            var trip = trips[index];

            return Card(
              elevation: 5,
              margin: EdgeInsets.symmetric(vertical: 8.0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              color: Colors.white, // Set the card background to white
              child: ListTile(
                contentPadding: EdgeInsets.all(12.0),
                title: Text('${trip['origin']} to ${trip['destination']}',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          'Departure: ${trip['departureDate']} at ${trip['departureTime']}'),
                      SizedBox(height: 4),
                      Text('Driver: ${trip['driverName']}'),
                      Text('Phone: ${trip['driverPhone']}'),
                      Text('Vehicle Type: ${trip['vehicleType']}'),
                    ],
                  ),
                ),
                trailing: status == 'PENDING'
                    ? IconButton(
                        icon: Icon(Icons.cancel, color: Colors.red),
                        onPressed: () {
                          usertripController.cancelTrip(trip['tripId']);
                        },
                      )
                    : null,
              ),
            );
          },
        );
      },
    );
  }

  TripStatus _getTripStatusFromString(String status) {
    switch (status) {
      case 'PENDING':
        return TripStatus.PENDING;
      case 'CANCELLED':
        return TripStatus.CANCEL;
      case 'COMPLETED':
        return TripStatus.COMPLETE;
      default:
        return TripStatus.WAITING;
    }
  }
}

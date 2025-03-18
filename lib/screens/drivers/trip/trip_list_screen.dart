import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trucklink/global/appcolors.dart';
import 'package:trucklink/screens/drivers/trip/trip_editing_screen.dart';
import 'package:trucklink/state_managment/drivercontroller/trip_controller.dart'; // Import the TripStatus enum from here
import 'package:intl/intl.dart';
import 'package:trucklink/state_managment/usercontroller/usertrip_controller.dart'; // For date formatting

class TripListScreen extends StatelessWidget {
  final TripController tripController = Get.put(TripController());
  final UserTripController userTripController = Get.put(UserTripController());

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Trip Statuses"),
          backgroundColor: AppColors.mainColor,
          centerTitle: true,
          bottom: TabBar(
            tabs: [
              Tab(text: 'Waiting'),
              Tab(text: 'Pending'),
              Tab(text: 'Cancelled'),
              Tab(text: 'Completed'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildTripList(TripStatus.WAITING),
            _buildTripList(TripStatus.PENDING),
            _buildTripList(TripStatus.CANCEL),
            _buildTripList(TripStatus.COMPLETE),
          ],
        ),
      ),
    );
  }

  Widget _buildTripList(TripStatus status) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: tripController.getTripsByStatusWithUserInfo(status),
      builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        var trips = snapshot.data!;

        return ListView.builder(
          itemCount: trips.length,
          itemBuilder: (context, index) {
            var trip = trips[index];

            DateTime departureDate = DateTime.parse(trip["departureDate"]);
            DateTime departureTime = DateTime.parse(trip["departureTime"]);

            String formattedDepartureDate =
                DateFormat('yyyy-MM-dd').format(departureDate);
            String formattedDepartureTime =
                DateFormat('HH:mm').format(departureTime);

            return Card(
              margin: EdgeInsets.all(10),
              elevation: 4, // Raised effect with elevation
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12), // Rounded corners
              ),
              color: Colors.white, // Card color set to white
              child: ListTile(
                contentPadding: EdgeInsets.all(16), // Padding inside the card
                title: Text(
                  "${trip["origin"]} to ${trip["destination"]}",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 5),
                    Text("Departure Date: $formattedDepartureDate"),
                    Text("Departure Time: $formattedDepartureTime"),
                    Text("Status: ${trip["tripStatus"]}",
                        style: TextStyle(color: Colors.grey[700])),
                    if (status != TripStatus.WAITING) ...[
                      SizedBox(height: 5),
                      Text("User Name: ${trip["userName"]}"),
                      Text("User Phone: ${trip["userPhone"]}"),
                    ]
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: _buildActionButtons(trip),
                ),
              ),
            );
          },
        );
      },
    );
  }

  List<Widget> _buildActionButtons(var trip) {
    switch (trip["tripStatus"]) {
      case 'WAITING':
        return [
          IconButton(
            icon: Icon(Icons.edit, color: AppColors.mainColor),
            onPressed: () async {
              DocumentSnapshot tripDoc = await FirebaseFirestore.instance
                  .collection('trips')
                  .doc(trip['tripId'])
                  .get();

              Get.to(TripEditScreen(tripId: trip['tripId'], tripData: tripDoc));
            },
          ),
          IconButton(
            icon: Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              tripController.deleteTrip(trip['tripId']);
            },
          ),
        ];
      case 'PENDING':
        return [
          IconButton(
            icon: Icon(Icons.check, color: Colors.green),
            onPressed: () {
              tripController.completeTrip(
                  trip["tripId"], trip["driverId"], trip["userId"]);
            },
          ),
          IconButton(
            icon: Icon(Icons.cancel, color: Colors.orange),
            onPressed: () {
              userTripController.cancelTrip(trip["tripId"]);
            },
          ),
        ];
      case 'CANCEL':
      case 'COMPLETE':
        return [];
      default:
        return [];
    }
  }
}

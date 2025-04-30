import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';
import 'package:trucklink/global/appcolors.dart';
import 'package:trucklink/global/global_widgets.dart';

import 'package:trucklink/state_managment/usercontroller/usertrip_controller.dart';

class UserHomePage extends StatelessWidget {
  final UserTripController tripController = Get.put(UserTripController());

  // Date formatting function
  String formatDateTime(String dateTimeString) {
    DateTime dateTime = DateTime.parse(dateTimeString);
    return DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    String? userId = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      appBar: AppBar(
        title: Text('Available Trips',
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.mainColor,
        centerTitle: true,
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: tripController.getWaitingTripsWithDriverInfo(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
                child: Text("No waiting trips available.",
                    style: TextStyle(color: Colors.grey)));
          }

          var trips = snapshot.data!;

          return ListView.builder(
            itemCount: trips.length,
            itemBuilder: (context, index) {
              var trip = trips[index];

              return Card(
                margin: EdgeInsets.all(8.0),
                color: Colors.white, // Card background color set to white
                elevation: 5, // Slight shadow for the card
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.all(12.0),
                  title: Text(
                    '${trip["origin"]} to ${trip['destination']}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            'Departure: ${formatDateTime(trip['departureDate'])}',
                            style: TextStyle(fontSize: 14)),
                        Row(
                          children: [
                            Text('Driver: ${trip['driverName']}',
                                style: TextStyle(fontSize: 14)),
                            IconButton(
                                onPressed: () async {
                                  lg.i(trip['driverId']);
                                  final result = await tripController
                                      .getDriverBonusAndRank(trip['driverId']);

                                  int bonusPoints = result['bonusPoints'];
                                  int rank = result['rank'];
                                  int totalTrips = (bonusPoints / 10)
                                      .floor(); // Each trip gives 10 points

                                  showDialog(
                                    context: context,
                                    builder: (_) => AlertDialog(
                                      backgroundColor: Colors.white,
                                      title: Text(
                                        "Driver Stats",
                                        textAlign: TextAlign.center,
                                      ),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "🎯 Bonus Points",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16),
                                          ),
                                          Text(
                                            "$bonusPoints",
                                            style: TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.blue),
                                          ),
                                          SizedBox(height: 12),
                                          Text(
                                            "🚚 Completed Trips",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16),
                                          ),
                                          Text(
                                            "$totalTrips",
                                            style: TextStyle(
                                                fontSize: 22,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.green),
                                          ),
                                          SizedBox(height: 12),
                                          Text(
                                            "🏅 Rank",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16),
                                          ),
                                          Text(
                                            "$rank of ${result['totalDrivers']} drivers",
                                            style: TextStyle(
                                                fontSize: 22,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.orange),
                                          ),
                                        ],
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: Text("Close"),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                icon: Icon(
                                  Icons.person,
                                  color: Colors.blue,
                                ))
                          ],
                        ),
                        Text('Phone: ${trip['driverPhone']}',
                            style: TextStyle(fontSize: 14)),
                        Text('Vehicle Type: ${trip['vehicleType']}',
                            style: TextStyle(fontSize: 14)),
                        Text('Rating: ${trip['rating']}',
                            style: TextStyle(fontSize: 14)),
                      ],
                    ),
                  ),
                  trailing: IconButton(
                    icon: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: AppColors
                            .mainColor, // Use main color for button background
                      ),
                      padding: EdgeInsets.all(8),
                      child: Text(
                        'Booking',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    onPressed: () {
                      if (userId != null) {
                        tripController.updateTripStatusToPending(
                            trip['tripId'], userId);
                      } else {
                        Get.snackbar("Error", "User ID not found.");
                      }
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:intl/intl.dart';

// import 'package:trucklink/state_managment/usercontroller/usertrip_controller.dart';

// class UserHomePage extends StatelessWidget {
//   final UserTripController tripController = Get.put(UserTripController());

//   // Date formatting function
//   String formatDateTime(String dateTimeString) {
//     DateTime dateTime = DateTime.parse(dateTimeString);
//     return DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Waiting Trips'),
//       ),
//       body: StreamBuilder<List<Map<String, dynamic>>>(
//         stream: tripController.getWaitingTripsWithDriverInfo(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           }

//           if (snapshot.hasError) {
//             return Center(child: Text("Error: ${snapshot.error}"));
//           }

//           if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return Center(child: Text("No waiting trips available."));
//           }

//           var trips = snapshot.data!;

//           return ListView.builder(
//             itemCount: trips.length,
//             itemBuilder: (context, index) {
//               var trip = trips[index];

//               return Card(
//                 margin: EdgeInsets.all(8.0),
//                 child: ListTile(
//                   title: Text('Trip to ${trip['destination']}'),
//                   subtitle: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                           'Departure: ${formatDateTime(trip['departureDate'])}'),
//                       Text('Driver: ${trip['driverName']}'),
//                       Text('Phone: ${trip['driverPhone']}'),
//                       Text('Vehicle Type: ${trip['vehicleType']}'),
//                       Text('rating: ${trip['rating']}'),
//                     ],
//                   ),
//                   trailing: IconButton(
//                     icon: Icon(
//                       Icons.contact_mail,
//                       color: Colors.green,
//                     ),
//                     onPressed: () {
//                       // Change the trip status to "PENDING"
//                       tripController.updateTripStatusToPending(trip['tripId'],);
//                     },
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import 'package:trucklink/state_managment/usercontroller/usertrip_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserHomePage extends StatelessWidget {
  final UserTripController tripController = Get.put(UserTripController());


  String formatDateTime(String dateTimeString) {
    DateTime dateTime = DateTime.parse(dateTimeString);
    return DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
   
    String? userId = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      appBar: AppBar(
        title: Text('Available Trips'),
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
            return Center(child: Text("No waiting trips available."));
          }

          var trips = snapshot.data!;

          return ListView.builder(
            itemCount: trips.length,
            itemBuilder: (context, index) {
              var trip = trips[index];

              return Card(
                margin: EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text('${trip["origin"]} to ${trip['destination']}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          'Departure: ${formatDateTime(trip['departureDate'])}'),
                      Text('Driver: ${trip['driverName']}'),
                      Text('Phone: ${trip['driverPhone']}'),
                      Text('Vehicle Type: ${trip['vehicleType']}'),
                      Text('Rating: ${trip['rating']}'),
                    ],
                  ),
                  trailing: IconButton(
                    icon: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.green,
                      ),
                      padding: EdgeInsets.all(8),
                      child: Text(
                        'booking',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    onPressed: () {
                    
                      if (userId != null) {
                        tripController.updateTripStatusToPending(
                            trip['tripId'], userId 
                            );
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

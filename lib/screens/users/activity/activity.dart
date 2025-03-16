import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
          title: Text('Activity'),
          bottom: TabBar(
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
      stream: usertripController.getTripsByStatusWithUserInfo(
          tripStatus), 
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text("No trips available."));
        }

        var trips = snapshot.data!;

        return ListView.builder(
          itemCount: trips.length,
          itemBuilder: (context, index) {
            var trip = trips[index];

            return Card(
              margin: EdgeInsets.all(8.0),
              child: ListTile(
                title: Text('Trip to ${trip['destination']}'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        'Departure: ${trip['departureDate']} at ${trip['departureTime']}'),
                    Text('Driver: ${trip['driverName']}'),
                    Text('Phone: ${trip['driverPhone']}'),
                    Text('Vehicle Type: ${trip['vehicleType']}'),
                  ],
                ),
                trailing: status == 'PENDING'
                    ? IconButton(
                        icon: Icon(Icons.cancel),
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

// class UserActivityPage extends StatelessWidget {
//   final UserTripController tripController = Get.put(UserTripController());

//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 3, // Three tabs: Pending, Cancelled, Completed
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text('Activity'),
//           bottom: TabBar(
//             tabs: [
//               Tab(text: 'Pending'),
//               Tab(text: 'Cancelled'),
//               Tab(text: 'Completed'),
//             ],
//           ),
//         ),
//         body: TabBarView(
//           children: [
//             // Pending Trips Tab
//             _buildTripList('PENDING'),
//             // Cancelled Trips Tab
//             _buildTripList('CANCELLED'),
//             // Completed Trips Tab
//             _buildTripList('COMPLETED'),
//           ],
//         ),
//       ),
//     );
//   }

//   // This method will handle fetching trips based on their status
//   Widget _buildTripList(String status) {
//     return StreamBuilder<List<Map<String, dynamic>>>(
//       stream: tripController.getTripsByStatus(status,),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Center(child: CircularProgressIndicator());
//         }

//         if (snapshot.hasError) {
//           return Center(child: Text("Error: ${snapshot.error}"));
//         }

//         if (!snapshot.hasData || snapshot.data!.isEmpty) {
//           return Center(child: Text("No trips available."));
//         }

//         var trips = snapshot.data!;

//         return ListView.builder(
//           itemCount: trips.length,
//           itemBuilder: (context, index) {
//             var trip = trips[index];

//             return Card(
//               margin: EdgeInsets.all(8.0),
//               child: ListTile(
//                 title: Text('Trip to ${trip['destination']}'),
//                 subtitle: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                         'Departure: ${trip['departureDate']} at ${trip['departureTime']}'),
//                     Text('Driver: ${trip['driverName']}'),
//                     Text('Phone: ${trip['driverPhone']}'),
//                     Text('Vehicle Type: ${trip['vehicleType']}'),
//                   ],
//                 ),
//                 trailing: status == 'PENDING'
//                     ? IconButton(
//                         icon: Icon(Icons.cancel),
//                         onPressed: () {
//                           // Handle cancellation logic
//                           tripController.cancelTrip(trip['tripId']);
//                         },
//                       )
//                     : null,
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
// }

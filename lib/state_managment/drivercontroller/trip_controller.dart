import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:trucklink/global/global_widgets.dart';

enum TripStatus {
  WAITING,
  PENDING,
  CANCEL,
  COMPLETE,
}

class TripController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String? driverId = FirebaseAuth.instance.currentUser?.uid;
  Future<void> createTrip(
    String origin,
    String destination,
    DateTime departureTime,
    DateTime departureDate,
  ) async {
    try {
      String tripId = firestore.collection("trips").doc().id;
      await firestore.collection("trips").doc(tripId).set({
        "tripId": tripId,
        "driverId": driverId,
        "origin": origin,
        "destination": destination,
        "departureTime": departureTime.toIso8601String(),
        "departureDate": departureDate.toIso8601String(),
        'tripStatus': TripStatus.WAITING.toString().split('.').last
      });
      Get.snackbar("Success", "Trip posted successfully");
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  Future<void> updateTripStatus(String tripId, String newStatus) async {
    await firestore.collection("trips").doc(tripId).update({
      "tripStatus": newStatus,
    });
  }

  Future<void> updateTrip(
      String tripId,
      String origin,
      String destination,
      DateTime departureTime,
      DateTime returnTime,
      int availableSeats,
      double price) async {
    try {
      await firestore.collection("trips").doc(tripId).update({
        "origin": origin,
        "destination": destination,
        "departureTime": departureTime.toIso8601String(),
        "returnTime": returnTime.toIso8601String(),
        "availableSeats": availableSeats,
        "price": price,
      });
      Get.snackbar("Success", "Trip updated successfully");
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  Future<void> deleteTrip(String tripId) async {
    try {
      await firestore.collection("trips").doc(tripId).delete();
      Get.snackbar("Success", "Trip deleted successfully");
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  Stream<QuerySnapshot> getTripsByStatus(TripStatus status) {
    return firestore
        .collection("trips")
        .where("tripStatus", isEqualTo: status.toString().split('.').last)
        .snapshots();
  }

  // Future<void> completeTrip(String tripId) async {
  //   try {
  //     await firestore.collection("trips").doc(tripId).update({
  //       "tripStatus": TripStatus.COMPLETE.toString().split('.').last,
  //     });
  //     Get.snackbar("Success", "Trip cancelled successfully");
  //   } catch (e) {
  //     Get.snackbar("Error", "Failed to cancel trip: ${e.toString()}");
  //   }
  // }
  Future<void> completeTrip(
      String tripId, String driverId, String userId) async {
    try {
      await firestore.collection("trips").doc(tripId).update({
        "tripStatus": TripStatus.COMPLETE.toString().split('.').last,
      });

      await firestore.collection("drivers").doc(driverId).update({
        "bonusPoints": FieldValue.increment(10),
      });

      await firestore.collection("tripFeedback").add({
        "tripId": tripId,
        "driverId": driverId,
        "userId": userId,
        "isAnswered": false,
        "note": "",
        "rating": 0,
        "createdAt": FieldValue.serverTimestamp(),
      });

      Get.snackbar("Success", "Trip completed and feedback entry created.");
    } catch (e) {
      Get.snackbar("Error", "Failed to complete trip: ${e.toString()}");
    }
  }

  Stream<List<Map<String, dynamic>>> getTripsByStatusWithUserInfo(
      TripStatus status) {
    String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';

    return firestore
        .collection("trips")
        .where("tripStatus", isEqualTo: status.toString().split('.').last)
        .where("driverId",
            isEqualTo: currentUserId) // Use current user id if available
        .snapshots()
        .asyncMap((snapshot) async {
      List<Map<String, dynamic>> tripsWithUserInfo = [];

      for (var doc in snapshot.docs) {
        var trip = doc.data();

        if (status == TripStatus.WAITING) {
          tripsWithUserInfo.add({
            ...trip,
            "userName": "Unknown",
            "userPhone": "Unknown",
            "driverName": "Unknown",
            "driverPhone": "Unknown",
          });
        } else {
          String userId = trip["userId"];
          String driverId = trip["driverId"];

          var userSnapshot =
              await firestore.collection("users").doc(userId).get();
          var user = userSnapshot.data();

          var driverSnapshot =
              await firestore.collection("drivers").doc(driverId).get();
          var driver = driverSnapshot.data();

          tripsWithUserInfo.add({
            ...trip,
            "userName": user?["name"] ?? "Unknown",
            "userPhone": user?["phone"] ?? "Unknown",
            "driverName": driver?["name"] ?? "Unknown",
            "driverPhone": driver?["phone"] ?? "Unknown",
            "vehicleType": driver?["vehicleType"] ?? "Unknown",
          });
        }
      }
      // lg.i(tripsWithUserInfo);
      return tripsWithUserInfo;
    });
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:trucklink/global/global_widgets.dart';
import 'package:trucklink/screens/users/usernavbar/usernavbarpage.dart';
import 'package:trucklink/state_managment/drivercontroller/trip_controller.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Add this import for Firebase Auth

class UserTripController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<List<Map<String, dynamic>>> getWaitingTripsWithDriverInfo() {
    return firestore
        .collection("trips")
        .where("tripStatus", isEqualTo: "WAITING")
        .snapshots()
        .asyncMap((snapshot) async {
      List<Map<String, dynamic>> tripsWithDriverInfo = [];
      for (var doc in snapshot.docs) {
        var trip = doc.data();
        String driverId = trip["driverId"];

        var driverSnapshot =
            await firestore.collection("drivers").doc(driverId).get();
        var driver = driverSnapshot.data();

        tripsWithDriverInfo.add({
          "tripId": trip["tripId"],
          "departureDate": trip["departureDate"],
          "departureTime": trip["departureTime"],
          "destination": trip["destination"],
          "origin": trip["origin"],
          "tripStatus": trip["tripStatus"],
          "driverName": driver?["name"],
          "driverPhone": driver?["phone"],
          "vehicleType": driver?["vehicleType"],
          "rating": driver?["rating"],
          "driverId": trip["driverId"]
        });
      }
      return tripsWithDriverInfo;
    });
  }

  Future<void> updateTripStatusToPending(String tripId, String userId) async {
    try {
      await firestore.collection("trips").doc(tripId).update({
        "tripStatus": "PENDING",
        "userId": userId,
      });
      Get.snackbar("Success", "Trip status updated to PENDING");
    } catch (e) {
      Get.snackbar("Error", "Failed to update trip status: ${e.toString()}");
    }
  }

  Stream<List<Map<String, dynamic>>> getTripsByStatusForUser(
      String status, String userId) {
    return firestore
        .collection("trips")
        .where("tripStatus", isEqualTo: status)
        .where("userId", isEqualTo: userId)
        .snapshots()
        .asyncMap((snapshot) async {
      List<Map<String, dynamic>> trips = [];
      for (var doc in snapshot.docs) {
        var trip = doc.data();
        String driverId = trip["driverId"];

        var driverSnapshot =
            await firestore.collection("drivers").doc(driverId).get();
        var driver = driverSnapshot.data();

        trips.add({
          "tripId": trip["tripId"],
          "departureDate": trip["departureDate"],
          "departureTime": trip["departureTime"],
          "destination": trip["destination"],
          "origin": trip["origin"],
          "tripStatus": trip["tripStatus"],
          "driverName": driver?["name"],
          "driverPhone": driver?["phone"],
          "vehicleType": driver?["vehicleType"],
          "rating": driver?["rating"],
        });
      }
      return trips;
    });
  }

  Future<void> cancelTrip(String tripId) async {
    try {
      await firestore.collection("trips").doc(tripId).update({
        "tripStatus": TripStatus.CANCEL.toString().split('.').last,
      });
      Get.snackbar("Success", "Trip cancelled successfully");
    } catch (e) {
      Get.snackbar("Error", "Failed to cancel trip: ${e.toString()}");
    }
  }

  Future<void> updateTripStatusToCompleted(String tripId) async {
    try {
      await firestore.collection("trips").doc(tripId).update({
        "tripStatus": "COMPLETED",
      });
      Get.snackbar("Success", "Trip status updated to COMPLETED");
    } catch (e) {
      Get.snackbar("Error", "Failed to update trip status: ${e.toString()}");
    }
  }

  Stream<List<Map<String, dynamic>>> getTripsByStatusWithUserInfo(
      TripStatus status) {
    String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';

    lg.i(currentUserId);
    return firestore
        .collection("trips")
        .where("tripStatus", isEqualTo: status.toString().split('.').last)
        .where("userId", isEqualTo: currentUserId)
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
          String driverId = trip["driverId"];

          var driverSnapshot =
              await firestore.collection("drivers").doc(driverId).get();
          var driver = driverSnapshot.data();

          tripsWithUserInfo.add({
            ...trip,
            "driverName": driver?["name"] ?? "Unknown",
            "driverPhone": driver?["phone"] ?? "Unknown",
            "vehicleType": driver?["vehicleType"] ?? "Unknown",
          });
        }
      }
      return tripsWithUserInfo;
    });
  }

  Future<void> checkForUnansweredFeedback() async {
    String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    if (userId.isEmpty) return;

    var feedbackSnapshot = await firestore
        .collection("tripFeedback")
        .where("userId", isEqualTo: userId)
        .where("isAnswered", isEqualTo: false)
        .limit(1)
        .get();

    if (feedbackSnapshot.docs.isNotEmpty) {
      var feedbackData = feedbackSnapshot.docs.first;
      Get.dialog(
        FeedbackDialog(feedbackId: feedbackData.id),
        barrierDismissible: false,
      );
    }
  }

  Future<Map<String, dynamic>> getDriverBonusAndRank(String driverId) async {
    try {
      // Fetch all drivers ordered by bonusPoints descending
      QuerySnapshot allDriversSnapshot = await FirebaseFirestore.instance
          .collection('drivers')
          .orderBy('bonusPoints', descending: true)
          .get();

      int rank = 0;
      int? bonusPoints;

      for (int i = 0; i < allDriversSnapshot.docs.length; i++) {
        var doc = allDriversSnapshot.docs[i];
        if (doc.id == driverId) {
          bonusPoints = doc['bonusPoints'] ?? 0;
          rank = i + 1; // Rank is 1-based
          break;
        }
      }

      if (bonusPoints == null) {
        throw Exception("Driver not found.");
      }

      return {
        'bonusPoints': bonusPoints,
        'rank': rank,
        'totalDrivers': allDriversSnapshot.docs.length,
      };
    } catch (e) {
      print("Error getting driver rank: $e");
      rethrow;
    }
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trucklink/screens/admin/adminnavbar.dart';
import 'package:trucklink/screens/admin/admin_sign_in.dart';

import 'package:trucklink/screens/users/userauth/usersignin.dart';
import 'package:trucklink/screens/users/usernavbar/usernavbarpage.dart';

class AdiminAuthController extends GetxController {
  static AdiminAuthController instance = Get.put(AdiminAuthController());

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseStorage storage = FirebaseStorage.instance;
  Rx<User?> firebaseUser = Rx<User?>(null);

  @override
  void onReady() {
    super.onReady();
    firebaseUser.bindStream(auth.authStateChanges());
    checkUserState();
  }

  
  Future<void> saveToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("adminauthToken", token);
  }

  
  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("adminauthToken");
  }


  Future<void> removeToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove("adminauthToken");
  }


  void checkUserState() async {
    User? user = auth.currentUser;
    String? token = await getToken();

    if (user != null && token != null) {
      Get.offAll(AdminNavbarr());
    } else {
      // Get.offAll(() => SignInScreen());
    }
  }


  Future<void> loginadmin(String email, String password, context) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);

     
      String? token = await userCredential.user!.getIdToken();
      if (token != null) await saveToken(token);

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => AdminNavbarr()),
        (route) => false,
      );
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  void logout(BuildContext context) async {
    try {
      await auth.signOut();
      await removeToken();
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => AdminSignInScreen(),
          ),
          (route) => false);
    } catch (e) {
      Get.snackbar("Logout Failed", e.toString());
    }
  }

 
  void verifyDriver(String driverId) async {
    try {
      await FirebaseFirestore.instance
          .collection("drivers")
          .doc(driverId)
          .update({"driverVerified": true});
      print("Driver verified successfully!");
    } catch (e) {
      print("Error verifying driver: $e");
    }
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:trucklink/screens/users/userauth/usersignin.dart';
import 'package:trucklink/screens/users/usernavbar/usernavbarpage.dart';

class UserAuthController extends GetxController {
  static UserAuthController instance = Get.put(UserAuthController());

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
    await prefs.setString("userauthToken", token);
  }

  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("userauthToken");
  }

  Future<void> removeToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove("userauthToken");
  }

  void checkUserState() async {
    User? user = auth.currentUser;
    String? token = await getToken();

    if (user != null && token != null) {
      Get.offAll(UserNavbarr());
    } else {
      // Get.offAll(() => SignInScreen());
    }
  }

  Future<void> registerUser(
      String name, String email, String password, String phone, context) async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      String uid = userCredential.user!.uid;

      String? token = await userCredential.user!.getIdToken();
      if (token != null) await saveToken(token);

      await firestore.collection("users").doc(uid).set({
        "uid": uid,
        "name": name,
        "email": email,
        "phone": phone,
        "password": password
      });

      Get.snackbar("Success", "Driver registered successfully");
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => UserNavbarr(),
        ),
        (route) => false,
      );
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  // Future<void> loginUser(String email, String password, context) async {
  //   try {
  //     UserCredential userCredential = await auth.signInWithEmailAndPassword(
  //         email: email, password: password);

  //     String? token = await userCredential.user!.getIdToken();
  //     if (token != null) await saveToken(token);

  //     Navigator.pushAndRemoveUntil(
  //       context,
  //       MaterialPageRoute(builder: (context) => UserNavbarr()),
  //       (route) => false,
  //     );
  //   } catch (e) {
  //     Get.snackbar("Error", e.toString());
  //   }
  // }

  Future<void> loginUser(
      String email, String password, BuildContext context) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      String uid = userCredential.user!.uid;

      // Check if user exists in 'users' collection
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (!userDoc.exists) {
        // Not a regular user, log them out and show error
        await auth.signOut();
        Get.snackbar(
            "Access Denied", "This account is not registered as a user.");
        return;
      }

      // Token and navigation
      String? token = await userCredential.user!.getIdToken();
      if (token != null) await saveToken(token);

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => UserNavbarr()),
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
            builder: (context) => UserSignInScreen(),
          ),
          (route) => false);
    } catch (e) {
      Get.snackbar("Logout Failed", e.toString());
    }
  }
}

import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trucklink/global/global_widgets.dart';
import 'package:trucklink/screens/drivers/driverauth/send_document.dart';
import 'package:trucklink/screens/drivers/driverauth/signin.dart';
import 'package:trucklink/screens/drivers/driverauth/waiting_screen.dart';
import 'package:trucklink/screens/drivers/navbar/navbar.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:googleapis_auth/auth_io.dart';
import 'package:path/path.dart';

class AuthController extends GetxController {
  static AuthController instance = Get.put(AuthController());
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
    await prefs.setString("authToken", token);
  }

  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("authToken");
  }

  Future<void> removeToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove("authToken");
  }

  void checkUserState() async {
    User? user = auth.currentUser;
    String? token = await getToken();

    if (user != null && token != null) {
      DocumentSnapshot userDoc =
          await firestore.collection("drivers").doc(user.uid).get();

      if (userDoc.exists) {
        bool verified = userDoc["driverVerified"];
        String licenseUrl = userDoc["licenseUrl"];

        if (licenseUrl.isEmpty && !verified) {
          Get.offAll(() => UploadLicenseScreen(uid: user.uid));
        } else if (licenseUrl.isNotEmpty && !verified) {
          Get.offAll(() => WaitingScreen());
        } else if (verified) {
          Get.offAll(() => Navbar());
        } else {
          Get.offAll(() => UploadLicenseScreen(uid: user.uid));
        }
      }
    } else {
      removeToken();
      // Get.offAll(() => SignInScreen());
    }
  }

  void registerDriver(String name, String email, String password, String phone,
      String vehicleType, String vehicleNumber, BuildContext context) async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      String uid = userCredential.user!.uid;
      String? token = await userCredential.user!.getIdToken();
      if (token != null) {
        await saveToken(token);
      }
      await firestore.collection("drivers").doc(uid).set({
        "uid": uid,
        "name": name,
        "email": email,
        "phone": phone,
        "vehicleType": vehicleType,
        "vehicleNumber": vehicleNumber,
        "licenseUrl": "",
        "driverVerified": false,
        "bonusPoints": 0,
        "rating": 5.0,
        "isfree": false,
        "isblocked": false
      });
      Get.snackbar("Success", "Driver registered successfully");

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => UploadLicenseScreen(uid: uid),
        ),
        (route) => false,
      );
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  // void loginDriver(String email, String password, BuildContext context) async {
  //   try {
  //     UserCredential userCredential = await auth.signInWithEmailAndPassword(
  //         email: email, password: password);
  //     String? token = await userCredential.user!.getIdToken();
  //     if (token != null) {
  //       await saveToken(token);
  //     }
  //     checkUserState();
  //   } catch (e) {
  //     Get.snackbar("Error", e.toString());
  //   }
  // }
  void loginDriver(String email, String password, BuildContext context) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);

      String uid = userCredential.user!.uid;

      // Check if user exists in 'drivers' collection
      DocumentSnapshot driverDoc =
          await FirebaseFirestore.instance.collection('drivers').doc(uid).get();

      if (!driverDoc.exists) {
        // Not a driver, log them out and show error
        await auth.signOut();
        Get.snackbar(
            "Access Denied", "This account is not registered as a driver.");
        return;
      }

      // Get token and continue
      String? token = await userCredential.user!.getIdToken();
      if (token != null) {
        await saveToken(token);
      }

      checkUserState(); // Continue with driver-specific navigation
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  void logout(context) async {
    try {
      await auth.signOut();
      await removeToken();

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => SignInScreen(),
        ),
        (route) => false,
      );
    } catch (e) {
      Get.snackbar("Logout Failed", e.toString());
    }
  }

  final _scopes = [drive.DriveApi.driveScope];

  Future<AuthClient> getHttpClient() async {
    final credentials = ServiceAccountCredentials.fromJson(
        File("credentials.json").readAsStringSync());
    return await clientViaServiceAccount(credentials, _scopes);
  }

  Future<String?> uploadFileToGoogleDrive(File file) async {
    final client = await getHttpClient();
    final driveApi = drive.DriveApi(client);

    var media = drive.Media(file.openRead(), file.lengthSync());
    var driveFile = drive.File()..name = basename(file.path);

    var response = await driveApi.files.create(driveFile, uploadMedia: media);
    return response.id;
  }

  Future<void> uploadLicense(
      String uid, File image, BuildContext context) async {
    try {
      GoogleDriveService googleDriveService = GoogleDriveService();
      String? fileId = await googleDriveService.uploadFileToGoogleDrive(image);

      if (fileId != null) {
        String googleDriveUrl =
            "https://drive.google.com/uc?export=view&id=$fileId";

        await FirebaseFirestore.instance
            .collection("drivers")
            .doc(uid)
            .update({"licenseUrl": googleDriveUrl});

        Get.snackbar("Success", "License uploaded successfully");
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => WaitingScreen()));
      } else {
        Get.snackbar("Error", "Failed to upload to Google Drive");
      }
    } catch (e) {
      lg.i(e.toString());
      Get.snackbar("Error", e.toString());
    }
  }
}

class GoogleDriveService {
  final _scopes = [drive.DriveApi.driveScope];

  Future<AuthClient> getHttpClient() async {
    final credentials = ServiceAccountCredentials.fromJson(
        File("credentials.json").readAsStringSync());
    return await clientViaServiceAccount(credentials, _scopes);
  }

  Future<String?> uploadFileToGoogleDrive(File file) async {
    final client = await getHttpClient();
    final driveApi = drive.DriveApi(client);

    var media = drive.Media(file.openRead(), file.lengthSync());
    var driveFile = drive.File()..name = basename(file.path);

    var response = await driveApi.files.create(driveFile, uploadMedia: media);
    return response.id;
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trucklink/screens/admin/admin_sign_in.dart';
import 'package:trucklink/screens/admin/adminpage.dart';
import 'package:trucklink/screens/drivers/driverauth/signin.dart';
import 'package:trucklink/screens/users/userauth/usersignin.dart';
import 'package:trucklink/state_managment/admincontroller/admin_controller.dart';
import 'package:trucklink/state_managment/drivercontroller/auth_controller.dart';
import 'package:trucklink/state_managment/usercontroller/userauth_controller.dart';

class UserSelectionScreen extends StatelessWidget {
  final UserAuthController userAuth = Get.put(UserAuthController());
  final AuthController authController = Get.put(AuthController());
  final AdiminAuthController adiminAuthController =
      Get.put(AdiminAuthController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Select User Type",
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () => Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AdminSignInScreen(),
                  ),
                  (route) => false),
              child: Image.asset(
                'assets/img/truck.png',
                width: 200,
                height: 160,
              ),
            ),
            SizedBox(
              height: 50,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SignInScreen(),
                    ));
              },
              child: Text("Login as Driver"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserSignInScreen(),
                    ));
              },
              child: Text("Login as Other User"),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trucklink/global/appcolors.dart';
import 'package:trucklink/screens/admin/admin_sign_in.dart';
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () => Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AdminSignInScreen(),
                  ),
                  (route) => false),
              child: Column(
                children: [
                  Image.asset(
                    'assets/img/logo.png',
                    width: 180,
                    height: 160,
                  ),
                ],
              ),
            ),
            SizedBox(height: 40),
            _buildLoginButton(
              context,
              "Login as Driver",
              Icons.local_shipping,
              AppColors.mainColor,
              () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SignInScreen(),
                    ));
              },
            ),
            SizedBox(height: 20),
            _buildLoginButton(
              context,
              "Login as Other User",
              Icons.person,
              AppColors.mainColor,
              () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserSignInScreen(),
                    ));
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginButton(BuildContext context, String text, IconData icon,
      Color color, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: Size(double.infinity, 50),
        backgroundColor: color,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
            fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }
}

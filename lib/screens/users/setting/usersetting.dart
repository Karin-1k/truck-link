import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trucklink/global/appcolors.dart';
import 'package:trucklink/state_managment/drivercontroller/auth_controller.dart';
import 'package:trucklink/state_managment/usercontroller/userauth_controller.dart';
import 'package:trucklink/screens/users/setting/userprofilepages.dart';

class UserSettingsPage extends StatelessWidget {
  UserSettingsPage({super.key});
  final UserAuthController authController = Get.put(UserAuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: AppColors.mainColor,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Optionally, add settings options like Profile, Change Password, etc.
            // ListTile(
            //   leading: const Icon(Icons.account_circle),
            //   title: const Text('Profile'),
            //   onTap: () {
            //     Get.toNamed('/profile'); // Navigate to profile page
            //   },
            // ),
            ListTile(
              leading: Icon(Icons.account_circle),
              title: Text('Profile'),
              trailing: Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserProfilePage(),
                    ));
              },
            ),

            const Spacer(),
            Center(
              child: ElevatedButton.icon(
                onPressed: () => authController.logout(context),
                icon: const Icon(
                  Icons.exit_to_app,
                  color: Colors.white,
                ),
                label: const Text('Logout'),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      AppColors.mainColor, // Use main color for logout button
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

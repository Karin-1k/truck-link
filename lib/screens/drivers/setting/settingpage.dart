import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trucklink/state_managment/drivercontroller/auth_controller.dart';
import 'package:trucklink/global/appcolors.dart'; // Ensure this is the correct import for your color theme

class SettingsPage extends StatelessWidget {
  SettingsPage({super.key});
  final AuthController authController = Get.put(AuthController());

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
            // Add any additional settings widgets here if needed
            // For example, uncomment to add a ListTile for Profile navigation
            // ListTile(
            //   leading: const Icon(Icons.account_circle),
            //   title: const Text('Profile'),
            //   onTap: () {
            //     Get.toNamed('/profile'); // Navigate to profile page
            //   },
            // ),
            const Spacer(),
            Center(
              child: ElevatedButton.icon(
                onPressed: () => authController.logout(context),
                icon: const Icon(
                  Icons.exit_to_app,
                  color: Colors.white, // Ensures the icon is white
                ),
                label: const Text(
                  'Logout',
                  style: TextStyle(
                      color: Colors.white), // Ensures the text is white
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.mainColor, 
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0), // Rounded button
                  ),
                ),
              ),
            ),
            SizedBox(height: 20), // Add some spacing after the button
          ],
        ),
      ),
    );
  }
}

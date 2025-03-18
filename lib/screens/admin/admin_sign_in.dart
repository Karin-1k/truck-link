import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trucklink/global/appcolors.dart';
import 'package:trucklink/screens/intro/user_selection_screen.dart';
import 'package:trucklink/state_managment/admincontroller/admin_controller.dart';

class AdminSignInScreen extends StatelessWidget {
  final AdiminAuthController authController = Get.put(AdiminAuthController());
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Admin Sign In",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.mainColor,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => UserSelectionScreen(),
              )),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Welcome Back, Admin!",
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    prefixIcon: Icon(Icons.email, color: AppColors.mainColor),
                  ),
                ),
                SizedBox(height: 15),
                TextField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: "Password",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    prefixIcon: Icon(Icons.lock, color: AppColors.mainColor),
                  ),
                  obscureText: true,
                ),
                SizedBox(height: 25),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      String email = emailController.text.trim();
                      String password = passwordController.text;

                      if (email.isEmpty || password.isEmpty) {
                        Get.snackbar("Error", "All fields are required.");
                        return;
                      }

                      if (!GetUtils.isEmail(email)) {
                        Get.snackbar(
                            "Error", "Please enter a valid email address.");
                        return;
                      }

                      authController.loginadmin(email, password, context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.mainColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      "Sign In",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trucklink/global/appcolors.dart';
import 'package:trucklink/screens/intro/user_selection_screen.dart';
import 'package:trucklink/screens/users/userauth/usersignup.dart';
import 'package:trucklink/state_managment/usercontroller/userauth_controller.dart';

class UserSignInScreen extends StatelessWidget {
  final UserAuthController authController = Get.put(UserAuthController());
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "User Sign In",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.mainColor,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.off(() => UserSelectionScreen()),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  "Welcome Back!",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "Sign in to continue",
                  style: TextStyle(color: Colors.grey[600]),
                ),
                // SizedBox(height: 30),
                const SizedBox(height: 20),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: "Email",
                    prefixIcon: const Icon(
                      Icons.email,
                      color: AppColors.mainColor,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: "Password",
                    prefixIcon: const Icon(
                      Icons.lock,
                      color: AppColors.mainColor,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 25),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.mainColor,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
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

                    authController.loginUser(email, password, context);
                  },
                  child: const Text(
                    "Sign In",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
                const SizedBox(height: 15),
                TextButton(
                  onPressed: () => Get.to(() => UserSignUpScreen()),
                  child: const Text(
                    "Don't have an account? Sign up",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
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

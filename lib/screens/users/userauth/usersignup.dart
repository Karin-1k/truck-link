import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trucklink/global/appcolors.dart';
import 'package:trucklink/state_managment/usercontroller/userauth_controller.dart';

class UserSignUpScreen extends StatelessWidget {
  final UserAuthController authController = Get.put(UserAuthController());

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "User Sign Up",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.mainColor,
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildTextField(nameController, "Full Name", Icons.person),
                const SizedBox(height: 10),
                _buildTextField(emailController, "Email", Icons.email),
                const SizedBox(height: 10),
                _buildTextField(
                  passwordController,
                  "Password",
                  Icons.lock,
                  isPassword: true,
                ),
                const SizedBox(height: 10),
                _buildTextField(phoneController, "Phone Number", Icons.phone),
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
                    String name = nameController.text.trim();
                    String email = emailController.text.trim();
                    String password = passwordController.text;
                    String phone = phoneController.text.trim();

                    if (name.isEmpty ||
                        email.isEmpty ||
                        password.isEmpty ||
                        phone.isEmpty) {
                      Get.snackbar("Error", "All fields are required.");
                      return;
                    }

                    if (!GetUtils.isEmail(email)) {
                      Get.snackbar(
                          "Error", "Please enter a valid email address.");
                      return;
                    }

                    if (password.length < 6) {
                      Get.snackbar(
                          "Error", "Password must be at least 6 characters.");
                      return;
                    }

                    authController.registerUser(
                        name, email, password, phone, context);
                  },
                  child: const Text(
                    "Sign Up",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon, {
    bool isPassword = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(
          icon,
          color: AppColors.mainColor,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}

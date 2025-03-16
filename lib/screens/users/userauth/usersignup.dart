import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
      appBar: AppBar(title: Text("user Sign Up")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: "Full Name"),
              ),
              TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: "Email"),
              ),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(labelText: "Password"),
                obscureText: true,
              ),
              TextField(
                controller: phoneController,
                decoration: InputDecoration(labelText: "Phone Number"),
              ),
              SizedBox(height: 20),
              ElevatedButton(
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
                child: Text("Sign Up"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

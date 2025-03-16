import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trucklink/state_managment/drivercontroller/auth_controller.dart';

class SignUpScreen extends StatefulWidget {
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final AuthController authController = Get.put(AuthController());

  final TextEditingController nameController = TextEditingController();

  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final TextEditingController phoneController = TextEditingController();

  final TextEditingController vehicleTypeController = TextEditingController();

  final TextEditingController vehicleNumberController = TextEditingController();

  final TextEditingController licenseUrlController = TextEditingController();

  final List<String> vehicleTypes = [
    "Pick Up",
    "Kia",
    "Kantar",
    "Atico",
    "Six",
    "Trela"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Driver Sign Up")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: "Full Name")),
              TextField(
                  controller: emailController,
                  decoration: InputDecoration(labelText: "Email")),
              TextField(
                  controller: passwordController,
                  decoration: InputDecoration(labelText: "Password"),
                  obscureText: true),
              TextField(
                  controller: phoneController,
                  decoration: InputDecoration(labelText: "Phone Number")),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: "Vehicle Type"),
                value: vehicleTypeController.text.isNotEmpty
                    ? vehicleTypeController.text
                    : null,
                items: vehicleTypes.map((String type) {
                  return DropdownMenuItem<String>(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    vehicleTypeController.text = newValue!;
                  });
                },
              ),
              TextField(
                  controller: vehicleNumberController,
                  decoration: InputDecoration(labelText: "Vehicle Number")),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  String email = emailController.text.trim();
                  String password = passwordController.text;

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

                  authController.registerDriver(
                      nameController.text,
                      email,
                      password,
                      phoneController.text,
                      vehicleTypeController.text,
                      vehicleNumberController.text,
                      context);
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

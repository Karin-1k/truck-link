import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trucklink/global/appcolors.dart';
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

  final List<String> vehicleTypes = [
    "Pick Up",
    "Kia",
    "Kantar",
    "Atico",
    "Sixs",
    "Trela"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Driver Sign Up",
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
                const SizedBox(height: 10),
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
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  decoration: _inputDecoration("Vehicle Type"),
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
                const SizedBox(height: 10),
                _buildTextField(vehicleNumberController, "Vehicle Number",
                    Icons.directions_car),
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
                      context,
                    );
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

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}

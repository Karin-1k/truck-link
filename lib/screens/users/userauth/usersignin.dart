import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
        title: Text("user Sign In"),
        backgroundColor: Colors.blue,
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: "Email"),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: "Password"),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                String email = emailController.text.trim();
                String password = passwordController.text;

           
                if (email.isEmpty || password.isEmpty) {
                  Get.snackbar("Error", "All fields are required.");
                  return;
                }

                if (!GetUtils.isEmail(email)) {
                  Get.snackbar("Error", "Please enter a valid email address.");
                  return;
                }

            
                authController.loginUser(email, password, context);
              },
              child: Text("Sign In"),
            ),
            TextButton(
              onPressed: () {
                Get.to(() => UserSignUpScreen());
              },
              child: Text("Don't have an account? Sign up"),
            ),
          ],
        ),
      ),
    );
  }
}

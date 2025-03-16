import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:trucklink/firebase_options.dart';
import 'package:get/get.dart';
import 'package:trucklink/screens/intro/splash_page.dart';
import 'package:trucklink/state_managment/screen_bindings.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: ScreenBindings(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: SplashPage(),
    );
  }
}

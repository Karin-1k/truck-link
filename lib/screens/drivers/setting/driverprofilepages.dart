import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trucklink/global/appcolors.dart';
import 'package:trucklink/state_managment/drivercontroller/auth_controller.dart';

class ProfilePageScreen extends StatefulWidget {
  const ProfilePageScreen({super.key});

  @override
  State<ProfilePageScreen> createState() => _ProfilePageScreenState();
}

class _ProfilePageScreenState extends State<ProfilePageScreen> {
  final AuthController authController = Get.find();
  Map<String, dynamic>? driver;

  @override
  void initState() {
    super.initState();
    loadDriverData();
  }

  Future<void> loadDriverData() async {
    final uid = authController.auth.currentUser?.uid;
    if (uid != null) {
      final doc = await FirebaseFirestore.instance.collection('drivers').doc(uid).get();
      if (doc.exists) {
        setState(() {
          driver = doc.data();
        });
      }
    }
  }

  Future<void> updateField(String key, String value) async {
    final uid = authController.auth.currentUser?.uid;
    if (uid != null) {
      await FirebaseFirestore.instance.collection('drivers').doc(uid).update({key: value});
      await loadDriverData(); // refresh UI
      Get.snackbar("Success", "$key updated");
    }
  }

  void showEditDialog(String fieldKey, String currentValue) {
    final controller = TextEditingController(text: currentValue);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit $fieldKey'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: 'Enter new $fieldKey',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final newValue = controller.text.trim();
              if (newValue.isNotEmpty) {
                await updateField(fieldKey, newValue);
                Navigator.pop(context);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Widget buildEditableTile(String label, String key) {
    return ListTile(
      tileColor: Colors.grey[100],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      title: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(driver?[key] ?? ''),
      trailing: IconButton(
        icon: const Icon(Icons.edit, color: Colors.blueAccent),
        onPressed: () => showEditDialog(key, driver?[key] ?? ''),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: AppColors.mainColor,
        centerTitle: true,
      ),
      body: driver == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  buildEditableTile('Name', 'name'),
                  const SizedBox(height: 12),
                  buildEditableTile('Phone', 'phone'),
                  const SizedBox(height: 12),
                  buildEditableTile('Email', 'email'),
                ],
              ),
            ),
    );
  }
}

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:trucklink/screens/drivers/navbar/navbar.dart';
import 'package:trucklink/state_managment/drivercontroller/auth_controller.dart';

class UploadLicenseScreen extends StatefulWidget {
  final String uid;
  UploadLicenseScreen({required this.uid});

  @override
  _UploadLicenseScreenState createState() => _UploadLicenseScreenState();
}

class _UploadLicenseScreenState extends State<UploadLicenseScreen> {
  File? _image;
  final picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Upload License")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _image == null
                ? Text("No image selected")
                : Image.file(_image!, height: 200),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickImage,
              child: Text("Pick Image"),
            ),
            ElevatedButton(
              onPressed: () {
                if (_image != null) {
                  AuthController.instance
                      .uploadLicense(widget.uid, _image!, context);
                } else {
                  Get.snackbar("Error", "Please select an image first");
                }
              },
              child: Text("Upload License"),
            ),
          ],
        ),
      ),
    );
  }
}

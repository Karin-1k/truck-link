import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:trucklink/global/appcolors.dart';
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
      appBar: AppBar(
        title: const Text(
          "Upload License",
        ),
        backgroundColor: AppColors.mainColor,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Image preview section
              _image == null
                  ? Icon(Icons.image,
                      size: 150,
                      color: AppColors
                          .mainColor) // Placeholder icon when no image is selected
                  : Image.file(
                      _image!,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit
                          .cover, // Make the image cover the space without distorting
                    ),
              const SizedBox(height: 20),

              // Pick Image button
              ElevatedButton(
                onPressed: _pickImage,
                child: const Text("Pick Image",
                    style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.mainColor, // Use main color
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 15),

              // Upload License button
              ElevatedButton(
                onPressed: () {
                  if (_image != null) {
                    AuthController.instance
                        .uploadLicense(widget.uid, _image!, context);
                  } else {
                    Get.snackbar("Error", "Please select an image first");
                  }
                },
                child: const Text(
                  "Upload License",
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.mainColor, // Use main color
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

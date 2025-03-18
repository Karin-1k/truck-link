import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:trucklink/global/appcolors.dart';
import 'package:trucklink/state_managment/admincontroller/admin_controller.dart';

class AdminPage extends StatelessWidget {
  final AdiminAuthController authController = Get.put(AdiminAuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Verify Drivers",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
        backgroundColor: AppColors.mainColor,
        elevation: 0,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("drivers")
            .where("driverVerified", isEqualTo: false)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          var drivers = snapshot.data!.docs;
          return ListView.builder(
            padding: EdgeInsets.all(10),
            itemCount: drivers.length,
            itemBuilder: (context, index) {
              var driver = drivers[index];

              return Card(
                elevation: 5,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: EdgeInsets.only(bottom: 15),
                child: ListTile(
                  contentPadding: EdgeInsets.all(16),
                  title: Text(
                    driver["name"],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.black87,
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Phone: ${driver["phone"]}",
                            style: TextStyle(color: Colors.grey[700])),
                        SizedBox(height: 5),
                        Text("Vehicle Number: ${driver["vehicleNumber"]}",
                            style: TextStyle(color: Colors.grey[700])),
                        SizedBox(height: 5),
                        Text("Vehicle Type: ${driver["vehicleType"]}",
                            style: TextStyle(color: Colors.grey[700])),
                        SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () {
                            _showImageViewer(context, driver["licenseUrl"]);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                AppColors.mainColor, // Using mainColor here
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            "View License",
                            style: TextStyle(fontSize: 14, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                  trailing: ElevatedButton(
                    onPressed: () {
                      authController.verifyDriver(driver.id);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          AppColors.mainColor, // Using mainColor here
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      "Verify",
                      style: TextStyle(fontSize: 14, color: Colors.white),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showImageViewer(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Container(
            width: double.infinity,
            height: 400,
            child: PhotoViewGallery.builder(
              itemCount: 1,
              builder: (context, index) {
                return PhotoViewGalleryPageOptions(
                  imageProvider: NetworkImage(imageUrl),
                  minScale: PhotoViewComputedScale.contained,
                  maxScale: PhotoViewComputedScale.covered * 2,
                );
              },
              scrollPhysics: BouncingScrollPhysics(),
              backgroundDecoration: BoxDecoration(color: Colors.black),
            ),
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:trucklink/state_managment/admincontroller/admin_controller.dart';

class AdminPage extends StatelessWidget {
  final AdiminAuthController authController = Get.put(AdiminAuthController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Verify Drivers")),
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
            itemCount: drivers.length,
            itemBuilder: (context, index) {
              var driver = drivers[index];

              return Card(
                margin: EdgeInsets.all(10),
                child: ListTile(
                  title: Text(driver["name"]),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Phone: ${driver["phone"]}"),
                      Text("Vehicle Number: ${driver["vehicleNumber"]}"),
                      Text("Vehicle Type: ${driver["vehicleType"]}"),
                      SizedBox(height: 5),
                      ElevatedButton(
                        onPressed: () {
                          _showImageViewer(context, driver["licenseUrl"]);
                        },
                        child: Text("View License"),
                      ),
                    ],
                  ),
                  trailing: ElevatedButton(
                    onPressed: () {
                      authController.verifyDriver(driver.id);
                    },
                    child: Text("Verify"),
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

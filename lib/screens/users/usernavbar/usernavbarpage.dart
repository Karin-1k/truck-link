import 'package:flutter/material.dart';
import 'package:trucklink/global/appcolors.dart';
import 'package:trucklink/screens/users/activity/activity.dart';
import 'package:trucklink/screens/users/home/homepage.dart';
import 'package:trucklink/screens/users/setting/usersetting.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trucklink/state_managment/usercontroller/usertrip_controller.dart';

class UserNavbarr extends StatefulWidget {
  const UserNavbarr({super.key});

  @override
  _UserNavbarrState createState() => _UserNavbarrState();
}

class _UserNavbarrState extends State<UserNavbarr> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    UserHomePage(),
    UserActivityPage(),
    UserSettingsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      Get.find<UserTripController>().checkForUnansweredFeedback();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Trips',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Activity',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor:
            AppColors.mainColor, // Use AppColors.mainColor for selected item
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}

class FeedbackDialog extends StatelessWidget {
  final String feedbackId;

  FeedbackDialog({required this.feedbackId});

  final TextEditingController noteController = TextEditingController();
  final RxInt selectedRating = 1.obs;

  void submitFeedback() async {
    await FirebaseFirestore.instance
        .collection("tripFeedback")
        .doc(feedbackId)
        .update({
      "isAnswered": true,
      "note": noteController.text,
      "rating": selectedRating.value,
    });
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Container(
            width: 400,
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Provide Feedback about your last trip",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                Text("Rate your experience:"),
                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    return GestureDetector(
                      onTap: () => selectedRating.value = index + 1,
                      child: Icon(
                        index + 1 <= selectedRating.value
                            ? Icons.star
                            : Icons.star_border,
                        color: Colors.amber,
                        size: 32,
                      ),
                    );
                  }),
                ),
                SizedBox(height: 15),
                TextField(
                  controller: noteController,
                  decoration: InputDecoration(
                    labelText: "Notes",
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: submitFeedback,
                      child: Text("Skip", style: TextStyle(color: Colors.grey)),
                    ),
                    ElevatedButton(
                      onPressed: submitFeedback,
                      child: Text("Submit"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.mainColor,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}

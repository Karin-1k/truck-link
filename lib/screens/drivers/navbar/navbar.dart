import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trucklink/screens/drivers/setting/settingpage.dart';
import 'package:trucklink/screens/drivers/trip/trip_list_screen.dart';
import 'package:trucklink/screens/drivers/trip/trip_posting_screen.dart';
import 'package:trucklink/global/appcolors.dart'; // Assuming you have a color theme in AppColors

class Navbar extends StatefulWidget {
  @override
  _NavbarState createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    TripPostingScreen(),
    TripListScreen(),
    SettingsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.add_road),
              label: 'Post Trip',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.list),
              label: 'Trips',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: AppColors.mainColor, // Customize based on theme
          unselectedItemColor: Colors.grey, // Color for unselected items
          onTap: _onItemTapped,
          backgroundColor: Colors.white, // Background color of the BottomNavigationBar
          elevation: 10, // Elevation for shadow effect
        ),
      ),
    );
  }
}

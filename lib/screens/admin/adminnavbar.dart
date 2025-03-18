import 'package:flutter/material.dart';
import 'package:trucklink/global/appcolors.dart';
import 'package:trucklink/screens/admin/admin_settings.dart';
import 'package:trucklink/screens/admin/adminpage.dart';

class AdminNavbarr extends StatefulWidget {
  const AdminNavbarr({super.key});

  @override
  _AdminNavbarrState createState() => _AdminNavbarrState();
}

class _AdminNavbarrState extends State<AdminNavbarr> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    AdminPage(),
    AdminSettingsPage(),
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
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.verified),
            label: 'Verify',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: AppColors.mainColor, // Set selected item color
        unselectedItemColor: Colors.grey, // Set unselected item color
        backgroundColor: Colors.white, // Set the background color of the navbar
        onTap: _onItemTapped,
        type: BottomNavigationBarType
            .fixed, // This helps if you want to keep more items fixed
        elevation: 10, // Add elevation to make it stand out
      ),
    );
  }
}

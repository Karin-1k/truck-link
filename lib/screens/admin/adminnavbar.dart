import 'package:flutter/material.dart';
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
            label: 'verify',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'setting',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}

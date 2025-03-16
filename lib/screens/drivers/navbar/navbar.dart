import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trucklink/screens/drivers/setting/settingpage.dart';
import 'package:trucklink/screens/drivers/trip/trip_list_screen.dart';
import 'package:trucklink/screens/drivers/trip/trip_posting_screen.dart';

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
      bottomNavigationBar: BottomNavigationBar(
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

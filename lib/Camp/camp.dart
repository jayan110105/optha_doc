import 'package:flutter/material.dart';
import 'package:opthadoc/Camp/camp_dashboard.dart';
import 'package:opthadoc/Camp/camp_registration.dart';


class Camp extends StatefulWidget {
  const Camp({super.key});

  @override
  State<Camp> createState() => _CampState();
}

class _CampState extends State<Camp> {
  int _selectedIndex = 0;

  final pages = [
    const CampDashboard(),
    const CampRegistration(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE9E6DB),
      appBar: _buildAppBar(),
      body: pages[_selectedIndex],
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.black,
      elevation: 0,
      toolbarHeight: 0, // Hides the app bar completely
    );
  }

  BottomNavigationBar _buildBottomNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: const Color(0xFF163352),
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white.withValues(alpha: 0.4),
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.person_add), label: 'Register'),
        BottomNavigationBarItem(icon: Icon(Icons.visibility), label: 'Checkup'),
        BottomNavigationBarItem(icon: Icon(Icons.assignment), label: 'Records'),
      ],
    );
  }
}

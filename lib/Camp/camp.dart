import 'package:flutter/material.dart';
import 'package:opthadoc/Camp/camp_dashboard.dart';
import 'package:opthadoc/Camp/camp_registration.dart';
import 'package:opthadoc/Camp/camp_eye_checkup.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:opthadoc/Camp/camp_examine.dart';

class Camp extends StatefulWidget {
  final String campCode;

  const Camp({super.key, required this.campCode});

  @override
  State<Camp> createState() => _CampState();
}

class _CampState extends State<Camp> {
  int _selectedIndex = 0;

  int initialEyeCheckupStep = 0;
  int initialExamineStep = 0;
  String? initialPatientToken = null;

  List<Widget> get pages => [
    CampDashboard(campCode: widget.campCode),
    CampRegistration(onNavigateToEyeCheckup: navigateToEyeCheckup, campCode: widget.campCode),
    CampEyeCheckup(initialStep: initialEyeCheckupStep, onNavigateToExamine: navigateToExamine, initialPatientToken: initialPatientToken,),
    CampExamine(initialStep: initialExamineStep,),
    // const CampRecords(),
  ];

  void navigateToEyeCheckup(int step, String PatientToken) {
    setState(() {
      initialEyeCheckupStep = step; // Set the initial step
      _selectedIndex = 2; // Navigate to CampEyeCheckup
      initialPatientToken = PatientToken;
      // print('Navigating to Eye Checkup with initial step: $initialEyeCheckupStep');
    });
  }

  void navigateToExamine(int step) {
    setState(() {
      initialExamineStep = step; // Set the initial step
      _selectedIndex = 3;          // Navigate to CampEyeCheckup
      // print('Navigating to Eye Checkup with initial step: $initialEyeCheckupStep');
    });
  }

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
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.person_add), label: 'Register'),
        BottomNavigationBarItem(icon: Icon(Icons.visibility), label: 'Refraction'),
        BottomNavigationBarItem(icon: SvgPicture.asset(
          'assets/icons/stethoscope.svg',
          colorFilter: ColorFilter.mode(
            _selectedIndex == 3
                ? Colors.white
                : Colors.white.withValues(alpha: 0.4),
            BlendMode.srcIn,
          ),
          height: 26.0,
          width: 26.0,
        ), label: 'Examine'),
        // BottomNavigationBarItem(icon: Icon(Icons.assignment), label: 'Records'),
      ],
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/screens/home_screen.dart';
import 'package:task_manager/screens/teams/mainteams_screen.dart';

import '../screens/chat/chat_screen_main.dart';
import '../screens/settings.dart';

class MainBottomNavBar extends StatefulWidget {
  @override
  _MainBottomNavBarState createState() => _MainBottomNavBarState();
}

class _MainBottomNavBarState extends State<MainBottomNavBar> {
  int _currentIndex = 0;

// Fetch the current user ID
  String? getCurrentUserId() {
    final user = FirebaseAuth.instance.currentUser;
    return user?.uid;
  }

  // List of screens corresponding to each bottom navigation item
  final List<Widget> _screens = [
    HomePage(), // Replace with your actual HomeScreen class
    CreateTeamScreen(), // Replace with your actual TeamsScreen class
    ChatScreen(teamId: 'O2F2gzy1Ia3RXcaQeIVl'), // Replace with your actual ChatScreen class
    SettingsPage(), // Replace with your actual SettingsScreen class
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Teams',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        type: BottomNavigationBarType.fixed, // Keeps all labels visible
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
      ),
    );
  }

}
import 'package:flutter/material.dart';

import '../../screens/teams/teams_home_screen.dart';


import 'package:firebase_auth/firebase_auth.dart';

// Fetch the current user ID
String? getCurrentUserId() {
  final user = FirebaseAuth.instance.currentUser;
  return user?.uid;
}

void navigateToTeamsListScreen(BuildContext context) {
  String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
// Get the current user ID
  if (userId != null) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TeamsListScreen(),
      ),
    );
  } else {
    // Handle unauthenticated user (e.g., redirect to login)
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('User not authenticated. Please log in.')),
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/screens/chat/chat_screen_main.dart';
import 'package:task_manager/screens/settings.dart';
import 'package:task_manager/screens/teams/teams_home_screen.dart';

import '../../screens/teams/notificationScreen.dart';

class HomeScreenDrawer extends StatelessWidget {
  HomeScreenDrawer({Key? key}) : super(key: key);
  final User? user = FirebaseAuth.instance.currentUser;
  final currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    // Fetch the logged-in user's email
    final userEmail = FirebaseAuth.instance.currentUser?.email ?? 'Unknown User';

    return Drawer(
      child: Column(
        children: [
          const DrawerHeader(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 40,
                  child: Icon(Icons.person),
                ),
                SizedBox(height: 8),
                Text(
                  "Hello, User!", // Replace with user name if available
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.people, color: Colors.blue),
            title: const Text("Teams"),
            onTap: () => Get.to(() => TeamsListScreen()),
          ),
          ListTile(
            leading: const Icon(Icons.chat, color: Colors.green),
            title: const Text("Chat"),
            onTap: () => Get.to(() =>MainChatScreen(currentUserId: currentUser!.uid,), // Replace with your actual ChatScreen class
            ),
          ),

          ListTile(
            leading: const Icon(Icons.email, color: Colors.orange),
            title: const Text("Notifications"),
            onTap: () => Get.to(() => NotificationsScreen()),
          ),
          ListTile(
            leading: const Icon(Icons.settings, color: Colors.orange),
            title: const Text("Settings"),
            onTap: () => Get.to(() => const SettingsPage()),
          ),
        ],
      ),
    );
  }
}

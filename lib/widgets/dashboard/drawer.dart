import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/screens/chat/chat_screen_main.dart';
import 'package:task_manager/screens/settings.dart';
import 'package:task_manager/screens/teams/teams_home_screen.dart';

class HomeScreenDrawer extends StatelessWidget {


  const HomeScreenDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
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
            onTap: () => Get.to(()=>TeamsListScreen()),
          ),
          ListTile(
            leading: const Icon(Icons.chat, color: Colors.green),
            title: const Text("Chat"),
            onTap: () => Get.to(()=>ChatScreen(teamId: 'O2F2gzy1Ia3RXcaQeIVl')),
          ),
          ListTile(
            leading: const Icon(Icons.settings, color: Colors.orange),
            title: const Text("Settings"),
            onTap: () => Get.to(()=>const SettingsPage()),
          ),
        ],
      ),
    );
  }
}

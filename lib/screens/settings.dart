import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/screens/themeprovider.dart';

import '../services/firebase_auth_service.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Account',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          ListTile(
            leading: const Icon(Icons.person, color: Colors.blue),
            title: const Text('Profile'),
            subtitle: const Text('Edit your profile details'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Navigate to Profile Settings
            },
          ),
          const Divider(),
          const Text(
            'Notifications',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          SwitchListTile(
            activeColor: Colors.green,
            title: const Text('Push Notifications'),
            subtitle: const Text('Get notified on your device'),
            value: false,
            onChanged: (value) {
              // Toggle Push Notifications
            },
          ),
          const Divider(),
          const Text(
            'Preferences',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          SwitchListTile(
            title: const Text('Dark Mode'),
            subtitle: const Text('Switch between light and dark themes'),
            value: themeProvider.themeMode == ThemeMode.dark,
            onChanged: (value) {
              themeProvider.toggleTheme();
            },
          ),
          const Divider(),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              minimumSize: const Size(double.infinity, 50),
            ),
            icon: const Icon(Icons.logout),
            label: const Text('Log Out'),
            onPressed: () => FirebaseAuthService().signOut(),

          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
        body:  ListView(
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
            ListTile(
              leading: const Icon(Icons.palette, color: Colors.purple),
              title: const Text('Theme'),
              subtitle: const Text('Light or Dark mode'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Navigate to Theme Settings
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
              onPressed: () {
                // Log out action
              },
            ),
          ],
        )
    );
  }
}


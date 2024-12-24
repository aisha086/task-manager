import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'chatscreen.dart'; // Individual Chat Screen

class MainChatScreen extends StatelessWidget {
  final String currentUserId; // Pass logged-in user's ID

  MainChatScreen({required this.currentUserId});

  @override
  Widget build(BuildContext context) {
    // Access the current theme's properties
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Team Chat"),
        backgroundColor: theme.appBarTheme.backgroundColor, // AppBar background color
        iconTheme: theme.appBarTheme.iconTheme, // AppBar icon theme
        titleTextStyle: theme.appBarTheme.titleTextStyle, // AppBar title text style
      ),
      body: Container(
        color: theme.canvasColor, // Background color of the body
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('users').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  color: theme.primaryColor, // Loading indicator color
                ),
              );
            }
            final users = snapshot.data!.docs;

            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                final userId = user.id;
                final userName = user['name'];

                // Don't show the current user in the list
                if (userId == currentUserId) return const SizedBox.shrink();

                return Card(
                  color: theme.cardColor, // Card background color
                  child: ListTile(
                    tileColor: theme.cardColor, // Background color for list tile
                    textColor: theme.textTheme.bodyMedium?.color, // Text color
                    iconColor: theme.iconTheme.color, // Icon color if needed
                    title: Text(
                      userName,
                      style: theme.textTheme.bodyMedium, // Use theme-defined text style
                    ),
                    onTap: () {
                      // Navigate to individual chat screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatScreen(
                            currentUserId: currentUserId,
                            otherUserId: userId,
                            otherUserName: userName,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

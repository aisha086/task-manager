import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/notification_service.dart';

class NotificationsScreen extends StatelessWidget {
  final NotificationService _notificationService = NotificationService();

  NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String currentUserId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('notifications')
            .where('receiverId', isEqualTo: currentUserId)
            .where('status', isEqualTo: 'pending')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const CircularProgressIndicator();

          var notifications = snapshot.data!.docs;

          if (notifications.isNotEmpty) {
            // If there is a pending notification, show a popup
            Future.delayed(Duration.zero, () {
              _showInvitationDialog(context, notifications.first);
            });
          }

          return ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              var notification = notifications[index];
              String notificationId = notification.id;

              return Card(
                child: ListTile(
                  title: Text('Join request for team: ${notification['teamName']}'),
                  subtitle: const Text('Do you want to join?'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.check, color: Colors.green),
                        onPressed: () async {
                          await _notificationService
                              .updateNotificationStatus(notificationId, 'accepted');
                          // Add member to the team
                          await FirebaseFirestore.instance
                              .collection('teams')
                              .doc(notification['teamId'])
                              .update({
                            'members': FieldValue.arrayUnion([FirebaseAuth.instance.currentUser!.uid]),
                          });
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.red),
                        onPressed: () async {
                          await _notificationService
                              .updateNotificationStatus(notificationId, 'rejected');
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  // Show a dialog to the user with the join request
  void _showInvitationDialog(BuildContext context, var notification) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Join request for ${notification['teamName']}'),
          content: const Text('Do you want to join the team?'),
          actions: [
            TextButton(
              onPressed: () async {
                await _notificationService.updateNotificationStatus(notification.id, 'accepted');
                await FirebaseFirestore.instance
                    .collection('teams')
                    .doc(notification['teamId'])
                    .update({
                  'members': FieldValue.arrayUnion([FirebaseAuth.instance.currentUser!.uid]),
                });
                Navigator.of(context).pop();
              },
              child: const Text('Accept'),
            ),
            TextButton(
              onPressed: () async {
                await _notificationService.updateNotificationStatus(notification.id, 'rejected');
                Navigator.of(context).pop();
              },
              child: const Text('Reject'),
            ),
          ],
        );
      },
    );
  }
}

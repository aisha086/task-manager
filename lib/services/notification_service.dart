import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  NotificationService() {
    _initializeLocalNotifications();
  }

  // Initialize local notifications
  void _initializeLocalNotifications() {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initializationSettings = InitializationSettings(
      android: androidSettings,
    );

    _localNotificationsPlugin.initialize(initializationSettings);
  }

  // Show a local notification
  Future<void> showLocalNotification(String title, String body) async {
    const androidDetails = AndroidNotificationDetails(
      'team_notifications', // Channel ID
      'Team Notifications', // Channel Name
      channelDescription: 'Notifications for team-related actions',
      importance: Importance.high,
      priority: Priority.high,
    );

    const notificationDetails = NotificationDetails(android: androidDetails);

    await _localNotificationsPlugin.show(
      0, // Notification ID
      title,
      body,
      notificationDetails,
    );
  }

  // Send join team notification to a user
  Future<void> sendJoinRequest({
    required String senderId,
    required String receiverEmail,
    required String teamId,
    required String teamName,
  }) async {
    try {
      // Fetch the receiver's user document using email
      var userQuery = await _firestore
          .collection('users')
          .where('email', isEqualTo: receiverEmail)
          .get();

      if (userQuery.docs.isEmpty) {
        throw Exception('User not found');
      }

      String receiverId = userQuery.docs.first.id;

      // Add a notification document in the 'notifications' collection
      await _firestore.collection('notifications').add({
        'teamId': teamId,
        'teamName': teamName,
        'senderId': senderId,
        'receiverId': receiverId,
        'status': 'pending', // Initial status
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Trigger local notification
      await showLocalNotification(
        'Team Invitation',
        'You have been invited to join the team "$teamName".',
      );
    } catch (e) {
      print('Error sending join request: $e');
      rethrow;
    }
  }

  // Update notification status
  Future<void> updateNotificationStatus(
      String notificationId, String status) async {
    await _firestore.collection('notifications').doc(notificationId).update({
      'status': status,
    });
  }
}

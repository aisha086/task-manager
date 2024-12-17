import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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

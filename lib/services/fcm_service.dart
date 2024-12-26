import 'dart:convert';
import 'package:http/http.dart' as http;
import 'fcm_key.dart';

class FCMService {
  static const String _fcmEndpoint =
      'https://fcm.googleapis.com/v1/projects/task-manager-e2302/messages:send';

  // 2. Add this service account key JSON from Firebase Console -> Project Settings -> Service Accounts -> Generate New Private Key

  static Future<void> sendFCMNotification({
    required String fcmToken,
    required String title,
    required String body,
    Map<String, dynamic>? data,
  }) async {
    try {
      final payload = {
        'message': {
          'token': fcmToken,
          'notification': {
            'title': title,
            'body': body,
          },
          if (data != null) 'data': data,
        },
      };

      // 3. Just add Authorization header with your service account key
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $serviceAccountJson',
      };

      final response = await http.post(
        Uri.parse(_fcmEndpoint),
        headers: headers,
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        print('FCM notification sent successfully: ${response.body}');
      } else {
        print('Failed to send FCM notification: ${response.body}');
      }
    } catch (e) {
      print('Error sending FCM notification: $e');
      rethrow;
    }
  }
}

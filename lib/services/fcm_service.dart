import 'package:googleapis_auth/auth_io.dart' as auth;
import 'dart:convert';
import 'package:flutter/services.dart';
import 'dart:developer' as devtools show log;

Future<bool> sendFCMNotification({
  required String fcmToken,
    required String title,
    required String body,
    Map<String, dynamic>? data,
}) async {
  final jsonCredentials = await rootBundle
      .loadString('assets/task-manager-e2302-50f926d01662.json');
  final creds = auth.ServiceAccountCredentials.fromJson(jsonCredentials);

  final client = await auth.clientViaServiceAccount(
    creds,
    ['https://www.googleapis.com/auth/cloud-platform'],
  );


  final notificationData = {
    'message': {
      'token': fcmToken,
      'notification':  {'title': title, 'body': body}
    },
  };

  const String senderId = '879238794434';
  final response = await client.post(
    Uri.parse('https://fcm.googleapis.com/v1/projects/$senderId/messages:send'),
    headers: {
      'content-type': 'application/json',
    },
    body: jsonEncode(notificationData),
  );

  client.close();
  if (response.statusCode == 200) {
    return true; // Success!
  }

  devtools.log(
      'Notification Sending Error Response status: ${response.statusCode}');
  devtools.log('Notification Response body: ${response.body}');
  return false;
}
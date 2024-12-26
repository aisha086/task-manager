// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
//
// class FCMService {
//   static const String _projectId = 'task-manager-e2302';
//   static final String _fcmEndpoint = 'https://fcm.googleapis.com/v1/projects/$_projectId/messages:send';
//
//   // Your service account details
//   static const Map<String, dynamic> _serviceAccount = {
//     "type": "service_account",
//     "project_id": "task-manager-e2302",
//     "private_key_id": "50f926d01662c60771866c24291b6d08212fefbb",
//     "private_key": """-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQC8UgQknaa4MBdM\n5jsu8xDb7icZ5Ll7jzeJE58QXN7I33eSaduCQfeeo9EBbzgTyWI/jy5CagW0OIVS\nRHrYYfaffZ4vv+neeO3MiD4jIljlP1aXB/UrxSowcvXlbJA9ntVKoQS5sItFCcmz\n3OEwf9NZ8ykNfrLOCWOfz5YTWK8GmiLmEBT7W5rkUWP7sWepsp+kGmFTUQjHKve3\nLOeKImbnaAt8z+Kj+HioEtu1ZJrBJqBQebFLdzmFdjVtttPV6QQSawZIev2uoKdW\n1VTvIW0xc96Br7PSgoQptTGaM6+AjnRJSQLWoihK7TmwW47kMQkWbkT4ZQMGTqbx\nO5msy3JbAgMBAAECggEACy5myZJvX4NCIZI6lFnhN+BcLk46xxUkoSfAQNVKyFbK\n/4SigF7l/WN7mYq0I9SdV+m/6jiSTcuHUEWkR5cKxhh2x8isxu/w1T0yTJ1m9Xbn\nxMA3tIQYh6zjtbNW8xmsT1SKdnNUKY1gY6SrMtkmwDH5pNqkx3/zjChj9ZJv6Jks\neEgu4E8OoI9DYKBRh+Vp9bmhRz/QnnvYfrHM7cToPBwHmWjfReOMRrZDYa+lOsbg\nQWyL/GYlNKNknriWcOWmlLdG2v0Y+53bl+9nN6bczHD3NXKEjqcaD4GDtzyfEZJj\nJqtGZv8gRBpHlJGiR2PsF6vDde4TZqm9B6VFwpKYOQKBgQDoqKOIk8zKN0eP/06r\nmM1cSl6Hn1P7XUSKz1atJ+LOobe9rXX4xH6VRwu6Ab++IJl55zfwsP9xtHmmkqSq\ncRdp4SCSbTItrPqPr8+bblThZqQ+AAHGaRwOAD+g/hvsUKWiclER3HaKMUCsf5kY\nastWI5WPnIDLPnRp5Aj0uApieQKBgQDPNqM4dPvBtkRldHYnf3s1QyajbFvi7TKI\n8MPMehjdvAQ/z8fendzCf/JTKw/llGf5/n4cE7ikgyaD3H5i+NntG5QZjaIipYU0\nmkrOGk3Ia3Ekgk+6ClhYtr0H+u3NG9XeUz1jk5oSnw9xn5oLeeCg+1fIwRiZDrXM\nz3eFks1mcwKBgQDWN1/LQvrOPbPAW/xdduWu0jLTgNncmXWgsWNHL3BffPsmw+3Z\nTWKXo8CiVTXsoyts2H3jObUZRmiz/FVtMY+zRzusVqpa7+gMIH5wyFeS6eTTyUHZ\nI7JXGdd8Ljwbi+3V8pe+cFUczFiV+y5FEx+BgmYUwq67dBfP38x3NnUpUQKBgQDA\nlXlRiXhK64nZ+UmvIA50zDpm/NjRqb6kA5EWxAvEWXBhlk2em32Hz756ibU2nJ2e\nfWbb1YBwdewf9ZgJiFuSwWT98uLT7J5G63fG4i+UrDb1xZ8vu1ms6fn6Jr9JOCun\nfBm8KHyz/d0urzVOoTGirLdDwCOKbV+OQOxG2s/H/QKBgF6avkxsI0F0IKXYKFBz\nLiYt6TgGccnuO07zo2wtB/whJOvT5YEaCpfRt/qWPB9AKvkMm6QWPa3TNmHgKW7B\n6F8o3RcPoOw910Ji3To4b1VdgMtDSmno62FgWXaRl18CTJgH2MN8fqXyLzEV/Zdv\n5Ve01pGJir8iNuS705icJmOx\n-----END PRIVATE KEY-----\n""",
//
//     "client_email": "firebase-adminsdk-sd9nw@task-manager-e2302.iam.gserviceaccount.com",
//     "client_id": "106150231687041580195",
//     "auth_uri": "https://accounts.google.com/o/oauth2/auth",
//     "token_uri": "https://oauth2.googleapis.com/token",
//     "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
//     "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-sd9nw%40task-manager-e2302.iam.gserviceaccount.com",
//     "universe_domain": "googleapis.com"
//   };
//
//   static String _generateJWT() {
//     final now = DateTime.now().toUtc();
//     final iat = now.millisecondsSinceEpoch ~/ 1000;
//     final exp = iat + 3600;
//
//
//     String cleanedPrivateKey = _serviceAccount['private_key'];
//
//     try {
//       final jwt = JWT(
//         {
//           'iss': _serviceAccount['client_email'],
//           'scope': 'https://www.googleapis.com/auth/firebase.messaging',
//           'aud': 'https://oauth2.googleapis.com/token',
//           'iat': iat,
//           'exp': exp,
//         },
//         header: {
//           'alg': 'RS256',
//           'typ': 'JWT',
//         },
//       );
//
//       final token = jwt.sign(
//         RSAPrivateKey(cleanedPrivateKey),
//         algorithm: JWTAlgorithm.RS256,
//       );
//
//       return token;
//     } catch (e) {
//       print('JWT Generation Error: $e');
//       rethrow;
//     }
//   }
//
//   static Future<String> _getAccessToken() async {
//     try {
//       final String jwt = _generateJWT();
//
//       final response = await http.post(
//         Uri.parse('https://oauth2.googleapis.com/token'),
//         headers: {
//           'Content-Type': 'application/x-www-form-urlencoded',
//         },
//         body: {
//           'grant_type': 'urn:ietf:params:oauth:grant-type:jwt-bearer',
//           'assertion': jwt,
//         },
//       );
//
//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         return data['access_token'];
//       } else {
//         print('Token request failed. Status: ${response.statusCode}, Body: ${response.body}');
//         throw Exception('Failed to get access token: ${response.body}');
//       }
//     } catch (e) {
//       print('Access Token Error: $e');
//       rethrow;
//     }
//   }
//
//   static Future<void> sendFCMNotification({
//     required String fcmToken,
//     required String title,
//     required String body,
//     Map<String, dynamic>? data,
//   }) async {
//     try {
//       final accessToken = await _getAccessToken();
//
//       final payload = {
//         'message': {
//           'token': fcmToken,
//           'notification': {
//             'title': title,
//             'body': body,
//           },
//           if (data != null) 'data': data,
//         },
//       };
//
//       final headers = {
//         'Content-Type': 'application/json',
//         'Authorization': 'Bearer $accessToken',
//       };
//
//       final response = await http.post(
//         Uri.parse(_fcmEndpoint),
//         headers: headers,
//         body: jsonEncode(payload),
//       );
//
//       if (response.statusCode == 200) {
//         print('FCM notification sent successfully: ${response.body}');
//       } else {
//         print('Failed to send FCM notification. Status: ${response.statusCode}, Body: ${response.body}');
//       }
//     } catch (e) {
//       print('Notification Error: $e');
//       rethrow;
//     }
//   }
// }


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
      'notification': data
    },
  };

  const String senderId = '736705283357';
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
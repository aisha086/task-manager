import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  // Request permission for iOS
  Future<void> requestPermission() async {
    await _firebaseMessaging.requestPermission();
  }

  // Initialize the Firebase messaging instance and handle background and foreground messages
  Future<void> initialize() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        // Display the notification or show a dialog
        print('Message received: ${message.notification!.title}');
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // Handle notification tap
      print('Message clicked!');
    });
  }

  // Get the token for sending notifications
  Future<String?> getToken() async {
    return await _firebaseMessaging.getToken();
  }
}

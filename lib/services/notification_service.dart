import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/timezone.dart' as tz;

import 'package:timezone/data/latest.dart' as tz;

import '../models/task.dart';
import '../screens/teams/notificationScreen.dart';
import 'fcm_service.dart';


class NotificationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static final NotificationService _instance = NotificationService._internal();
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  factory NotificationService() {
    return _instance;
  }

  NotificationService._internal();
  Future<void> init() async {
    tz.initializeTimeZones();
    initializeNotification();

    await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
  }

  static const String channelId = 'your_channel_id';
  static const String channelName = 'your_channel_name';
  static const String channelDescription = 'your_channel_description';

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  initializeNotification() async {
    configureLocalTimezone();
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings("@mipmap/ic_launcher");

    const InitializationSettings initializationSettings =
        InitializationSettings(
      iOS: initializationSettingsIOS,
      android: initializationSettingsAndroid,
    );
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
    );
  }

  final _androidNotificationDetails = const AndroidNotificationDetails(
      channelId, channelName,
      importance: Importance.max, priority: Priority.high, color: Colors.white);

  displayNotification({required String title, required String body}) async {
    var androidPlatformChannelSpecifics = _androidNotificationDetails;
    var drawinPlatformChannelSpecifics = const DarwinNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: drawinPlatformChannelSpecifics);
    return await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: title,
    );
  }

  scheduleNotification(Task task, DateTime dateTime) async {
    print("im scheduled");
    final tz.TZDateTime scheduledTime = tz.TZDateTime.from(dateTime, tz.local);
    print(scheduledTime);

    flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        "Time for ${task..name}",
        task.description,
        scheduledTime,
        NotificationDetails(android: _androidNotificationDetails),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.dateAndTime);
  }

  Future<void> cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  Future<void> configureLocalTimezone() async {
    final String timeZoneName = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));
  }

  //permissions
  void requestIOSPermissions() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  void requestAndroidPermissions() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    Permission.scheduleExactAlarm.request();
  }

  //response on taping notification
  Future<void> onDidReceiveNotificationResponse(
      NotificationResponse notificationResponse) async {
    final String? payload = notificationResponse.payload;
    if (payload != 'Default_Sound') {
      Get.to(() => NotificationsScreen());
    }
  }

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
      String? receiverToken = userQuery.docs.first.data()['fcmToken'];

      // Add a notification document in the 'notifications' collection
      await _firestore.collection('notifications').add({
        'teamId': teamId,
        'teamName': teamName,
        'senderId': senderId,
        'receiverId': receiverId,
        'status': 'pending', // Initial status
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Trigger FCM notification
      if (receiverToken != null && receiverToken.isNotEmpty) {
        await sendFCMNotification(
          fcmToken: receiverToken,
          title: 'Team Invitation',
          body: 'You have been invited to join the team "$teamName".',
          data: {
            'teamId': teamId,
            'teamName': teamName,
            'senderId': senderId,
          },
        );
      } else {
        print('Receiver does not have an FCM token.');
      }
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

  Future<void> firebaseMessagingForegroundHandler(
      RemoteMessage message) async {
    if (message.notification != null) {
      displayNotification(
          title: message.notification?.title ?? "Notification",
          body: message.notification?.body ?? "Notif body");
    }
  }




}

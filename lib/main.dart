import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/screens/authentication/login_screen.dart';
import 'package:task_manager/screens/home_screen.dart';
import 'package:task_manager/screens/launching/splash_screen.dart';
import 'package:task_manager/utils/notification_enabler.dart';
import 'package:task_manager/utils/themeprovider.dart';
import 'package:task_manager/services/notification_service.dart';
import 'package:task_manager/services/themes_service.dart';

import 'firebase_options.dart';

// FlutterLocalNotificationsPlugin instance
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await NotificationService().init();
  // Handle foreground messages
  FirebaseMessaging.onMessage.listen(
      NotificationService().firebaseMessagingForegroundHandler
  );


  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    Get.to(() => NotificationService());
  });

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => PushNotificationHandler()),

      ],
      child: const MyApp(),
    ),
  );
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Task Managers',
      themeMode: themeProvider.themeMode,
      theme: MyTheme.lightTheme(context),
      darkTheme: MyTheme.darkTheme(context),
      home: const SplashScreen(),
    );
  }
}

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return DashboardPage();
          } else {
            return const LoginPage();
          }
        },
      ),
    );
  }
}

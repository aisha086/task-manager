import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/databases/task_service.dart';
import 'package:task_manager/databases/team_service.dart';
import 'package:task_manager/screens/authentication/login_screen.dart';
import 'package:task_manager/screens/chat/chat_screen_main.dart';
import 'package:task_manager/screens/home_screen.dart';
import 'package:task_manager/screens/launching/splash_screen.dart';
import 'package:task_manager/services/themes_service.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FirebaseMessaging.onMessage.listen(_firebaseMessagingForegroundHandler);

 // Get.put(TeamService());
  runApp(const MyApp());
}
Future<void> _firebaseMessagingBackgroundHandler(
    RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
}

Future<void> _firebaseMessagingForegroundHandler(
    RemoteMessage message) async {
  print("Received a message: ${message.notification?.title}");
  // Show a local notification or a dialog
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Task Managers',
      themeMode: ThemeMode.system,
      theme: MyTheme.lightTheme(context),
      darkTheme: MyTheme.darkTheme(context),
      home:
      //ChatScreen(teamId: 'O2F2gzy1Ia3RXcaQeIVl'),
      const SplashScreen(),
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
          if(snapshot.hasData) {
            return DashboardPage();  //will add dashboard here
          } else{
            return const LoginPage();
          }
        },
      ),
    );
  }
}


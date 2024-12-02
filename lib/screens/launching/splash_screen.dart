import 'dart:async';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/main.dart';
import 'package:task_manager/screens/launching/on_boarding_screens.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool onBoardingAppeared = false;

  @override
  void initState() {
    getOnBoardingInfo();
    Timer(const Duration(seconds: 6), () {
      Get.off(() => onBoardingAppeared
                ? const AuthPage()
                : const OnboardingPage()
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
        body:
        Center(
          child: Container(
              margin: const EdgeInsets.only(top: 15,left: 30,right: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(Icons.edit_calendar_outlined,size: 40,),
                  Text("TASK\nMANAGER",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.oswald(
                      fontSize: 40,
                      color: Colors.white,
                    ),
                  ),
                ],
              )),
        ));
  }

  getOnBoardingInfo() async {
    final prefs = await SharedPreferences.getInstance();
    onBoardingAppeared = prefs.getBool("onboarding") ?? false;
  }


}
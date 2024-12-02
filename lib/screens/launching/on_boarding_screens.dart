import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager/main.dart';

import '../../data/on_boarding_data.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final controller = OnboardingData();
  final pageController = PageController();
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(child: body()),
          buildDots(),
          button(),
        ],
      ),
    );
  }

  //Body
  Widget body() {
    return Center(
      child: PageView.builder(
          onPageChanged: (value) {
            setState(() {
              currentIndex = value;
            });
          },
          itemCount: controller.items.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  //Title
                  Text(
                    controller.items[currentIndex].title,
                    style: TextStyle(
                        fontSize: 30,
                        color: Theme.of(context).primaryColor,
                      fontStyle: FontStyle.italic
                        ),
                    textAlign: TextAlign.center,
                  ),
                  // Image
                  SvgPicture.asset(
                    controller.items[currentIndex].image,
                    width: MediaQuery.of(context).size.width / 1.2,
                    // height: MediaQuery.of(context).size.height / 2.5,
                  ),
                  //Description
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Text(
                      controller.items[currentIndex].description,
                      style: const TextStyle(color: Colors.grey, fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }

  //Dots
  Widget buildDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
          controller.items.length,
          (index) => AnimatedContainer(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: currentIndex == index
                    ? Theme.of(context).primaryColor
                    : Colors.grey,
              ),
              height: 7,
              width: currentIndex == index ? 30 : 7,
              duration: const Duration(milliseconds: 700))),
    );
  }

  //Button
  Widget button() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      width: MediaQuery.of(context).size.width * .9,
      height: 55,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Theme.of(context).primaryColor),
      child: TextButton(
        onPressed: () {
          setState(() {
            if (currentIndex != controller.items.length - 1) {
              currentIndex++;
            } else {
              setOnBoardingToTrue();
              Get.to(() => const AuthPage());
            }
          });
        },
        child: Text(
          currentIndex == controller.items.length - 1
              ? "Get started"
              : "Continue",
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  setOnBoardingToTrue() async {
    final pref = await SharedPreferences.getInstance();
    pref.setBool("onboarding", true);
  }
}

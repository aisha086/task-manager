import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../services/firebase_auth_service.dart';

class GoogleButton extends StatelessWidget {
  GoogleButton({super.key, required this.isSigning});

  final FirebaseAuthService authService = FirebaseAuthService();

  final bool isSigning;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return ElevatedButton(
        style: ButtonStyle(
            // backgroundColor: WidgetStatePropertyAll((MyTheme.lightIconColor),
            fixedSize:
            WidgetStatePropertyAll( Size(size.width/2, 50)),
            shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25)))),
        onPressed: () => authService.signInWithGoogle(),
        child: isSigning
            ? const CircularProgressIndicator()
            : const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Continue with ",
              style: TextStyle(fontSize: 18,color: Colors.white),
            ),
            Icon(FontAwesomeIcons.google,color: Colors.white,)
          ],
        ));
  }
}
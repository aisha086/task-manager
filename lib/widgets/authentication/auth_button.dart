import 'package:flutter/material.dart';

class AuthButton extends StatelessWidget {
  const AuthButton(
      {Key? key,
        required this.text,
        required this.onPressed,
        required this.isSigning})
      : super(key: key);
  final bool isSigning;
  final String text;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ButtonStyle(
            minimumSize:
            const WidgetStatePropertyAll(Size(double.infinity, 50)),
            shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)))),
        onPressed: onPressed,
        child: isSigning
            ? const CircularProgressIndicator()
            : Text(
          text,
          style: const TextStyle(fontSize: 18,color: Colors.white),
        ));
  }
}

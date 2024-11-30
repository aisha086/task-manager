import 'package:flutter/material.dart';

import '../../services/firebase_auth_service.dart';
import '../../widgets/authentication/auth_button.dart';
import '../../widgets/authentication/google_button.dart';
import '../../widgets/authentication/text_form_field.dart';
import '../../widgets/toast.dart';



class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();

}

class _SignUpState extends State<SignUp> {

  bool isSigning = false;
  bool isGoogleSigning = false;
  FirebaseAuthService authService = FirebaseAuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
  TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _nameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Theme.of(context).primaryColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildTitleSection(context),
            Expanded(
              flex: 5,
              child: Container(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 80),
                decoration: BoxDecoration(
                    color: Theme.of(context).canvasColor,
                    borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(50))),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CredentialsForm(
                        isPassword: false,
                        labelText: "Name",
                        controller: _nameController,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      CredentialsForm(
                        isPassword: false,
                        labelText: "Email",
                        controller: _emailController,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      CredentialsForm(
                        isPassword: true,
                        labelText: "Password",
                        controller: _passwordController,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      CredentialsForm(
                        isPassword: true,
                        labelText: "Confirm Password",
                        controller: _confirmPasswordController,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      AuthButton(
                        text: "Sign Up",
                        onPressed: _signUp,
                        isSigning: isSigning,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      const Text("OR"),
                      const SizedBox(
                        height: 15,
                      ),
                      GoogleButton(isSigning: isGoogleSigning),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Already have an account?"),
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text("Log In"))
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _signUp() async {
    setState(() {
      isSigning = true;
    });
    String name = _nameController.text;
    String email = _emailController.text;
    String password = _passwordController.text;

    if (password == _confirmPasswordController.text) {
      await authService.signUpWithEmailAndPassword(email, password);
      Navigator.pop(context);
    } else {
      showToast("Passwords don't match!");
      setState(() {
        isSigning = false;
      });
    }
  }

}

Widget buildTitleSection(BuildContext context) {
  return const Expanded(
    flex: 2,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Sign Up",
            textAlign: TextAlign.left,
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 40,
              // color: MyTheme.lightCanvasColor,
            ),
          ),
          Text(
            "Join us!",
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 20,
              // color: MyTheme.lightCanvasColor,
            ),
          )
        ],
      ),
    ),
  );
}
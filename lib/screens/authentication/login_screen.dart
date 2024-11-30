import 'package:flutter/material.dart';
import 'package:task_manager/screens/authentication/sign_up_screen.dart';

import '../../services/firebase_auth_service.dart';
import '../../widgets/authentication/auth_button.dart';
import '../../widgets/authentication/google_button.dart';
import '../../widgets/authentication/text_form_field.dart';
import '../../widgets/toast.dart';
import 'forget_password.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  FirebaseAuthService authService = FirebaseAuthService();
  bool isSigning = false;
  bool isGoogleSigning = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Column(
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
                      labelText: "Email",
                      controller: _emailController,
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                      const ResetPasswordPage()));
                            },
                            child: const Text("Forgot Password"))
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    AuthButton(
                      text: "Log In",
                      onPressed: _signIn,
                      isSigning: isSigning,
                    ),
                    // Todo: make the google sign in work with customer database
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
                        const Text("Don't have an account?"),
                        TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                      const SignUp()));
                            },
                            child: const Text("Sign Up"))
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _signIn() async {
    setState(() {
      isSigning = true;
    });
    String email = _emailController.text;
    String password = _passwordController.text;


    await authService.signInWithEmailAndPassword(email, password,);

    setState(() {
      isSigning = false;
    });
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
            "Login",
            textAlign: TextAlign.left,
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 40,
              // color: MyTheme.lightCanvasColor,
            ),
          ),
          Text(
            "Lets start getting organized",
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 26,
              // color: MyTheme.lightCanvasColor,
            ),
          )
        ],
      ),
    ),
  );
}


import 'package:flutter/material.dart';
import 'package:notes/services/auth/auth.dart';
import '../constants/routes.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Verify Email',
        ),
      ),
      body: Column(
        children: [
          const Text(
              "We've sent you a verification email, Please open it to verify your account"),
          const Text(
              "If you haven't received a verification email yet, Press the button below ⬇️"),
          TextButton(
            onPressed: () async {
              await AuthService.firebase().sendEmailVerification();
            },
            child: const Text("Send Email Verification"),
          ),
          TextButton(
            onPressed: () async {
              final navigator = Navigator.of(context);
              await AuthService.firebase().logOut();
              navigator.pushNamedAndRemoveUntil(
                registerRoute,
                (route) => false,
              );
            },
            child: const Text("Restart"),
          ),
        ],
      ),
    );
  }
}

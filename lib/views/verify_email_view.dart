import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../constants/routes.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({Key? key}) : super(key: key);

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify email'),
      ),
      body: Column(
          children: [
            const Text("We've sent you an email for verification. Please open it to verify your account\n(Kindly check the spam folder also in case not found)."),
            const Text('Press the button bellow if not received the email yet'),
            TextButton(
              onPressed: () async {
                final user = FirebaseAuth.instance.currentUser;
                await user?.sendEmailVerification();
                if (!mounted) return;
                Navigator.of(context).pushNamedAndRemoveUntil(loginRoute, (route) => false);
              }, 
              child: const Text('Send email verification'),
            ),
            TextButton(onPressed: () async {
              await FirebaseAuth.instance.signOut();
              if (!mounted) return;
              Navigator.of(context).pushNamedAndRemoveUntil(home, (route) => false);
            }, 
            child: const Text('Go back to login/register'),
            ),
          ],
        ),
    );
  }
}
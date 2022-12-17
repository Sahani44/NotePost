import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_post/services/auth/bloc/auth_bloc.dart';
import 'package:note_post/services/auth/bloc/auth_event.dart';

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
                context.read<AuthBloc>().add(const AuthEventSendEmailVerification());
              }, 
              child: const Text('Send email verification'),
            ),
            TextButton(onPressed: () async {
              // await AuthService.firebase().logOut();
              // if (!mounted) return;
              // Navigator.of(context).pushNamedAndRemoveUntil(home, (route) => false);
              context.read<AuthBloc>().add(const AuthEventLogOut());
            }, 
            child: const Text('Go back to login/register'),
            ),
          ],
        ),
    );
  }
}
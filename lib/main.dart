import 'package:flutter/material.dart';
import 'package:note_post/constants/routes.dart';
import 'package:note_post/services/auth/auth_service.dart';
import 'package:note_post/views/login_view.dart';
import 'package:note_post/views/notes/new_note_view.dart';
import 'package:note_post/views/notes/notes_view.dart';
import 'package:note_post/views/register_view.dart';
import 'package:note_post/views/verify_email_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
      routes: {
        loginRoute : (context) => const LoginView(),
        registerRoute : (context) => const RegisterView(),
        notesRoute :(context) => const NotesView(),
        verifyEmailRoute :(context) => const VerifyEmailView(),
        newNoteRoute: (context) => const NewNoteView()
      },
    );
  }
}


class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: AuthService.firebase().initialize(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState){
            case ConnectionState.done: 
              final user = AuthService.firebase().currentUser;
              if(user != null) {
                if(user.isEmailVerified) {
                  return const NotesView();
                } else {
                  return const VerifyEmailView(); 
                }
              } else {
                return const LoginView();
              }
              
            default : return const CircularProgressIndicator();
            
          }
        },
      );
  }
}



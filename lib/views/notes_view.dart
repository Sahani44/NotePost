import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


enum MenuAction {
  logout
}


class NotesView extends StatefulWidget {
  const NotesView({Key? key}) : super(key: key);

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
        actions: [
          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              switch(value) {
                
                case MenuAction.logout:
                  final shouldLogOut = await showLogOutDialog(context);
                  if(shouldLogOut) {
                    await FirebaseAuth.instance.signOut();
                    if (!mounted) return;
                     Navigator.of(context).pushNamedAndRemoveUntil('/login/', (_) => false);
                  }
                  break;
              }
            },
            itemBuilder: (context) {
              return const [ //returning in list form
                PopupMenuItem<MenuAction>(value : MenuAction.logout,child: Text('Log out'))
              ]; 
            },
          )
        ],
        ),
      body: const Text('Notess'),
    );
  }
}


Future<bool> showLogOutDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
     builder: (context) {
      return AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to quit'),
        actions: [
          TextButton(onPressed: () {Navigator.of(context).pop(false);}, child: const Text('Cancel')),
          TextButton(onPressed: () {Navigator.of(context).pop(true);}, child: const Text('Sign Out')),
        ],
      );
     }
  ).then((value) => value ?? false);
}
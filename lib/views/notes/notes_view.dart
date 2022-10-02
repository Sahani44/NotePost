import 'package:flutter/material.dart';
import 'package:note_post/constants/routes.dart';
import 'package:note_post/services/auth/auth_service.dart';
import 'package:note_post/services/crud/notes_services.dart';
import '../../enums/menu_actions.dart';


class NotesView extends StatefulWidget {
  const NotesView({Key? key}) : super(key: key);

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {

  late final NotesServices _notesServices;
  String get userEmail => AuthService.firebase().currentUser!.email!;

  @override
  void initState() {
    _notesServices = NotesServices();
    super.initState();
  }

  @override
  void dispose() {
    _notesServices.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
        actions: [
          IconButton(onPressed: () {
            Navigator.of(context).pushNamed(newNoteRoute);
          }, icon: const Icon(Icons.add)),
          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              switch(value) {
                case MenuAction.logout:
                  final shouldLogOut = await showLogOutDialog(context);
                  if(shouldLogOut) {
                    await AuthService.firebase().logOut();
                    if (!mounted) return;
                    Navigator.of(context).pushNamedAndRemoveUntil('/', (_) => false);
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
      body: FutureBuilder(
        future: _notesServices.getOrCreateUser(email: userEmail),
        builder: (context,snapshot) {
          switch (snapshot.connectionState) { 
            case ConnectionState.done:
              return StreamBuilder(
                stream: _notesServices.allNotes,
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    
                    case ConnectionState.waiting:
                      return const Text('Waiting for all notes');
                    default : 
                      return const CircularProgressIndicator();
                  }
                },
              );
            default : return const CircularProgressIndicator();
          }
        }
        ),
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
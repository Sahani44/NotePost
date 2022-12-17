import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_post/constants/routes.dart';
import 'package:note_post/services/auth/auth_service.dart';
import 'package:note_post/services/auth/bloc/auth_bloc.dart';
import 'package:note_post/services/auth/bloc/auth_event.dart';
import 'package:note_post/services/crud/notes_services.dart';
import 'package:note_post/views/notes/notes_list_view.dart';
import '../../enums/menu_actions.dart';
import '../../utilities/dialogs/logout_dialog.dart';


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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
        actions: [
          IconButton(onPressed: () {
            Navigator.of(context).pushNamed(createOrUpdateNoteRoute);}, 
            icon: const Icon(Icons.add)),
          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              switch(value) {
                case MenuAction.logout:
                  final shouldLogOut = await showLogOutDialog(context);
                  if(shouldLogOut) {
                    context.read<AuthBloc>().add(const AuthEventLogOut());
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
                    case ConnectionState.active:
                      if (snapshot.hasData) {
                        final allNotes = snapshot.data as List<DatabaseNote>;
                        // ignore: avoid_print
                        print(allNotes);
                        return NotesListView(
                          notes: allNotes, 
                          onDeleteNote: ((note) async {
                            await _notesServices.deleteNote(id: note.id);
                          }), 
                          onTap: (DatabaseNote note) { 
                            Navigator.of(context).pushNamed(
                              createOrUpdateNoteRoute,
                              arguments: note,
                            );
                           },);
                      } else {
                        return const CircularProgressIndicator();
                      }
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



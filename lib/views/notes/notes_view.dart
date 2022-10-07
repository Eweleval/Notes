import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/constants/routes.dart';
import 'package:notes/enums/menu_actions.dart';
import 'package:notes/extensions/extensions.dart';
import 'package:notes/services/auth/auth.dart';
import 'package:notes/services/cloud/cloud.dart';
import 'package:notes/utilities/utilities.dart';
import 'package:notes/views/notes/notes.dart';

extension Count<T extends Iterable> on Stream<T> {
  Stream<int> get getLength => map((event) => event.length);
}

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  late final FirebaseCloudStorage _notesService;
  String get userId => AuthService.firebase().currentUser!.id;

  @override
  void initState() {
    _notesService = FirebaseCloudStorage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: StreamBuilder(
            stream: _notesService.allNotes(ownerUserId: userId).getLength,
            builder: (context, AsyncSnapshot<int> snapshot) {
              if (snapshot.hasData) {
                final noteCount = snapshot.data ?? 0;
                final text = context.loc.notes_title(noteCount);
                return Text(text);
              } else {
                return const Text('');
              }
            },
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(createOrUpdateNoteRoute);
              },
              icon: const Icon(Icons.add),
            ),
            PopupMenuButton<MenuAction>(
              onSelected: (value) async {
                final contexts = context.read<AuthBloc>();
                switch (value) {
                  case MenuAction.logout:
                    final shouldLogout = await showLogOutDialog(context);
                    if (shouldLogout) {
                      contexts.add(
                        const AuthEventLogOut(),
                      );
                    }
                }
              },
              itemBuilder: (context) {
                return [
                  PopupMenuItem<MenuAction>(
                    value: MenuAction.logout,
                    child: Text(context.loc.logout_button),
                  ),
                ];
              },
            ),
          ],
        ),
        body: StreamBuilder(
          stream: _notesService.allNotes(ownerUserId: userId),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
              case ConnectionState.active:
                if (snapshot.hasData) {
                  final allNotes = snapshot.data as Iterable<CloudNote>;
                  return NotesListView(
                    notes: allNotes,
                    onDeleteNote: (note) async {
                      await _notesService.deleteNote(
                          documentId: note.documentId);
                    },
                    onTap: (note) async {
                      Navigator.of(context).pushNamed(
                        createOrUpdateNoteRoute,
                        arguments: note,
                      );
                    },
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              default:
                return const Center(child: CircularProgressIndicator());
            }
          },
        ));
  }
}

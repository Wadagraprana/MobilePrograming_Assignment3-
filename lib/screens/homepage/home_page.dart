import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../firestore.dart';
import '../notification/notification_service.dart';
import 'note_details.dart';
import '../authentication/login.dart';

final FirestoreService firestoreService = FirestoreService();
final TextEditingController titleController = TextEditingController();
final TextEditingController noteController = TextEditingController();
final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void openNoteBox({String? docID, String? existingTitle, String? existingNote}) {
    titleController.text = existingTitle ?? '';
    noteController.text = existingNote ?? '';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(docID == null ? 'Add Note' : 'Update Note'),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: noteController,
                decoration: const InputDecoration(labelText: 'Notes'),
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a note';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                final title = titleController.text.trim();
                final note = noteController.text.trim();
                Navigator.pop(context);

                if (docID == null) {
                  firestoreService.addNote(title, note);
                } else {
                  firestoreService.updateNote(docID, title, note);
                }

                titleController.clear();
                noteController.clear();
              }
            },
            child: Text(docID == null ? 'Add' : 'Update'),
          ),
        ],
      ),
    ).then((_) {
      titleController.clear();
      noteController.clear();
    });
  }

  void logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const LoginScreen();

        final userEmail = snapshot.data!.email ?? '';

        return Scaffold(
          appBar: AppBar(
            title: const Text("Firestore Notes"),
          ),

          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                const DrawerHeader(
                  decoration: BoxDecoration(color: Colors.blue),
                  child: Text('Menu Notification', style: TextStyle(color: Colors.white, fontSize: 24)),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
                  child: OutlinedButton(
                    onPressed: () async {
                      await NotificationService.createNotification(
                        id: 1,
                        title: 'Default Notification',
                        body: 'This is the body of the notification',
                        summary: 'Small summary',
                      );
                    },
                    child: const Text('Default Notification'),
                  )
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
                  child: OutlinedButton(
                    onPressed: () async {
                      await NotificationService.createNotification(
                        id: 2,
                        title: 'Notification with Summary',
                        body: 'This is the body of the notification',
                        summary: 'Small summary',
                        notificationLayout: NotificationLayout.Inbox,
                      );
                    },
                    child: const Text('Notification with Summary'),
                    )
                  ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
                  child: OutlinedButton(
                    onPressed: () async {
                      await NotificationService.createNotification(
                        id: 3,
                        title: 'Progress Bar Notification',
                        body: 'This is the body of the notification',
                        summary: 'Small summary',
                        notificationLayout: NotificationLayout.ProgressBar,
                      );
                    },
                    child: const Text('Progress Bar Notification'),
                  )
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
                  child: OutlinedButton(
                    onPressed: () async {
                      await NotificationService.createNotification(
                        id: 4,
                        title: 'Message Notification',
                        body: 'This is the body of the notification',
                        summary: 'Small summary',
                        notificationLayout: NotificationLayout.Messaging,
                      );
                    },
                    child: const Text('Message Notification'),
                  )
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
                  child: OutlinedButton(
                    onPressed: () async {
                      await NotificationService.createNotification(
                        id: 5,
                        title: 'Big Image Notification',
                        body: 'This is the body of the notification',
                        summary: 'Small summary',
                        notificationLayout: NotificationLayout.BigPicture,
                        bigPicture: 'https://picsum.photos/300/200',
                      );
                    },
                    child: const Text('Big Image Notification'),
                  )
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
                  child: OutlinedButton(
                    onPressed: () async {
                      await NotificationService.createNotification(
                        id: 5,
                        title: 'Action Button Notification',
                        body: 'This is the body of the notification',
                        payload: {'navigate': 'true'},
                        actionButtons: [
                          NotificationActionButton(
                            key: 'action_button',
                            label: 'Click me',
                            actionType: ActionType.Default,
                          )
                        ],
                      );
                    },
                    child: const Text('Action Button Notification'),
                  )
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
                  child: OutlinedButton(
                    onPressed: () async {
                      await NotificationService.createNotification(
                        id: 5,
                        title: 'Scheduled Notification',
                        body: 'This is the body of the notification',
                        scheduled: true,
                        interval: Duration(seconds: 5),
                      );
                    },
                    child: const Text('Scheduled Notification'),
                  )
                ),
              ],
            ),
          ),



          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Logged in as $userEmail',
                  style: const TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: 14,
                  ),
                ),
              ),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: firestoreService.getNotesStream(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final notesList = snapshot.data!.docs;

                      return ListView.builder(
                        itemCount: notesList.length,
                        itemBuilder: (context, index) {
                          final document = notesList[index];
                          final docID = document.id;
                          final data = document.data() as Map<String, dynamic>;
                          final noteTitle = data['title'] ?? '';
                          final noteText = data['notes'] ?? '';

                          return ListTile(
                            title: Text(noteTitle),
                            subtitle: Text(noteText, maxLines: 1, overflow: TextOverflow.ellipsis),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => NoteDetailScreen(
                                    title: noteTitle,
                                    notes: noteText,
                                  ),
                                ),
                              );
                            },
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () => openNoteBox(
                                    docID: docID,
                                    existingTitle: noteTitle,
                                    existingNote: noteText,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () => firestoreService.deleteNote(docID),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    } else if (snapshot.hasError) {
                      return const Center(child: Text('Something went wrong'));
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ),
            ],
          ),

          /// ⬇️ Dual Floating Buttons
          floatingActionButton: Stack(
            children: [
              // Logout button (kiri bawah)
              Positioned(
                bottom: 16,
                left: 16,
                child: FloatingActionButton.extended(
                  onPressed: () => logout(context),
                  icon: const Icon(Icons.logout),
                  label: const Text('Logout'),
                  backgroundColor: Colors.red,
                ),
              ),
              // Add note button (kanan bawah)
              Positioned(
                bottom: 16,
                right: 16,
                child: FloatingActionButton(
                  onPressed: () => openNoteBox(),
                  child: const Icon(Icons.add),
                ),
              ),
            ],
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        );
      },
    );
  }
}

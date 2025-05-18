import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final CollectionReference notes = FirebaseFirestore.instance.collection('/notes');

  Future<void> addNote(String title, String note) {
    return notes.add({
      'title': title,
      'notes': note,
      'timestamp': Timestamp.now(),
    });
  }

  Stream<QuerySnapshot> getNotesStream() {
    return notes.orderBy('timestamp', descending: true).snapshots();
  }

  Future<void> updateNote(String docID, String newTitle, String newNote) {
    return notes.doc(docID).update({
      'title': newTitle,
      'notes': newNote,
      'timestamp': Timestamp.now(),
    });
  }

  Future<void> deleteNote(String docID) {
    return notes.doc(docID).delete();
  }
}


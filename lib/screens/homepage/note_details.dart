import 'package:flutter/material.dart';

class NoteDetailScreen extends StatelessWidget {
  final String title;
  final String notes;

  const NoteDetailScreen({
    super.key,
    required this.title,
    required this.notes,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          notes,
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}

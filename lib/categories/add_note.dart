import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_course1/core/widgets/customaddtextfield.dart';

import 'package:flutter/material.dart';

class AddNote extends StatefulWidget {
  AddNote({super.key, required this.categoryId});
  String categoryId;

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  CollectionReference notes = FirebaseFirestore.instance.collection('notes');
  Future<void> addNote() {
    return notes
        .add({
          'title': titleController.text,
          'content': contentController.text,
          'categoryId': widget.categoryId,
          'userId': FirebaseAuth.instance.currentUser!.uid,
        })
        .then((value) => print('Note added'))
        .catchError((error) => print('Failed to add note : $error'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Note')),
      body: Form(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Column(
            children: [
              SizedBox(height: 20),
              Customaddtextfield(
                nameController: titleController,
                name: 'Title : ',
              ),
              SizedBox(height: 15),
              Customaddtextfield(
                nameController: contentController,
                name: 'Content : ',
              ),
              SizedBox(height: 15),
              ElevatedButton(
                onPressed: () async {
                  if (titleController.text.isNotEmpty &&
                      contentController.text.isNotEmpty) {
                    await addNote();
                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('You should write a note'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                child: Text('Add Note', style: TextStyle(fontSize: 20)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

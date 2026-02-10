import 'package:firebase_course1/core/widgets/customaddtextfield.dart';
import 'package:firebase_course1/features/notes/views/cubit/Note%20Cubit/note_cubit.dart';
import 'package:firebase_course1/features/notes/views/cubit/Note%20Cubit/note_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddNote extends StatelessWidget {
  AddNote({super.key, required this.categoryId});
  final String categoryId;

  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return BlocConsumer<NoteCubit, NoteState>(
      listener: (context, state) {
        if (state is AddNoteSuccess) {
          Navigator.pop(context);
        } else if (state is AddNoteError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMsg),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: const Text('Add Note')),
          body: state is AddNoteLoading
              ? const Center(child: CircularProgressIndicator())
              : Center(
                  child: SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: width > 600 ? 450 : double.infinity,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        child: Form(
                          child: Column(
                            children: [
                              const SizedBox(height: 20),
                              Customaddtextfield(
                                nameController: titleController,
                                name: 'Title : ',
                              ),
                              const SizedBox(height: 15),
                              Customaddtextfield(
                                nameController: contentController,
                                name: 'Content : ',
                              ),
                              const SizedBox(height: 15),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (titleController.text.isNotEmpty &&
                                        contentController.text.isNotEmpty) {
                                      context.read<NoteCubit>().addNote(
                                            title: titleController.text,
                                            content: contentController.text,
                                            categoryId: categoryId,
                                          );
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text('You should write a note'),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    }
                                  },
                                  child: const Text(
                                    'Add Note',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
        );
      },
    );
  }
}

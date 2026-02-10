import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_course1/features/notes/views/pages/add_note.dart';
import 'package:firebase_course1/features/notes/views/cubit/Note%20Cubit/note_cubit.dart';
import 'package:firebase_course1/features/notes/views/cubit/Note%20Cubit/note_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotePage extends StatelessWidget {
  final String categoryId;
  final String categoryName;

  const NotePage({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.orange[50],
      appBar: AppBar(title: Text(categoryName), backgroundColor: Colors.orange),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddNote(categoryId: categoryId),
            ),
          );
          context.read<NoteCubit>().getNotes(categoryId);
        },
        child: const Icon(Icons.add),
      ),
      body: BlocConsumer<NoteCubit, NoteState>(
        listener: (context, state) {
          if (state is ErrorNoteState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMsg),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is LoadingNoteState) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is LoadedNoteState) {
            if (state.notes.isEmpty) {
              return const Center(
                child: Text('No Notes Yet', style: TextStyle(fontSize: 18)),
              );
            }

            return Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: width > 600 ? 600 : double.infinity,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: ListView.separated(
                    itemCount: state.notes.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final note = state.notes[index];
                      return InkWell(
                        onTap: () {
                          AwesomeDialog(
                            context: context,
                            dialogType: DialogType.question,
                            title: 'Action',
                            desc: 'Select what do you want?',
                            btnCancelText: 'Remove',
                            btnCancelOnPress: () async {
                              await note.reference.delete();
                              context.read<NoteCubit>().getNotes(categoryId);
                            },
                          ).show();
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 5,
                          shadowColor: Colors.orange[100],
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  note['title'],
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  note['content'],
                                  maxLines: 4,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[800],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}

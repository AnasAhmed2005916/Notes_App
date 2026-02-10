import 'package:firebase_course1/core/widgets/customaddtextfield.dart';
import 'package:firebase_course1/features/home/views/cubit/home_cubit.dart';
import 'package:firebase_course1/features/home/views/cubit/home_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditCategory extends StatelessWidget {
  EditCategory({super.key, required this.docid, required this.homeCubit});

  final String docid;
  final HomeCubit homeCubit;

  final GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return BlocListener<HomeCubit, HomeState>(
      listener: (context, state) {
        if (state is LoadedHomeState) {
          Navigator.pop(context);
        }
        if (state is ErrorHomeState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMsg)),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Edit Category')),
        body: Center(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: width > 600 ? 450 : double.infinity,
              ),
              child: Form(
                key: globalKey,
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Customaddtextfield(
                        nameController: nameController,
                        name: 'Save',
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        if (globalKey.currentState!.validate()) {
                          homeCubit.updateCategory(
                            docId: docid,
                            newName: nameController.text,
                          );
                        }
                      },
                      child: const Text('Save'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

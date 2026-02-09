import 'package:firebase_course1/core/widgets/customaddtextfield.dart';
import 'package:firebase_course1/features/home/views/cubit/home_cubit.dart';
import 'package:firebase_course1/features/home/views/cubit/home_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class editCategory extends StatelessWidget {
  editCategory({super.key, required this.docid, required this.homeCubit});
  final String docid;
  final HomeCubit homeCubit;

  GlobalKey<FormState> globalKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeCubit, HomeState>(
      listener: (context, state) {
        if (state is LoadedHomeState) {
          Navigator.pop(context);
        }
        if (state is ErrorHomeState) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.errorMsg)));
        }
      },
      child: Scaffold(
        appBar: AppBar(title: Text('Edit Category')),
        body: Form(
          key: globalKey,
          child: Column(
            children: [
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Customaddtextfield(
                  nameController: nameController,
                  name: 'Save',
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (globalKey.currentState!.validate()) {
                    homeCubit.updateCategory(
                      docId: docid,
                      newName: nameController.text,
                    );
                  }
                },
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_course1/core/widgets/customaddtextfield.dart';
import 'package:firebase_course1/home_page.dart';
import 'package:flutter/material.dart';

class editCategory extends StatefulWidget {
  const editCategory({super.key, required this.docid});
  final String docid;

  @override
  State<editCategory> createState() => _editCategoryState();
}

class _editCategoryState extends State<editCategory> {
  GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  CollectionReference categories = FirebaseFirestore.instance.collection(
    'categories',
  );
  editCategory() async {
    if (globalKey.currentState!.validate()) {
      try {
        await categories.doc(widget.docid).update({
          "name": nameController.text,
        });
      } catch (e) {
        print('Error updating category: $e');
      }
    }
  }

  getCategoryData() async {
    var doc = await categories.doc(widget.docid).get();
    nameController.text = doc['name'];
  }

  @override
  void initState() {
    super.initState();
    getCategoryData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Category')),
      body: Form(
        key: globalKey,
        child: Column(
          children: [
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Customaddtextfield(nameController: nameController , name: 'Save',),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (globalKey.currentState!.validate()) {
                  try {
                    await editCategory();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage()),
                    );
                  } catch (e) {
                    print('Error adding category: $e');
                  }
                }
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}

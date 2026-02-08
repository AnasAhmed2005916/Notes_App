import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_course1/core/widgets/customaddtextfield.dart';
import 'package:firebase_course1/home_page.dart';
import 'package:flutter/material.dart';

class AddCategory extends StatefulWidget {
  const AddCategory({super.key});

  @override
  State<AddCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  CollectionReference categories = FirebaseFirestore.instance.collection(
    'categories',
  );
  Future<void> addCategory() {
    return categories
        .add({
          'name': nameController.text,
          "id": FirebaseAuth.instance.currentUser!.uid,
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Category')),
      body: Form(
        key: globalKey,
        child: Column(
          children: [
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Customaddtextfield(
                nameController: nameController,
                name: 'Add Category : ',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (globalKey.currentState!.validate()) {
                  try {
                    await addCategory();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage()),
                    );
                  } catch (e) {
                    print('Error adding category: $e');
                  }
                }
              },
              child: Text('Add'),
            ),
          ],
        ),
      ),
    );
  }
}

/**
 * chandanursing@virgilian.com
 * HlkKM}rgY*
 * 
 * 6559ivory@virgilian.com
 * =+`p6eR1yu
 * 
 * sourbonnee@virgilian.com
 * \d:CdhUDPO
 * 
 * ahmedqurani@virgilian.com
 * ahmed1234
 */

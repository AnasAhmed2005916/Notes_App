import 'package:flutter/material.dart';

class Customaddtextfield extends StatelessWidget {
  final TextEditingController nameController;
  Customaddtextfield({required this.nameController, required this.name});
  String name;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter Note name';
        }
        return null;
      },

      decoration: InputDecoration(
        hintText: name,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      controller: nameController,
    );
  }
}

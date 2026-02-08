import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_course1/categories/edit.dart';
import 'package:firebase_course1/core/constants/assets.dart';
import 'package:firebase_course1/core/routes/app_routes.dart';
import 'package:firebase_course1/features/auth/views/cubit/Theme%20Cubit/theme_cubit.dart';
import 'package:firebase_course1/features/auth/views/cubit/Theme%20Cubit/theme_state.dart';
import 'package:firebase_course1/features/auth/views/cubit/Note%20Cubit/note_cubit.dart';
import 'package:firebase_course1/pages/note_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<QueryDocumentSnapshot> data = [];
  bool isLoading = true;

  getData() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('categories')
        .where('id', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();
    data = querySnapshot.docs;
    isLoading = false;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        onPressed: () {
          Navigator.of(context).pushReplacementNamed(AppRoutes.addcategory);
        },
        child: const Icon(Icons.add, size: 30),
      ),
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text(
          'My Categories',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.login,
                (route) => false,
              );
            },
            icon: const Icon(Icons.exit_to_app),
          ),
          const SizedBox(width: 10),
          BlocBuilder<ThemeCubit, ThemeState>(
            builder: (context, state) {
              return IconButton(
                onPressed: () {
                  context.read<ThemeCubit>().toogle();
                },
                icon: Icon(
                  state is ToggleTheme && state.isDark
                      ? Icons.dark_mode
                      : Icons.light_mode,
                  size: 30,
                ),
              );
            },
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : data.isEmpty
          ? Center(
              child: Text(
                'No Items Added!',
                style: TextStyle(fontSize: 20, color: Colors.grey[700]),
              ),
            )
          : Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.orange[50]!, Colors.white],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: GridView.builder(
                itemCount: data.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 15,
                  crossAxisSpacing: 15,
                  mainAxisExtent: 180,
                ),
                itemBuilder: (context, index) {
                  final category = data[index];
                  return InkWell(
                    onLongPress: () {
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.warning,
                        animType: AnimType.rightSlide,
                        title: 'Action',
                        desc: 'Select what you want to do',
                        btnCancelText: 'Remove',
                        btnOkText: 'Update',
                        btnOkOnPress: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  editCategory(docid: category.id),
                            ),
                          );
                        },
                        btnCancelOnPress: () async {
                          await FirebaseFirestore.instance
                              .collection('categories')
                              .doc(category.id)
                              .delete();
                          data.removeAt(index);
                          setState(() {});
                        },
                      ).show();
                    },
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BlocProvider(
                            create: (context) =>
                                NoteCubit()..getNotes(category.id),
                            child: NotePage(
                              categoryName: category['name'],
                              categoryId: category.id,
                            ),
                          ),
                        ),
                      );
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 5,
                      shadowColor: Colors.orange[100],
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 100,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(Assets.folderImage),
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            category['name'],
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}

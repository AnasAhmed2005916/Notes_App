import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_course1/features/home/views/pages/add_category';
import 'package:firebase_course1/features/home/views/pages/edit_category.dart';
import 'package:firebase_course1/core/constants/assets.dart';
import 'package:firebase_course1/core/routes/app_routes.dart';
import 'package:firebase_course1/features/auth/views/cubit/Theme%20Cubit/theme_cubit.dart';
import 'package:firebase_course1/features/auth/views/cubit/Theme%20Cubit/theme_state.dart';
import 'package:firebase_course1/features/home/views/cubit/home_cubit.dart';
import 'package:firebase_course1/features/home/views/cubit/home_state.dart';
import 'package:firebase_course1/features/notes/views/cubit/Note%20Cubit/note_cubit.dart';
import 'package:firebase_course1/features/notes/views/pages/note_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    int crossAxisCount = width > 1000
        ? 4
        : width > 600
        ? 3
        : 2;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                value: context.read<HomeCubit>(),
                child: AddCategory(),
              ),
            ),
          );
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
              var box = Hive.box('userBox');
              box.put('isLoggedIn', false);
              box.delete('userId');
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
      body: BlocConsumer<HomeCubit, HomeState>(
        listener: (context, state) {
          if (state is ErrorHomeState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMsg),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is LoadingHomeState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is LoadedHomeState) {
            return Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.orange[50]!, Colors.white],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: GridView.builder(
                itemCount: state.data.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  mainAxisSpacing: 15,
                  crossAxisSpacing: 15,
                  mainAxisExtent: 180,
                ),
                itemBuilder: (context, index) {
                  final category = state.data[index];
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => BlocProvider.value(
                                value: context.read<HomeCubit>(),
                                child: EditCategory(
                                  docid: category.id,
                                  homeCubit: context.read<HomeCubit>(),
                                ),
                              ),
                            ),
                          );
                        },
                        btnCancelOnPress: () async {
                          context.read<HomeCubit>().deleteCategory(category.id);
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
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}

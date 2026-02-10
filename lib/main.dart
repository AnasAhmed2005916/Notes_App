import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_course1/core/routes/app_routes.dart';
import 'package:firebase_course1/features/auth/views/cubit/Auth%20Cubit/auth_cubit.dart';
import 'package:firebase_course1/features/auth/views/cubit/Theme%20Cubit/theme_cubit.dart';
import 'package:firebase_course1/features/auth/views/cubit/Theme%20Cubit/theme_state.dart';
import 'package:firebase_course1/features/auth/views/pages/login.dart';
import 'package:firebase_course1/features/auth/views/pages/signUp.dart';
import 'package:firebase_course1/features/home/views/cubit/home_cubit.dart';
import 'package:firebase_course1/features/home/views/pages/add_category';
import 'package:firebase_course1/features/home/views/pages/home_page.dart';
import 'package:firebase_course1/features/notes/views/cubit/Note%20Cubit/note_cubit.dart';
import 'package:firebase_course1/firebase_options.dart';
import 'package:firebase_course1/features/auth/views/pages/splash_screen.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Hive.initFlutter();
  await Hive.openBox('userBox');
  runApp(
    DevicePreview(
      enabled: true,
      builder: (context) => MultiBlocProvider(
        providers: [
          BlocProvider<AuthCubit>(create: (context) => AuthCubit()),
          BlocProvider<ThemeCubit>(create: (context) => ThemeCubit()),
          BlocProvider<NoteCubit>(create: (context) => NoteCubit()),
        ],
        child: MyApp(),
      ),
    ),
  );
  // runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        ThemeData theme = ThemeData.light();
        if (state is InitThemeState) {
          theme = state.themeData;
        }
        if (state is ToggleTheme) {
          theme = state.themeData;
        }
        return MaterialApp(
          theme: theme,
          //ThemeData(
          //   appBarTheme: AppBarTheme(
          //     backgroundColor: Colors.grey[50],
          //     titleTextStyle: TextStyle(
          //       color: Colors.orange,
          //       fontSize: 17,
          //       fontWeight: FontWeight.bold,
          //     ),
          //     iconTheme: IconThemeData(color: Colors.orange),
          //   ),
          // ),
          routes: {
            AppRoutes.signup: (context) => SignUp(),
            AppRoutes.login: (context) => Login(),
            AppRoutes.home: (context) => BlocProvider(
              create: (context) => HomeCubit()..getData(),
              child: HomePage(),
            ),
            AppRoutes.addcategory: (context) => AddCategory(),
          },
          debugShowCheckedModeBanner: false,
          // home:
          //     (FirebaseAuth.instance.currentUser != null &&
          //         FirebaseAuth.instance.currentUser!.emailVerified)
          //     ? HomePage()
          //     : Login(),
          // // home: HomePage(),
          home: SplashScreen(),
        );
      },
    );
  }
}

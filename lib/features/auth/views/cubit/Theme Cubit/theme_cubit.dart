import 'package:firebase_course1/features/auth/views/cubit/Theme%20Cubit/theme_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeCubit extends Cubit<ThemeState> {
  bool isDark = false;
  ThemeCubit() : super(InitThemeState(themeData: ThemeData.light()));
  void toogle() {
  isDark = !isDark;
  emit(ToggleTheme(
      themeData: isDark ? ThemeData.dark() : ThemeData.light(),
      isDark: isDark));
}

}

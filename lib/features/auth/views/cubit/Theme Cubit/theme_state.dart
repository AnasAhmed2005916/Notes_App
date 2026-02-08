import 'package:flutter/material.dart';

class ThemeState {}

class InitThemeState extends ThemeState {
  final ThemeData themeData;
  InitThemeState({required this.themeData});
}

class ToggleTheme extends ThemeState {
  final ThemeData themeData;
  final bool isDark;
  ToggleTheme({required this.themeData, required this.isDark});
}


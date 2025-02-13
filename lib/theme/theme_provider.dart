import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dark_theme.dart';
import 'light_theme.dart';

class ThemeProvider with ChangeNotifier {
  ThemeData _themeData = lightmode; // Default to light mode
  bool _isDarkMode = false;

  ThemeData get themeData => _themeData;
  bool get isDarkMode => _isDarkMode;

  set themeData(ThemeData theme) {
    _themeData = theme;
    _isDarkMode = theme == darkmode;
    notifyListeners();
    saveTheme();
  }

  Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool('isDarkMode') ?? false;
    _themeData = _isDarkMode ? darkmode : lightmode;
    notifyListeners();
  }

  Future<void> saveTheme() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', _isDarkMode);
  }

  void toggleTheme(bool isDark) {
    themeData = isDark ? darkmode : lightmode;
  }
}

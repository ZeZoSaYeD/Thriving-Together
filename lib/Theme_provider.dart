import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  bool _isDarkMode = false;
  Locale _locale = Locale('en'); // Default to English

  bool get isDarkMode => _isDarkMode;
  Locale get currentLocale => _locale;

  ThemeProvider() {
    _loadSavedLocale();
  }

  // Load saved locale from SharedPreferences
  Future<void> _loadSavedLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString('language') ?? 'en';
    _locale = Locale(languageCode);
    notifyListeners();
  }

  // Save locale to SharedPreferences
  Future<void> _saveLocale(Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', locale.languageCode);
  }

  // Update the app's locale
  Future<void> setLocale(Locale newLocale) async {
    _locale = newLocale;
    await _saveLocale(newLocale);
    notifyListeners();
  }

  ThemeData get getTheme {
    return _isDarkMode ? ThemeData.dark() : ThemeData.light();
  }

  void toggleTheme(bool value) {
    _isDarkMode = value;
    notifyListeners();
  }
}
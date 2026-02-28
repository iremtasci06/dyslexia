import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/theme.dart';

class ThemeNotifier with ChangeNotifier {
  AppTheme _currentTheme = appThemes[0];

  AppTheme get currentTheme => _currentTheme;

  ThemeNotifier() {
    _loadTheme();
  }

  void setTheme(AppTheme theme) async {
    _currentTheme = theme;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedThemeName', theme.name);
  }

  void _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final savedThemeName = prefs.getString('selectedThemeName');

    if (savedThemeName != null) {
      final savedTheme = appThemes.firstWhere(
            (theme) => theme.name == savedThemeName,
        orElse: () => appThemes[0],
      );
      _currentTheme = savedTheme;
      notifyListeners();
    }
  }
}

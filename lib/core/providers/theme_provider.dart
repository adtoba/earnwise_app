import 'package:earnwise_app/core/constants/pref_keys.dart';
import 'package:earnwise_app/data/services/local_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/legacy.dart';

final themeNotifier = ChangeNotifierProvider((ref) => ThemeProvider());

class ThemeProvider extends ChangeNotifier {
  ThemeMode _currentTheme = ThemeMode.system;
  ThemeMode get currentTheme => _currentTheme;

  void setTheme(ThemeMode theme) {
    _currentTheme = theme;
    notifyListeners();
  }

  void toggleTheme({required bool isDarkMode}) async {
    if(isDarkMode) {
      _currentTheme = ThemeMode.dark;
    } else {
      _currentTheme = ThemeMode.light;
    }
    notifyListeners();
    await LocalStorageService.put(PrefKeys.theme, isDarkMode ? "dark" : "light");
  }

  void initTheme() async {
    String? theme = await LocalStorageService.get(PrefKeys.theme);
    if(theme == "dark") {
      _currentTheme = ThemeMode.dark;
    } else if(theme == "light"){
      _currentTheme = ThemeMode.light;
    } else {
      _currentTheme = ThemeMode.light;
    }
    notifyListeners();
  }

}
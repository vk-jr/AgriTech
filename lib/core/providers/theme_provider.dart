import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppThemeMode {
  light,
  dark,
  system,
}

class ThemeProvider extends ChangeNotifier {
  static const String _themeKey = 'theme_mode';
  
  AppThemeMode _themeMode = AppThemeMode.light; // Default to light theme
  bool _isInitialized = false;

  AppThemeMode get themeMode => _themeMode;
  bool get isInitialized => _isInitialized;

  // Get the actual ThemeMode for MaterialApp
  ThemeMode get materialThemeMode {
    switch (_themeMode) {
      case AppThemeMode.light:
        return ThemeMode.light;
      case AppThemeMode.dark:
        return ThemeMode.dark;
      case AppThemeMode.system:
        return ThemeMode.system;
    }
  }

  // Check if current theme is dark
  bool get isDarkMode => _themeMode == AppThemeMode.dark;
  
  // Check if current theme is light
  bool get isLightMode => _themeMode == AppThemeMode.light;
  
  // Check if following system theme
  bool get isSystemMode => _themeMode == AppThemeMode.system;

  // Initialize theme from shared preferences
  Future<void> initializeTheme() async {
    if (_isInitialized) return;
    
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedTheme = prefs.getString(_themeKey);
      
      if (savedTheme != null) {
        _themeMode = AppThemeMode.values.firstWhere(
          (mode) => mode.name == savedTheme,
          orElse: () => AppThemeMode.light, // Default fallback
        );
      }
    } catch (e) {
      // If there's any error, default to light theme
      _themeMode = AppThemeMode.light;
    }
    
    _isInitialized = true;
    notifyListeners();
  }

  // Set theme mode
  Future<void> setThemeMode(AppThemeMode mode) async {
    if (_themeMode == mode) return;
    
    _themeMode = mode;
    notifyListeners();
    
    // Save to shared preferences
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_themeKey, mode.name);
    } catch (e) {
      // Handle error silently - theme will still work for current session
      debugPrint('Error saving theme preference: $e');
    }
  }

  // Toggle between light and dark mode
  Future<void> toggleTheme() async {
    final newMode = _themeMode == AppThemeMode.dark 
        ? AppThemeMode.light 
        : AppThemeMode.dark;
    await setThemeMode(newMode);
  }

  // Set to light theme
  Future<void> setLightTheme() async {
    await setThemeMode(AppThemeMode.light);
  }

  // Set to dark theme
  Future<void> setDarkTheme() async {
    await setThemeMode(AppThemeMode.dark);
  }

  // Set to system theme
  Future<void> setSystemTheme() async {
    await setThemeMode(AppThemeMode.system);
  }

  // Get theme mode display name
  String get themeModeDisplayName {
    switch (_themeMode) {
      case AppThemeMode.light:
        return 'Light';
      case AppThemeMode.dark:
        return 'Dark';
      case AppThemeMode.system:
        return 'System';
    }
  }

  // Reset to default theme
  Future<void> resetToDefault() async {
    await setThemeMode(AppThemeMode.light);
  }
}

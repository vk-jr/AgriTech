import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalizationProvider extends ChangeNotifier {
  Locale _currentLocale = const Locale('en');
  
  Locale get currentLocale => _currentLocale;
  
  String get currentLanguageCode => _currentLocale.languageCode;
  
  static const List<Locale> supportedLocales = [
    Locale('en'),
    Locale('hi'),
    Locale('ml'),
  ];
  
  static const Map<String, String> languageNames = {
    'en': 'English',
    'hi': 'Hindi',
    'ml': 'Malayalam',
  };
  
  LocalizationProvider() {
    _loadSavedLanguage();
  }
  
  Future<void> _loadSavedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLanguageCode = prefs.getString('language_code') ?? 'en';
    
    // Ensure the saved language is supported
    if (supportedLocales.any((locale) => locale.languageCode == savedLanguageCode)) {
      _currentLocale = Locale(savedLanguageCode);
      notifyListeners();
    }
  }
  
  Future<void> setLanguage(String languageCode) async {
    if (supportedLocales.any((locale) => locale.languageCode == languageCode)) {
      _currentLocale = Locale(languageCode);
      
      // Save to preferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('language_code', languageCode);
      
      notifyListeners();
    }
  }
  
  String getLanguageName(String languageCode) {
    return languageNames[languageCode] ?? 'Unknown';
  }
  
  List<String> get supportedLanguageCodes {
    return supportedLocales.map((locale) => locale.languageCode).toList();
  }
  
  List<String> get supportedLanguageNames {
    return supportedLanguageCodes.map((code) => getLanguageName(code)).toList();
  }
}

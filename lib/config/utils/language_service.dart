import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageService extends ChangeNotifier {
  Locale _currentLocale = const Locale('en');
  bool _initialized = false;

  Locale get currentLocale => _currentLocale;
  
  String get languageCode => _currentLocale.languageCode;

  Future<void> initialize() async {
    if (_initialized) return;
    
    final prefs = await SharedPreferences.getInstance();
    final savedLanguage = prefs.getString('app_language');
    
    if (savedLanguage != null) {
      _currentLocale = Locale(savedLanguage);
    }
    
    _initialized = true;
    notifyListeners();
  }

  Future<void> setLocale(Locale locale) async {
    if (_currentLocale == locale) return;
    
    _currentLocale = locale;
    notifyListeners();
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('app_language', locale.languageCode);
  }

  void toggleLanguage() {
    final newLocale = _currentLocale.languageCode == 'en' 
        ? const Locale('es') 
        : const Locale('en');
    setLocale(newLocale);
  }
}

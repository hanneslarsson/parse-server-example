import 'package:flutter/material.dart';

/// Supported storefront languages, Swedish first as the primary market.
const supportedLocales = [
  Locale('sv'),
  Locale('no'),
  Locale('da'),
  Locale('en'),
];

class LocaleProvider extends ChangeNotifier {
  Locale _locale = const Locale('sv');

  Locale get locale => _locale;

  void setLocale(Locale locale) {
    if (_locale == locale) return;
    _locale = locale;
    notifyListeners();
  }
}

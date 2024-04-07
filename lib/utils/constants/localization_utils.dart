import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show ui;

String getDefaultLanguageCode(Locale deviceLocale, List<String> supportedLocales) {
  final deviceLanguageCode = deviceLocale.languageCode;
  return supportedLocales.contains(deviceLanguageCode) ? deviceLanguageCode : 'en';
}


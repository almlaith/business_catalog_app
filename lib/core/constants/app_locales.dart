import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

abstract final class AppLocales {
  static const english = Locale('en');
  static const arabic = Locale('ar');

  static const supportedLocales = [english, arabic];

  static const localizationsDelegates = [
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];
}

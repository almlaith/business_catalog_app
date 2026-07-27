import 'package:flutter/widgets.dart';

Locale resolveSupportedLocale(
  Locale? locale,
  Iterable<Locale> supportedLocales,
) {
  if (locale == null) {
    return supportedLocales.first;
  }

  for (final supportedLocale in supportedLocales) {
    if (supportedLocale.languageCode == locale.languageCode) {
      return supportedLocale;
    }
  }

  return supportedLocales.first;
}

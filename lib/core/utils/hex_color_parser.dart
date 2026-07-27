import 'package:flutter/material.dart';

abstract final class HexColorParser {
  static Color parse(String? value, {required Color fallback}) {
    if (value == null) {
      return fallback;
    }

    final normalized = value.trim().replaceFirst('#', '');
    final hex = switch (normalized.length) {
      6 => 'FF$normalized',
      8 => normalized,
      _ => null,
    };

    if (hex == null) {
      return fallback;
    }

    final parsedValue = int.tryParse(hex, radix: 16);
    if (parsedValue == null) {
      return fallback;
    }

    return Color(parsedValue);
  }
}

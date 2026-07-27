import 'package:flutter/widgets.dart';

abstract final class FormValidators {
  static FormFieldValidator<String> requiredText(String message) {
    return (value) {
      if (value == null || value.trim().isEmpty) {
        return message;
      }

      return null;
    };
  }

  static String? requiredWhen(
    String? value, {
    required bool condition,
    required String message,
  }) {
    if (!condition) {
      return null;
    }

    return requiredText(message)(value);
  }
}

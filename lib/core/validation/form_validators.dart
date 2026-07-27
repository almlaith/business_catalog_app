import 'package:business_catalog_app/core/constants/app_strings.dart';

abstract final class FormValidators {
  static String? requiredText(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.requiredField;
    }

    return null;
  }

  static String? requiredWhen(String? value, {required bool condition}) {
    if (!condition) {
      return null;
    }

    return requiredText(value);
  }
}

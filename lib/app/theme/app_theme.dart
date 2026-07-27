import 'package:business_catalog_app/app/theme/aurora_tokens.dart';
import 'package:flutter/material.dart';

abstract final class AppTheme {
  static const fallbackPrimary = AuroraColors.primaryViolet;
  static const fallbackSecondary = AuroraColors.electricCyan;

  static ThemeData light({
    Color primaryColor = fallbackPrimary,
    Color secondaryColor = fallbackSecondary,
  }) {
    final primary = _harmonizedAccent(primaryColor, fallbackPrimary);
    final secondary = _harmonizedAccent(secondaryColor, fallbackSecondary);
    final colorScheme = const ColorScheme.light().copyWith(
      primary: primary,
      onPrimary: Colors.white,
      primaryContainer: Color(0xFFEAE5FF),
      onPrimaryContainer: AuroraColors.deepViolet,
      secondary: secondary,
      onSecondary: AuroraColors.lightText,
      secondaryContainer: Color(0xFFDDF8FF),
      onSecondaryContainer: Color(0xFF053642),
      tertiary: AuroraColors.coral,
      onTertiary: Colors.white,
      tertiaryContainer: Color(0xFFFFE0E4),
      onTertiaryContainer: Color(0xFF701D28),
      error: AuroraColors.error,
      onError: Colors.white,
      errorContainer: Color(0xFFFFE1E4),
      onErrorContainer: Color(0xFF771A25),
      surface: AuroraColors.lightCard,
      onSurface: AuroraColors.lightText,
      surfaceContainerLowest: AuroraColors.lightBackground,
      surfaceContainerLow: AuroraColors.lightElevated,
      surfaceContainer: AuroraColors.lightCard,
      surfaceContainerHigh: Color(0xFFF0EEF8),
      surfaceContainerHighest: AuroraColors.lightStrong,
      onSurfaceVariant: AuroraColors.lightTextMuted,
      outline: Color(0xFFC6C0D8),
      outlineVariant: AuroraColors.lightOutline,
      shadow: AuroraColors.deepViolet,
      scrim: Colors.black,
    );

    return _baseTheme(colorScheme);
  }

  static ThemeData dark({
    Color primaryColor = fallbackPrimary,
    Color secondaryColor = fallbackSecondary,
  }) {
    final primary = _harmonizedAccent(primaryColor, fallbackPrimary);
    final secondary = _harmonizedAccent(secondaryColor, fallbackSecondary);
    final colorScheme = const ColorScheme.dark().copyWith(
      primary: primary,
      onPrimary: Colors.white,
      primaryContainer: const Color(0xFF2C215E),
      onPrimaryContainer: const Color(0xFFE7DFFF),
      secondary: secondary,
      onSecondary: const Color(0xFF001F28),
      secondaryContainer: const Color(0xFF073844),
      onSecondaryContainer: const Color(0xFFC6F7FF),
      tertiary: AuroraColors.coral,
      onTertiary: Colors.white,
      tertiaryContainer: const Color(0xFF56222A),
      onTertiaryContainer: const Color(0xFFFFD8DD),
      error: AuroraColors.error,
      onError: Colors.white,
      errorContainer: const Color(0xFF5F1E28),
      onErrorContainer: const Color(0xFFFFDADF),
      surface: AuroraColors.darkCard,
      onSurface: AuroraColors.darkText,
      surfaceContainerLowest: AuroraColors.darkBackground,
      surfaceContainerLow: AuroraColors.darkElevated,
      surfaceContainer: AuroraColors.darkCard,
      surfaceContainerHigh: const Color(0xFF161A27),
      surfaceContainerHighest: AuroraColors.darkStrong,
      onSurfaceVariant: AuroraColors.darkTextMuted,
      outline: const Color(0xFF3B4155),
      outlineVariant: AuroraColors.darkOutline,
      shadow: Colors.black,
      scrim: Colors.black,
    );

    return _baseTheme(colorScheme);
  }

  static ThemeData _baseTheme(ColorScheme colorScheme) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surfaceContainerLowest,
      fontFamilyFallback: const ['Roboto', 'Arial', 'sans-serif'],
      textTheme: _textTheme(colorScheme),
      appBarTheme: AppBarTheme(
        centerTitle: false,
        backgroundColor: Colors.transparent,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: TextStyle(
          color: colorScheme.onSurface,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
      ),
      cardTheme: CardThemeData(
        color: colorScheme.surface,
        elevation: 0,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(color: colorScheme.outlineVariant),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceContainerLow,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(18)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: colorScheme.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: colorScheme.secondary, width: 1.4),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: colorScheme.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: colorScheme.error, width: 1.4),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(56),
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: colorScheme.surfaceContainerLow,
        selectedColor: colorScheme.primaryContainer,
        labelStyle: TextStyle(
          color: colorScheme.onSurface,
          fontWeight: FontWeight.w700,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
        side: BorderSide(color: colorScheme.outlineVariant),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: colorScheme.surface,
        contentTextStyle: TextStyle(color: colorScheme.onSurface),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
      listTileTheme: const ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(horizontal: 16),
      ),
    );
  }

  static TextTheme _textTheme(ColorScheme colorScheme) {
    return Typography.material2021().black.copyWith(
      headlineLarge: TextStyle(
        color: colorScheme.onSurface,
        fontSize: 30,
        fontWeight: FontWeight.w900,
        height: 1.04,
      ),
      headlineMedium: TextStyle(
        color: colorScheme.onSurface,
        fontSize: 26,
        fontWeight: FontWeight.w900,
        height: 1.06,
      ),
      headlineSmall: TextStyle(
        color: colorScheme.onSurface,
        fontSize: 23,
        fontWeight: FontWeight.w900,
        height: 1.08,
      ),
      titleLarge: TextStyle(
        color: colorScheme.onSurface,
        fontSize: 20,
        fontWeight: FontWeight.w800,
        height: 1.15,
      ),
      titleMedium: TextStyle(
        color: colorScheme.onSurface,
        fontSize: 16,
        fontWeight: FontWeight.w800,
        height: 1.18,
      ),
      titleSmall: TextStyle(
        color: colorScheme.onSurface,
        fontSize: 14,
        fontWeight: FontWeight.w800,
        height: 1.18,
      ),
      bodyLarge: TextStyle(
        color: colorScheme.onSurface,
        fontSize: 16,
        fontWeight: FontWeight.w500,
        height: 1.45,
      ),
      bodyMedium: TextStyle(
        color: colorScheme.onSurface,
        fontSize: 14,
        fontWeight: FontWeight.w500,
        height: 1.38,
      ),
      bodySmall: TextStyle(
        color: colorScheme.onSurfaceVariant,
        fontSize: 12,
        fontWeight: FontWeight.w500,
        height: 1.32,
      ),
      labelLarge: TextStyle(
        color: colorScheme.onSurface,
        fontSize: 14,
        fontWeight: FontWeight.w800,
        height: 1.1,
      ),
      labelMedium: TextStyle(
        color: colorScheme.onSurface,
        fontSize: 12,
        fontWeight: FontWeight.w800,
        height: 1.1,
      ),
      labelSmall: TextStyle(
        color: colorScheme.onSurfaceVariant,
        fontSize: 11,
        fontWeight: FontWeight.w800,
        height: 1.1,
      ),
    );
  }

  static Color _harmonizedAccent(Color input, Color fallback) {
    final hsl = HSLColor.fromColor(input);
    final isAttractive =
        hsl.saturation >= 0.22 &&
        hsl.lightness >= 0.22 &&
        hsl.lightness <= 0.78;

    if (!isAttractive) {
      return fallback;
    }

    return Color.lerp(fallback, input, 0.18) ?? fallback;
  }
}

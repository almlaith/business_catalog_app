import 'package:flutter/material.dart';

abstract final class AuroraColors {
  static const lightBackground = Color(0xFFF1F0F8);
  static const lightElevated = Color(0xFFF7F6FC);
  static const lightCard = Color(0xFFFAF9FF);
  static const lightStrong = Color(0xFFE8E5F3);
  static const lightText = Color(0xFF15131C);
  static const lightTextMuted = Color(0xFF6C6879);
  static const lightOutline = Color(0xFFD9D5E5);

  static const darkBackground = Color(0xFF090B12);
  static const darkElevated = Color(0xFF0E111A);
  static const darkCard = Color(0xFF121520);
  static const darkStrong = Color(0xFF1A1E2B);
  static const darkText = Color(0xFFF5F3FF);
  static const darkTextMuted = Color(0xFFA8A5B5);
  static const darkOutline = Color(0xFF292E3D);

  static const primaryViolet = Color(0xFF7657FF);
  static const deepViolet = Color(0xFF5135D8);
  static const electricCyan = Color(0xFF17C9E8);
  static const cyanHighlight = Color(0xFF70E8FF);
  static const coral = Color(0xFFFF6B7A);
  static const success = Color(0xFF33D69F);
  static const warning = Color(0xFFFFB547);
  static const error = Color(0xFFFF5D6C);
}

abstract final class AuroraGradients {
  static const primary = LinearGradient(
    begin: AlignmentDirectional.topStart,
    end: AlignmentDirectional.bottomEnd,
    colors: [AuroraColors.primaryViolet, AuroraColors.electricCyan],
  );

  static const heroLight = LinearGradient(
    begin: AlignmentDirectional.topStart,
    end: AlignmentDirectional.bottomEnd,
    colors: [
      AuroraColors.deepViolet,
      AuroraColors.primaryViolet,
      AuroraColors.electricCyan,
    ],
  );

  static const heroDark = LinearGradient(
    begin: AlignmentDirectional.topStart,
    end: AlignmentDirectional.bottomEnd,
    colors: [Color(0xFF17122F), AuroraColors.deepViolet, Color(0xFF07313E)],
  );
}

abstract final class AuroraShadows {
  static List<BoxShadow> card(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return [
      BoxShadow(
        color: Colors.black.withValues(alpha: isDark ? 0.26 : 0.07),
        blurRadius: 24,
        offset: const Offset(0, 14),
      ),
    ];
  }

  static List<BoxShadow> glow(
    Color color, {
    double opacity = 0.22,
    double blur = 28,
  }) {
    return [
      BoxShadow(
        color: color.withValues(alpha: opacity),
        blurRadius: blur,
        offset: const Offset(0, 10),
      ),
    ];
  }
}

abstract final class AuroraMotion {
  static const curve = Curves.easeOutCubic;
  static const emphasized = Curves.fastOutSlowIn;
}

extension AuroraThemeX on BuildContext {
  bool get isDarkAurora => Theme.of(this).brightness == Brightness.dark;

  Color get auroraBackground =>
      Theme.of(this).colorScheme.surfaceContainerLowest;
  Color get auroraElevated => Theme.of(this).colorScheme.surfaceContainerLow;
  Color get auroraCard => Theme.of(this).colorScheme.surface;
  Color get auroraStrong => Theme.of(this).colorScheme.surfaceContainerHighest;
  Color get auroraOutline => Theme.of(this).colorScheme.outlineVariant;
  Color get auroraMutedText => Theme.of(this).colorScheme.onSurfaceVariant;
}

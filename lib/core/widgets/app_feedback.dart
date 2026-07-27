import 'package:business_catalog_app/app/theme/aurora_tokens.dart';
import 'package:business_catalog_app/core/constants/app_spacing.dart';
import 'package:flutter/material.dart';

enum AppFeedbackType { success, error, warning, info }

void showAppFeedback(
  BuildContext context, {
  required AppFeedbackType type,
  required String title,
  required String message,
  SnackBarAction? action,
}) {
  final theme = Theme.of(context);
  final colorScheme = theme.colorScheme;
  final colors = switch (type) {
    AppFeedbackType.success => (
      accent: AuroraColors.success,
      icon: Icons.check_circle_rounded,
    ),
    AppFeedbackType.error => (
      accent: AuroraColors.error,
      icon: Icons.error_rounded,
    ),
    AppFeedbackType.warning => (
      accent: AuroraColors.warning,
      icon: Icons.warning_rounded,
    ),
    AppFeedbackType.info => (
      accent: colorScheme.secondary,
      icon: Icons.info_rounded,
    ),
  };
  final background = Color.alphaBlend(
    colors.accent.withValues(
      alpha: theme.brightness == Brightness.dark ? 0.14 : 0.10,
    ),
    colorScheme.surface,
  );

  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.lg,
          AppSpacing.lg,
          106,
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.xl),
        ),
        content: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.94, end: 1),
          duration: AppDurations.medium,
          curve: AuroraMotion.curve,
          builder: (context, value, child) => Transform.scale(
            scale: value,
            alignment: Alignment.bottomCenter,
            child: child,
          ),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: background,
              borderRadius: BorderRadius.circular(AppRadii.xl),
              border: Border.all(color: colors.accent.withValues(alpha: 0.26)),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.shadow.withValues(alpha: 0.22),
                  blurRadius: 28,
                  offset: const Offset(0, 14),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: colors.accent.withValues(alpha: 0.16),
                      borderRadius: BorderRadius.circular(AppRadii.md),
                    ),
                    child: Icon(colors.icon, color: colors.accent),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: theme.textTheme.titleSmall?.copyWith(
                            color: colorScheme.onSurface,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          message,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        action: action,
      ),
    );
}

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
      background: colorScheme.secondaryContainer,
      foreground: colorScheme.onSecondaryContainer,
      icon: Icons.check_circle_outline,
    ),
    AppFeedbackType.error => (
      background: colorScheme.errorContainer,
      foreground: colorScheme.onErrorContainer,
      icon: Icons.error_outline,
    ),
    AppFeedbackType.warning => (
      background: colorScheme.tertiaryContainer,
      foreground: colorScheme.onTertiaryContainer,
      icon: Icons.warning_amber_outlined,
    ),
    AppFeedbackType.info => (
      background: colorScheme.primaryContainer,
      foreground: colorScheme.onPrimaryContainer,
      icon: Icons.info_outline,
    ),
  };

  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.lg,
          AppSpacing.lg,
          96,
        ),
        elevation: 0,
        backgroundColor: colors.background,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.lg),
          side: BorderSide(color: colors.foreground.withValues(alpha: 0.12)),
        ),
        content: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(colors.icon, color: colors.foreground),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: colors.foreground,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    message,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colors.foreground,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        action: action,
      ),
    );
}

import 'package:business_catalog_app/app/theme/aurora_tokens.dart';
import 'package:business_catalog_app/core/constants/app_spacing.dart';
import 'package:flutter/material.dart';

Future<bool> showAppConfirmationDialog({
  required BuildContext context,
  required IconData icon,
  required String title,
  required String message,
  required String cancelLabel,
  required String confirmLabel,
  bool isDestructive = false,
}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (context) {
      final theme = Theme.of(context);
      final colorScheme = theme.colorScheme;
      final iconColor = isDestructive ? colorScheme.error : colorScheme.primary;

      return Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 22),
        backgroundColor: Colors.transparent,
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.96, end: 1),
          duration: AppDurations.medium,
          curve: AuroraMotion.curve,
          builder: (context, value, child) =>
              Transform.scale(scale: value, child: child),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(AppRadii.xxl),
              border: Border.all(color: colorScheme.outlineVariant),
              boxShadow: AuroraShadows.card(context),
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.xxl),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: AlignmentDirectional.topStart,
                        end: AlignmentDirectional.bottomEnd,
                        colors: [
                          iconColor.withValues(alpha: 0.24),
                          iconColor.withValues(alpha: 0.08),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(AppRadii.xl),
                      border: Border.all(
                        color: iconColor.withValues(alpha: 0.22),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      child: Icon(
                        icon,
                        color: iconColor,
                        size: AppIconSizes.lg,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  Row(
                    children: [
                      Expanded(
                        child: FilledButton.tonal(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: Text(cancelLabel),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: FilledButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          style: FilledButton.styleFrom(
                            backgroundColor: isDestructive
                                ? colorScheme.error
                                : colorScheme.primary,
                            foregroundColor: isDestructive
                                ? colorScheme.onError
                                : colorScheme.onPrimary,
                          ),
                          child: Text(confirmLabel),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );

  return result ?? false;
}

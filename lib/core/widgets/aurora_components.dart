import 'package:business_catalog_app/app/theme/aurora_tokens.dart';
import 'package:business_catalog_app/core/constants/app_spacing.dart';
import 'package:flutter/material.dart';

class AuroraCard extends StatelessWidget {
  const AuroraCard({
    required this.child,
    this.padding = AppSpacing.card,
    this.margin = EdgeInsets.zero,
    this.borderRadius = AppRadii.xl,
    this.useGradientBorder = false,
    super.key,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final double borderRadius;
  final bool useGradientBorder;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    Widget content = DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(borderRadius),
        border: useGradientBorder
            ? null
            : Border.all(color: colorScheme.outlineVariant),
        boxShadow: AuroraShadows.card(context),
      ),
      child: Padding(padding: padding, child: child),
    );

    if (useGradientBorder) {
      content = DecoratedBox(
        decoration: BoxDecoration(
          gradient: AuroraGradients.primary,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Padding(
          padding: const EdgeInsets.all(1.2),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(borderRadius - 1.2),
            ),
            child: Padding(padding: padding, child: child),
          ),
        ),
      );
    }

    return Padding(padding: margin, child: content);
  }
}

class AuroraIconContainer extends StatelessWidget {
  const AuroraIconContainer({
    required this.icon,
    this.color,
    this.size = 44,
    super.key,
  });

  final IconData icon;
  final Color? color;
  final double size;

  @override
  Widget build(BuildContext context) {
    final accent = color ?? Theme.of(context).colorScheme.primary;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: AlignmentDirectional.topStart,
          end: AlignmentDirectional.bottomEnd,
          colors: [
            accent.withValues(alpha: 0.22),
            accent.withValues(alpha: 0.08),
          ],
        ),
        borderRadius: BorderRadius.circular(AppRadii.lg),
        border: Border.all(color: accent.withValues(alpha: 0.22)),
      ),
      child: Icon(icon, color: accent, size: AppIconSizes.md),
    );
  }
}

class AuroraSectionHeader extends StatelessWidget {
  const AuroraSectionHeader({
    required this.title,
    this.action,
    this.subtitle,
    super.key,
  });

  final String title;
  final String? subtitle;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: AppSpacing.xs),
                Text(
                  subtitle!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ],
          ),
        ),
        if (action != null) ...[const SizedBox(width: AppSpacing.md), action!],
      ],
    );
  }
}

class AuroraGradientButton extends StatelessWidget {
  const AuroraGradientButton({
    required this.onPressed,
    required this.label,
    this.icon,
    this.enabled = true,
    super.key,
  });

  final VoidCallback? onPressed;
  final Widget label;
  final Widget? icon;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final disabled = !enabled || onPressed == null;
    final colorScheme = Theme.of(context).colorScheme;

    return Semantics(
      button: true,
      enabled: !disabled,
      child: AnimatedOpacity(
        duration: AppDurations.fast,
        opacity: disabled ? 0.56 : 1,
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: disabled ? null : AuroraGradients.primary,
            color: disabled ? colorScheme.surfaceContainerHighest : null,
            borderRadius: BorderRadius.circular(AppRadii.lg),
            boxShadow: disabled
                ? null
                : AuroraShadows.glow(colorScheme.primary, opacity: 0.24),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: disabled ? null : onPressed,
              borderRadius: BorderRadius.circular(AppRadii.lg),
              child: ConstrainedBox(
                constraints: const BoxConstraints(minHeight: AppHeights.action),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.md,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (icon != null) ...[
                        IconTheme(
                          data: IconThemeData(
                            color: disabled
                                ? colorScheme.onSurfaceVariant
                                : Colors.white,
                          ),
                          child: icon!,
                        ),
                        const SizedBox(width: AppSpacing.sm),
                      ],
                      Flexible(
                        child: DefaultTextStyle(
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.labelLarge!
                              .copyWith(
                                color: disabled
                                    ? colorScheme.onSurfaceVariant
                                    : Colors.white,
                                fontWeight: FontWeight.w900,
                              ),
                          child: label,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AuroraGradientFilledButton extends StatelessWidget {
  const AuroraGradientFilledButton({
    required this.onPressed,
    required this.label,
    this.icon,
    super.key,
  });

  final VoidCallback? onPressed;
  final Widget label;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    final disabled = onPressed == null;
    final colorScheme = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: disabled ? null : AuroraGradients.primary,
        color: disabled ? colorScheme.surfaceContainerHighest : null,
        borderRadius: BorderRadius.circular(AppRadii.lg),
        boxShadow: disabled
            ? null
            : AuroraShadows.glow(colorScheme.primary, opacity: 0.24),
      ),
      child: FilledButton.icon(
        onPressed: onPressed,
        icon: icon ?? const SizedBox.shrink(),
        label: label,
        style: FilledButton.styleFrom(
          backgroundColor: Colors.transparent,
          disabledBackgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          foregroundColor: disabled
              ? colorScheme.onSurfaceVariant
              : Colors.white,
          disabledForegroundColor: colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}

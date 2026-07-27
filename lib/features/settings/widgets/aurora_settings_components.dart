import 'package:business_catalog_app/app/theme/aurora_tokens.dart';
import 'package:business_catalog_app/core/constants/app_spacing.dart';
import 'package:business_catalog_app/core/widgets/aurora_components.dart';
import 'package:flutter/material.dart';

class AuroraSettingsSection extends StatelessWidget {
  const AuroraSettingsSection({
    required this.icon,
    required this.title,
    required this.children,
    this.subtitle,
    super.key,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return AuroraCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AuroraSectionHeader(
            title: title,
            subtitle: subtitle,
            action: AuroraIconContainer(icon: icon, size: 42),
          ),
          const SizedBox(height: AppSpacing.lg),
          ...children,
        ],
      ),
    );
  }
}

class AuroraSettingsActionCard extends StatelessWidget {
  const AuroraSettingsActionCard({
    required this.icon,
    required this.title,
    required this.description,
    this.onTap,
    this.trailing,
    this.destructive = false,
    this.valueKey,
    super.key,
  });

  final IconData icon;
  final String title;
  final String description;
  final VoidCallback? onTap;
  final Widget? trailing;
  final bool destructive;
  final Key? valueKey;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final accent = destructive ? AuroraColors.error : colorScheme.primary;

    return AnimatedContainer(
      key: valueKey,
      duration: AppDurations.medium,
      curve: AuroraMotion.curve,
      decoration: BoxDecoration(
        color: destructive
            ? AuroraColors.error.withValues(alpha: 0.08)
            : colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppRadii.xl),
        border: Border.all(
          color: destructive
              ? AuroraColors.error.withValues(alpha: 0.22)
              : colorScheme.outlineVariant,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(AppRadii.xl),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadii.xl),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AuroraIconContainer(icon: icon, color: accent, size: 44),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        description,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          height: 1.25,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                trailing ??
                    Icon(
                      Icons.chevron_right_rounded,
                      color: colorScheme.onSurfaceVariant,
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AuroraPreferenceSummary extends StatelessWidget {
  const AuroraPreferenceSummary({
    required this.appearanceLabel,
    required this.languageLabel,
    required this.appearanceTitle,
    required this.languageTitle,
    super.key,
  });

  final String appearanceTitle;
  final String languageTitle;
  final String appearanceLabel;
  final String languageLabel;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final stack = constraints.maxWidth < 360;
        final appearance = _SummaryMetric(
          icon: Icons.palette_outlined,
          title: appearanceTitle,
          value: appearanceLabel,
        );
        final language = _SummaryMetric(
          icon: Icons.translate_rounded,
          title: languageTitle,
          value: languageLabel,
        );

        if (stack) {
          return Column(
            children: [
              appearance,
              const SizedBox(height: AppSpacing.sm),
              language,
            ],
          );
        }

        return Row(
          children: [
            Expanded(child: appearance),
            const SizedBox(width: AppSpacing.sm),
            Expanded(child: language),
          ],
        );
      },
    );
  }
}

class _SummaryMetric extends StatelessWidget {
  const _SummaryMetric({
    required this.icon,
    required this.title,
    required this.value,
  });

  final IconData icon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppRadii.xl),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            AuroraIconContainer(icon: icon, size: 38),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text(
                    value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AuroraThemePreviewCard extends StatelessWidget {
  const AuroraThemePreviewCard({
    required this.mode,
    required this.title,
    required this.description,
    required this.icon,
    required this.selected,
    required this.onTap,
    super.key,
  });

  final String mode;
  final String title;
  final String description;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AnimatedContainer(
      key: ValueKey('theme-preview-$mode'),
      duration: AppDurations.medium,
      curve: AuroraMotion.curve,
      decoration: BoxDecoration(
        gradient: selected ? AuroraGradients.primary : null,
        borderRadius: BorderRadius.circular(AppRadii.xl),
        boxShadow: selected
            ? AuroraShadows.glow(colorScheme.primary, opacity: 0.15, blur: 22)
            : null,
      ),
      child: Padding(
        padding: EdgeInsets.all(selected ? 1.4 : 0),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: selected
                ? Color.alphaBlend(
                    colorScheme.primary.withValues(alpha: 0.10),
                    colorScheme.surface,
                  )
                : colorScheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(AppRadii.xl - 1),
            border: selected
                ? null
                : Border.all(color: colorScheme.outlineVariant),
          ),
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(AppRadii.xl),
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(AppRadii.xl),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Row(
                  children: [
                    _ThemePreview(mode: mode),
                    const SizedBox(width: AppSpacing.md),
                    Icon(icon, color: colorScheme.primary),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                              height: 1.22,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    AnimatedSwitcher(
                      duration: AppDurations.fast,
                      child: Icon(
                        selected
                            ? Icons.check_circle_rounded
                            : Icons.circle_outlined,
                        key: ValueKey(selected),
                        color: selected
                            ? colorScheme.primary
                            : colorScheme.outline,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AuroraLanguageSelector extends StatelessWidget {
  const AuroraLanguageSelector({
    required this.value,
    required this.englishLabel,
    required this.arabicLabel,
    required this.englishNativeLabel,
    required this.arabicNativeLabel,
    required this.onChanged,
    super.key,
  });

  final String value;
  final String englishLabel;
  final String arabicLabel;
  final String englishNativeLabel;
  final String arabicNativeLabel;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final textScale = MediaQuery.textScalerOf(context).scale(1);

    return LayoutBuilder(
      builder: (context, constraints) {
        final stack = constraints.maxWidth < 340 || textScale > 1.2;
        final english = _LanguageCard(
          localeCode: 'en',
          badge: 'EN',
          label: englishLabel,
          nativeLabel: englishNativeLabel,
          selected: value == 'en',
          onTap: () => onChanged('en'),
        );
        final arabic = _LanguageCard(
          localeCode: 'ar',
          badge: 'AR',
          label: arabicLabel,
          nativeLabel: arabicNativeLabel,
          selected: value == 'ar',
          onTap: () => onChanged('ar'),
        );

        if (stack) {
          return Column(
            children: [
              english,
              const SizedBox(height: AppSpacing.sm),
              arabic,
            ],
          );
        }

        return Row(
          children: [
            Expanded(child: english),
            const SizedBox(width: AppSpacing.sm),
            Expanded(child: arabic),
          ],
        );
      },
    );
  }
}

class _LanguageCard extends StatelessWidget {
  const _LanguageCard({
    required this.localeCode,
    required this.badge,
    required this.label,
    required this.nativeLabel,
    required this.selected,
    required this.onTap,
  });

  final String localeCode;
  final String badge;
  final String label;
  final String nativeLabel;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AnimatedContainer(
      key: ValueKey('language-card-$localeCode'),
      duration: AppDurations.medium,
      curve: AuroraMotion.curve,
      decoration: BoxDecoration(
        gradient: selected ? AuroraGradients.primary : null,
        color: selected ? null : colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppRadii.xl),
        border: Border.all(
          color: selected
              ? Colors.white.withValues(alpha: 0.18)
              : colorScheme.outlineVariant,
        ),
        boxShadow: selected
            ? AuroraShadows.glow(colorScheme.primary, opacity: 0.13, blur: 18)
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(AppRadii.xl),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadii.xl),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: selected
                        ? Colors.white.withValues(alpha: 0.18)
                        : colorScheme.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(AppRadii.lg),
                  ),
                  child: Text(
                    badge,
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: selected ? Colors.white : colorScheme.primary,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: selected
                              ? Colors.white
                              : colorScheme.onSurface,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        nativeLabel,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: selected
                              ? Colors.white.withValues(alpha: 0.82)
                              : colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                AnimatedSwitcher(
                  duration: AppDurations.fast,
                  child: Icon(
                    selected
                        ? Icons.check_circle_rounded
                        : Icons.circle_outlined,
                    key: ValueKey(selected),
                    color: selected ? Colors.white : colorScheme.outline,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ThemePreview extends StatelessWidget {
  const _ThemePreview({required this.mode});

  final String mode;

  @override
  Widget build(BuildContext context) {
    final isDark = mode == 'dark';
    final isSystem = mode == 'system';
    final background = isDark
        ? AuroraColors.darkBackground
        : AuroraColors.lightBackground;
    final card = isDark ? AuroraColors.darkCard : AuroraColors.lightCard;
    final strong = isDark ? AuroraColors.darkStrong : AuroraColors.lightStrong;

    return Container(
      width: 58,
      height: 44,
      decoration: BoxDecoration(
        color: isSystem ? null : background,
        gradient: isSystem
            ? const LinearGradient(
                begin: AlignmentDirectional.centerStart,
                end: AlignmentDirectional.centerEnd,
                colors: [AuroraColors.lightBackground, AuroraColors.darkStrong],
              )
            : null,
        borderRadius: BorderRadius.circular(AppRadii.md),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 30,
              height: 6,
              decoration: BoxDecoration(
                gradient: AuroraGradients.primary,
                borderRadius: BorderRadius.circular(AppRadii.pill),
              ),
            ),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 16,
                    decoration: BoxDecoration(
                      color: card,
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: strong,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

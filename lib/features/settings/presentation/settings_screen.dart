import 'package:business_catalog_app/app/theme/aurora_tokens.dart';
import 'package:business_catalog_app/core/constants/app_constants.dart';
import 'package:business_catalog_app/core/constants/app_locales.dart';
import 'package:business_catalog_app/core/constants/app_spacing.dart';
import 'package:business_catalog_app/core/extensions/build_context_extensions.dart';
import 'package:business_catalog_app/core/widgets/app_confirmation_dialog.dart';
import 'package:business_catalog_app/core/widgets/app_feedback.dart';
import 'package:business_catalog_app/core/widgets/aurora_background.dart';
import 'package:business_catalog_app/core/widgets/aurora_components.dart';
import 'package:business_catalog_app/services/local_settings_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(appSettingsProvider);
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: AuroraBackground(
        bottomSafeGlow: true,
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.lg,
              AppSpacing.lg,
              AppSpacing.xxl,
            ),
            children: [
              _SettingsHeader(),
              const SizedBox(height: AppSpacing.lg),
              _SettingsSection(
                icon: Icons.translate_rounded,
                title: l10n.languageSetting,
                children: [
                  _LanguagePicker(
                    value:
                        settings.localeCode ?? AppLocales.english.languageCode,
                    onChanged: (value) => _saveLanguage(context, ref, value),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              _SettingsSection(
                icon: Icons.dark_mode_rounded,
                title: l10n.appearanceSection,
                children: [
                  _ThemeModePicker(
                    value: settings.themeMode,
                    onChanged: (value) => _saveTheme(context, ref, value),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  _ResetSettingsTile(
                    onReset: () => _resetAppearance(context, ref),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              _SettingsSection(
                icon: Icons.info_rounded,
                title: l10n.aboutSection,
                children: [
                  _AboutRow(icon: Icons.apps_rounded, title: l10n.appTitle),
                  const SizedBox(height: AppSpacing.md),
                  _AboutRow(
                    icon: Icons.workspace_premium_outlined,
                    title: l10n.aboutAppDescription,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _AboutRow(
                    icon: Icons.sell_outlined,
                    title: l10n.appVersion,
                    trailing: AppConstants.appVersion,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveLanguage(
    BuildContext context,
    WidgetRef ref,
    String value,
  ) async {
    await ref.read(appSettingsControllerProvider.notifier).setLocaleCode(value);
    if (context.mounted) {
      showAppFeedback(
        context,
        type: AppFeedbackType.success,
        title: context.l10n.settingsSavedTitle,
        message: context.l10n.settingsSavedMessage,
      );
    }
  }

  Future<void> _saveTheme(
    BuildContext context,
    WidgetRef ref,
    String value,
  ) async {
    await ref.read(appSettingsControllerProvider.notifier).setThemeMode(value);
    if (context.mounted) {
      showAppFeedback(
        context,
        type: AppFeedbackType.success,
        title: context.l10n.settingsSavedTitle,
        message: context.l10n.settingsSavedMessage,
      );
    }
  }

  Future<void> _resetAppearance(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    final confirmed = await showAppConfirmationDialog(
      context: context,
      icon: Icons.restart_alt_rounded,
      title: l10n.resetAppearanceQuestion,
      message: l10n.resetAppearanceMessage,
      cancelLabel: l10n.cancel,
      confirmLabel: l10n.reset,
      isDestructive: true,
    );
    if (!confirmed) {
      return;
    }

    await ref
        .read(appSettingsControllerProvider.notifier)
        .resetAppearanceSettings();
    if (context.mounted) {
      showAppFeedback(
        context,
        type: AppFeedbackType.info,
        title: context.l10n.settingsResetTitle,
        message: context.l10n.settingsResetMessage,
      );
    }
  }
}

class _SettingsHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: theme.brightness == Brightness.dark
            ? AuroraGradients.heroDark
            : AuroraGradients.heroLight,
        borderRadius: BorderRadius.circular(AppRadii.xxl),
        boxShadow: AuroraShadows.glow(theme.colorScheme.primary, opacity: 0.20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Row(
          children: [
            const AuroraIconContainer(
              icon: Icons.settings_suggest_rounded,
              color: Colors.white,
              size: 58,
            ),
            const SizedBox(width: AppSpacing.lg),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.l10n.settingsTitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    context.l10n.themeSettingDescription,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.white.withValues(alpha: 0.82),
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

class _SettingsSection extends StatelessWidget {
  const _SettingsSection({
    required this.icon,
    required this.title,
    required this.children,
  });

  final IconData icon;
  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return AuroraCard(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AuroraSectionHeader(
            title: title,
            action: AuroraIconContainer(icon: icon, size: 42),
          ),
          const SizedBox(height: AppSpacing.lg),
          ...children,
        ],
      ),
    );
  }
}

class _LanguagePicker extends StatelessWidget {
  const _LanguagePicker({required this.value, required this.onChanged});

  final String value;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return _PreferenceBlock(
      title: l10n.languageSetting,
      description: l10n.languageSettingDescription,
      child: Row(
        children: [
          Expanded(
            child: _ChoiceTile(
              label: l10n.englishLanguage,
              icon: Icons.language_rounded,
              selected: value == AppLocales.english.languageCode,
              onTap: () => onChanged(AppLocales.english.languageCode),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: _ChoiceTile(
              label: l10n.arabicLanguage,
              icon: Icons.translate_rounded,
              selected: value == AppLocales.arabic.languageCode,
              onTap: () => onChanged(AppLocales.arabic.languageCode),
            ),
          ),
        ],
      ),
    );
  }
}

class _ThemeModePicker extends StatelessWidget {
  const _ThemeModePicker({required this.value, required this.onChanged});

  final String value;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return _PreferenceBlock(
      title: l10n.themeSetting,
      description: l10n.themeSettingDescription,
      child: Column(
        children: [
          _ThemePreviewTile(
            label: l10n.systemTheme,
            icon: Icons.brightness_auto_rounded,
            mode: 'system',
            selected: value == 'system',
            onTap: () => onChanged('system'),
          ),
          const SizedBox(height: AppSpacing.sm),
          _ThemePreviewTile(
            label: l10n.lightTheme,
            icon: Icons.light_mode_rounded,
            mode: 'light',
            selected: value == 'light',
            onTap: () => onChanged('light'),
          ),
          const SizedBox(height: AppSpacing.sm),
          _ThemePreviewTile(
            label: l10n.darkTheme,
            icon: Icons.dark_mode_rounded,
            mode: 'dark',
            selected: value == 'dark',
            onTap: () => onChanged('dark'),
          ),
        ],
      ),
    );
  }
}

class _PreferenceBlock extends StatelessWidget {
  const _PreferenceBlock({
    required this.title,
    required this.description,
    required this.child,
  });

  final String title;
  final String description;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(description, style: theme.textTheme.bodySmall),
        const SizedBox(height: AppSpacing.md),
        child,
      ],
    );
  }
}

class _ChoiceTile extends StatelessWidget {
  const _ChoiceTile({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AnimatedContainer(
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
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadii.xl),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            children: [
              Icon(icon, color: selected ? Colors.white : colorScheme.primary),
              const SizedBox(height: AppSpacing.sm),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: selected ? Colors.white : colorScheme.onSurface,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ThemePreviewTile extends StatelessWidget {
  const _ThemePreviewTile({
    required this.label,
    required this.icon,
    required this.mode,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final String mode;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AnimatedContainer(
      duration: AppDurations.medium,
      curve: AuroraMotion.curve,
      decoration: BoxDecoration(
        color: selected
            ? colorScheme.primary.withValues(alpha: 0.12)
            : colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppRadii.xl),
        border: Border.all(
          color: selected ? colorScheme.primary : colorScheme.outlineVariant,
          width: selected ? 1.4 : 1,
        ),
        boxShadow: selected
            ? AuroraShadows.glow(colorScheme.primary, opacity: 0.13, blur: 18)
            : null,
      ),
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
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(
                    context,
                  ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w900),
                ),
              ),
              AnimatedSwitcher(
                duration: AppDurations.fast,
                child: Icon(
                  selected ? Icons.check_circle_rounded : Icons.circle_outlined,
                  key: ValueKey(selected),
                  color: selected ? colorScheme.primary : colorScheme.outline,
                ),
              ),
            ],
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
      width: 56,
      height: 42,
      decoration: BoxDecoration(
        color: isSystem ? null : background,
        gradient: isSystem
            ? const LinearGradient(
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
              width: 28,
              height: 6,
              decoration: BoxDecoration(
                color: AuroraColors.primaryViolet,
                borderRadius: BorderRadius.circular(AppRadii.pill),
              ),
            ),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 15,
                    decoration: BoxDecoration(
                      color: card,
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                Container(
                  width: 15,
                  height: 15,
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

class _ResetSettingsTile extends StatelessWidget {
  const _ResetSettingsTile({required this.onReset});

  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: AuroraColors.error.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppRadii.xl),
        border: Border.all(color: AuroraColors.error.withValues(alpha: 0.20)),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(AppRadii.xl),
        child: ListTile(
          leading: const Icon(
            Icons.restart_alt_rounded,
            color: AuroraColors.error,
          ),
          title: Text(l10n.resetAppearance),
          subtitle: Text(l10n.resetAppearanceDescription),
          trailing: const Icon(Icons.chevron_right_rounded),
          onTap: onReset,
        ),
      ),
    );
  }
}

class _AboutRow extends StatelessWidget {
  const _AboutRow({required this.icon, required this.title, this.trailing});

  final IconData icon;
  final String title;
  final String? trailing;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppRadii.xl),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(AppRadii.xl),
        child: ListTile(
          leading: AuroraIconContainer(icon: icon, size: 42),
          title: Text(title),
          trailing: trailing == null
              ? null
              : Text(
                  trailing!,
                  style: Theme.of(
                    context,
                  ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w900),
                ),
        ),
      ),
    );
  }
}

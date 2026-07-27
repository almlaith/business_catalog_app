import 'package:business_catalog_app/core/constants/app_constants.dart';
import 'package:business_catalog_app/core/constants/app_locales.dart';
import 'package:business_catalog_app/core/constants/app_spacing.dart';
import 'package:business_catalog_app/core/extensions/build_context_extensions.dart';
import 'package:business_catalog_app/core/widgets/app_confirmation_dialog.dart';
import 'package:business_catalog_app/core/widgets/app_feedback.dart';
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
      body: SafeArea(
        child: ListView(
          padding: AppSpacing.page,
          children: [
            _SettingsSection(
              icon: Icons.palette_outlined,
              title: l10n.appearanceSection,
              children: [
                _SettingsChoiceCard<String>(
                  title: l10n.languageSetting,
                  description: l10n.languageSettingDescription,
                  value: settings.localeCode ?? AppLocales.english.languageCode,
                  options: [
                    _SettingsOption(
                      value: AppLocales.english.languageCode,
                      label: l10n.englishLanguage,
                      icon: Icons.language_outlined,
                    ),
                    _SettingsOption(
                      value: AppLocales.arabic.languageCode,
                      label: l10n.arabicLanguage,
                      icon: Icons.translate_outlined,
                    ),
                  ],
                  onChanged: (value) async {
                    await ref
                        .read(appSettingsControllerProvider.notifier)
                        .setLocaleCode(value);
                    if (context.mounted) {
                      showAppFeedback(
                        context,
                        type: AppFeedbackType.success,
                        title: context.l10n.settingsSavedTitle,
                        message: context.l10n.settingsSavedMessage,
                      );
                    }
                  },
                ),
                const SizedBox(height: AppSpacing.md),
                _SettingsChoiceCard<String>(
                  title: l10n.themeSetting,
                  description: l10n.themeSettingDescription,
                  value: settings.themeMode,
                  options: [
                    _SettingsOption(
                      value: 'system',
                      label: l10n.systemTheme,
                      icon: Icons.brightness_auto_outlined,
                    ),
                    _SettingsOption(
                      value: 'light',
                      label: l10n.lightTheme,
                      icon: Icons.light_mode_outlined,
                    ),
                    _SettingsOption(
                      value: 'dark',
                      label: l10n.darkTheme,
                      icon: Icons.dark_mode_outlined,
                    ),
                  ],
                  onChanged: (value) async {
                    await ref
                        .read(appSettingsControllerProvider.notifier)
                        .setThemeMode(value);
                    if (context.mounted) {
                      showAppFeedback(
                        context,
                        type: AppFeedbackType.success,
                        title: context.l10n.settingsSavedTitle,
                        message: context.l10n.settingsSavedMessage,
                      );
                    }
                  },
                ),
                const SizedBox(height: AppSpacing.md),
                _ResetSettingsTile(
                  onReset: () async {
                    final confirmed = await showAppConfirmationDialog(
                      context: context,
                      icon: Icons.restart_alt_outlined,
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
                  },
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            _SettingsSection(
              icon: Icons.info_outline,
              title: l10n.aboutSection,
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(l10n.aboutAppDescription),
                ),
                const Divider(),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.sell_outlined),
                  title: Text(l10n.appVersion),
                  trailing: const Text(AppConstants.appVersion),
                ),
              ],
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
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: AppSpacing.card,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: theme.colorScheme.primary),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    title,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            ...children,
          ],
        ),
      ),
    );
  }
}

class _SettingsChoiceCard<T> extends StatelessWidget {
  const _SettingsChoiceCard({
    required this.title,
    required this.description,
    required this.value,
    required this.options,
    required this.onChanged,
  });

  final String title;
  final String description;
  final T value;
  final List<_SettingsOption<T>> options;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          description,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            height: 1.3,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        AnimatedSwitcher(
          duration: AppDurations.medium,
          child: Column(
            key: ValueKey(value),
            children: [
              for (final option in options)
                _SettingsOptionTile<T>(
                  option: option,
                  selected: option.value == value,
                  onTap: () => onChanged(option.value),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SettingsOptionTile<T> extends StatelessWidget {
  const _SettingsOptionTile({
    required this.option,
    required this.selected,
    required this.onTap,
  });

  final _SettingsOption<T> option;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedContainer(
      duration: AppDurations.fast,
      curve: Curves.easeOutCubic,
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Material(
        color: selected
            ? theme.colorScheme.primaryContainer
            : theme.colorScheme.surfaceContainerLow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.md),
          side: BorderSide(
            color: selected
                ? theme.colorScheme.primary.withValues(alpha: 0.34)
                : theme.colorScheme.outlineVariant,
          ),
        ),
        child: ListTile(
          onTap: onTap,
          leading: Icon(
            option.icon,
            color: selected
                ? theme.colorScheme.onPrimaryContainer
                : theme.colorScheme.onSurfaceVariant,
          ),
          title: Text(option.label),
          trailing: AnimatedSwitcher(
            duration: AppDurations.fast,
            child: selected
                ? Icon(
                    Icons.check_circle,
                    key: const ValueKey('selected'),
                    color: theme.colorScheme.primary,
                  )
                : Icon(
                    Icons.circle_outlined,
                    key: const ValueKey('unselected'),
                    color: theme.colorScheme.outline,
                  ),
          ),
        ),
      ),
    );
  }
}

class _SettingsOption<T> {
  const _SettingsOption({
    required this.value,
    required this.label,
    required this.icon,
  });

  final T value;
  final String label;
  final IconData icon;
}

class _ResetSettingsTile extends StatelessWidget {
  const _ResetSettingsTile({required this.onReset});

  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(Icons.restart_alt_outlined, color: theme.colorScheme.error),
      title: Text(l10n.resetAppearance),
      subtitle: Text(l10n.resetAppearanceDescription),
      onTap: onReset,
    );
  }
}

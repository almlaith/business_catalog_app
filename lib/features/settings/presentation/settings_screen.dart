import 'package:business_catalog_app/app/theme/aurora_tokens.dart';
import 'package:business_catalog_app/core/constants/app_constants.dart';
import 'package:business_catalog_app/core/constants/app_locales.dart';
import 'package:business_catalog_app/core/constants/app_route_paths.dart';
import 'package:business_catalog_app/core/constants/app_spacing.dart';
import 'package:business_catalog_app/core/extensions/build_context_extensions.dart';
import 'package:business_catalog_app/core/widgets/app_confirmation_dialog.dart';
import 'package:business_catalog_app/core/widgets/app_feedback.dart';
import 'package:business_catalog_app/core/widgets/aurora_background.dart';
import 'package:business_catalog_app/core/widgets/aurora_components.dart';
import 'package:business_catalog_app/features/settings/widgets/aurora_settings_components.dart';
import 'package:business_catalog_app/services/local_settings_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(appSettingsProvider);
    final l10n = context.l10n;
    final localeCode = settings.localeCode ?? AppLocales.english.languageCode;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: AuroraBackground(
        bottomSafeGlow: true,
        child: SafeArea(
          child: ListView(
            key: const ValueKey('settings-scroll-view'),
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.lg,
              AppSpacing.lg,
              132,
            ),
            children: [
              _SettingsHeader(),
              const SizedBox(height: AppSpacing.lg),
              AuroraSettingsSection(
                icon: Icons.tune_rounded,
                title: l10n.preferencesSummaryTitle,
                subtitle: l10n.preferencesSummaryDescription,
                children: [
                  AuroraPreferenceSummary(
                    appearanceTitle: l10n.themeSetting,
                    languageTitle: l10n.languageSetting,
                    appearanceLabel: _themeLabel(context, settings.themeMode),
                    languageLabel: _languageLabel(context, localeCode),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              AuroraSettingsSection(
                icon: Icons.auto_awesome_rounded,
                title: l10n.appearanceSection,
                subtitle: l10n.appearanceSectionDescription,
                children: [
                  AuroraThemePreviewCard(
                    mode: 'system',
                    title: l10n.systemTheme,
                    description: l10n.systemThemeDescription,
                    icon: Icons.brightness_auto_rounded,
                    selected: settings.themeMode == 'system',
                    onTap: () => _saveTheme(context, ref, 'system'),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  AuroraThemePreviewCard(
                    mode: 'light',
                    title: l10n.lightTheme,
                    description: l10n.lightThemeDescription,
                    icon: Icons.light_mode_rounded,
                    selected: settings.themeMode == 'light',
                    onTap: () => _saveTheme(context, ref, 'light'),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  AuroraThemePreviewCard(
                    mode: 'dark',
                    title: l10n.darkTheme,
                    description: l10n.darkThemeDescription,
                    icon: Icons.dark_mode_rounded,
                    selected: settings.themeMode == 'dark',
                    onTap: () => _saveTheme(context, ref, 'dark'),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              AuroraSettingsSection(
                icon: Icons.translate_rounded,
                title: l10n.languageSetting,
                subtitle: l10n.languageSettingDescription,
                children: [
                  AuroraLanguageSelector(
                    value: localeCode,
                    englishLabel: l10n.englishLanguage,
                    arabicLabel: l10n.arabicLanguage,
                    englishNativeLabel: l10n.englishNativeLanguage,
                    arabicNativeLabel: l10n.arabicNativeLanguage,
                    onChanged: (value) => _saveLanguage(context, ref, value),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              AuroraSettingsSection(
                icon: Icons.apps_rounded,
                title: l10n.applicationSection,
                subtitle: l10n.applicationSectionDescription,
                children: [
                  AuroraSettingsActionCard(
                    valueKey: const ValueKey('settings-action-help-support'),
                    icon: Icons.support_agent_rounded,
                    title: l10n.helpSupportTitle,
                    description: l10n.helpSupportDescription,
                    onTap: () => context.push(AppRoutePaths.helpSupport),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  AuroraSettingsActionCard(
                    icon: Icons.workspace_premium_outlined,
                    title: l10n.aboutSection,
                    description: l10n.aboutAppDescription,
                    trailing: const SizedBox.shrink(),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  AuroraSettingsActionCard(
                    icon: Icons.sell_outlined,
                    title: l10n.appVersion,
                    description: l10n.appVersionDescription,
                    trailing: Text(
                      AppConstants.appVersion,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  AuroraSettingsActionCard(
                    valueKey: const ValueKey('settings-action-reset'),
                    icon: Icons.restart_alt_rounded,
                    title: l10n.resetAppearance,
                    description: l10n.resetAppearanceDescription,
                    destructive: true,
                    onTap: () => _resetAppearance(context, ref),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _themeLabel(BuildContext context, String value) {
    final l10n = context.l10n;
    return switch (value) {
      'light' => l10n.lightTheme,
      'system' => l10n.systemTheme,
      _ => l10n.darkTheme,
    };
  }

  String _languageLabel(BuildContext context, String value) {
    final l10n = context.l10n;
    return value == AppLocales.arabic.languageCode
        ? l10n.arabicLanguage
        : l10n.englishLanguage;
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
        boxShadow: AuroraShadows.glow(theme.colorScheme.primary, opacity: 0.18),
      ),
      child: Stack(
        children: [
          PositionedDirectional(
            top: -38,
            end: -24,
            child: Container(
              width: 124,
              height: 124,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AuroraColors.electricCyan.withValues(alpha: 0.16),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Row(
              children: [
                const AuroraIconContainer(
                  icon: Icons.settings_suggest_rounded,
                  color: Colors.white,
                  size: 56,
                ),
                const SizedBox(width: AppSpacing.md),
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
                        context.l10n.settingsHeaderDescription,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.white.withValues(alpha: 0.84),
                          height: 1.25,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

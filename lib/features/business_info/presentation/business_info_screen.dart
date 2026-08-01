import 'package:business_catalog_app/app/theme/aurora_tokens.dart';
import 'package:business_catalog_app/core/constants/app_route_paths.dart';
import 'package:business_catalog_app/core/constants/app_spacing.dart';
import 'package:business_catalog_app/core/extensions/build_context_extensions.dart';
import 'package:business_catalog_app/core/widgets/app_async_state.dart';
import 'package:business_catalog_app/core/widgets/app_feedback.dart';
import 'package:business_catalog_app/core/widgets/app_skeleton.dart';
import 'package:business_catalog_app/core/widgets/aurora_background.dart';
import 'package:business_catalog_app/core/widgets/aurora_refresh.dart';
import 'package:business_catalog_app/core/widgets/local_asset_image.dart';
import 'package:business_catalog_app/features/business_info/widgets/business_info_row.dart';
import 'package:business_catalog_app/features/catalog/data/catalog_providers.dart';
import 'package:business_catalog_app/models/business_config.dart';
import 'package:business_catalog_app/services/external_link_launcher.dart';
import 'package:business_catalog_app/services/external_link_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class BusinessInfoScreen extends ConsumerWidget {
  const BusinessInfoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final catalogState = ref.watch(catalogDataProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.businessInfoTitle),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            tooltip: context.l10n.settingsTooltip,
            onPressed: () => context.push(AppRoutePaths.settings),
            icon: const Icon(Icons.settings_outlined),
          ),
        ],
      ),
      body: AuroraBackground(
        child: SafeArea(
          child: catalogState.when(
            skipLoadingOnRefresh: true,
            skipError: true,
            loading: () => const AppSkeletonInfo(),
            error: (error, stackTrace) => AppErrorState(
              error: error,
              onRetry: () => ref.invalidate(catalogDataProvider),
            ),
            data: (catalog) => AuroraRefreshWrapper(
              onRefresh: () => ref.refresh(catalogDataProvider.future),
              child: _BusinessInfoContent(business: catalog.business),
            ),
          ),
        ),
      ),
    );
  }
}

class _BusinessInfoContent extends ConsumerWidget {
  const _BusinessInfoContent({required this.business});

  final BusinessConfig business;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final openingHours = business.openingHours.entries
        .where((entry) => entry.value.trim().isNotEmpty)
        .map((entry) => '${entry.key}: ${entry.value}')
        .join('\n');
    String? openingSummary;
    for (final entry in business.openingHours.entries) {
      if (entry.value.trim().isNotEmpty) {
        openingSummary = entry.value;
        break;
      }
    }
    final l10n = context.l10n;

    return ListView(
      key: const ValueKey('business-info-scroll-view'),
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 118),
      children: [
        Padding(
          padding: AppSpacing.page,
          child: _BusinessHeader(
            business: business,
            openingSummary: openingSummary,
          ),
        ),
        BusinessInfoRow(
          icon: Icons.description_outlined,
          title: l10n.businessDescription,
          value: business.shortDescription,
        ),
        if (business.phoneNumber.trim().isNotEmpty)
          BusinessInfoRow(
            icon: Icons.phone_outlined,
            title: l10n.phone,
            value: formatPhoneNumber(business.phoneNumber),
            actionLabel: l10n.callAction,
            onTap: () => _launchPhone(context, ref),
          ),
        if (business.email.trim().isNotEmpty)
          BusinessInfoRow(
            icon: Icons.email_outlined,
            title: l10n.email,
            value: business.email.trim(),
            actionLabel: l10n.sendEmailAction,
            onTap: () => _launchEmail(context, ref),
          ),
        if (business.address.trim().isNotEmpty)
          BusinessInfoRow(
            icon: Icons.place_outlined,
            title: l10n.address,
            value: business.address.trim(),
            actionLabel: l10n.openMapAction,
            onTap: () => _launchAddress(context, ref),
          ),
        BusinessInfoRow(
          icon: Icons.schedule_outlined,
          title: l10n.openingHours,
          value: openingHours,
        ),
        if (isLaunchableSocialUrl(business.instagramUrl))
          BusinessInfoRow(
            icon: Icons.camera_alt_outlined,
            title: l10n.instagram,
            value: l10n.instagram,
            actionLabel: l10n.openInstagramAction,
            onTap: () => _launchSocial(
              context,
              ref,
              Uri.parse(business.instagramUrl.trim()),
            ),
          ),
        if (isLaunchableSocialUrl(business.facebookUrl))
          BusinessInfoRow(
            icon: Icons.facebook_outlined,
            title: l10n.facebook,
            value: l10n.facebook,
            actionLabel: l10n.openFacebookAction,
            onTap: () => _launchSocial(
              context,
              ref,
              Uri.parse(business.facebookUrl.trim()),
            ),
          ),
        BusinessInfoRow(
          icon: Icons.settings_outlined,
          title: l10n.settingsTitle,
          value: l10n.appearanceSection,
          onTap: () => context.push(AppRoutePaths.settings),
        ),
        BusinessInfoRow(
          icon: Icons.help_outline_rounded,
          title: l10n.helpSupportTitle,
          value: l10n.helpSupportDescription,
          onTap: () => context.push(AppRoutePaths.helpSupport),
        ),
      ],
    );
  }

  Future<void> _launchPhone(BuildContext context, WidgetRef ref) async {
    final launched = await _launch(
      ref,
      Uri(scheme: 'tel', path: business.phoneNumber.trim()),
    );
    if (context.mounted && !launched) {
      _showInfo(context, context.l10n.noPhoneApp);
    }
  }

  Future<void> _launchEmail(BuildContext context, WidgetRef ref) async {
    final email = business.email.trim();
    if (!await _launch(ref, Uri(scheme: 'mailto', path: email))) {
      await Clipboard.setData(ClipboardData(text: email));
      if (context.mounted) {
        _showInfo(context, context.l10n.emailAddressCopied);
      }
    }
  }

  Future<void> _launchAddress(BuildContext context, WidgetRef ref) async {
    final address = business.address.trim();
    final mapsUri = Uri.https('www.google.com', '/maps/search/', {
      'api': '1',
      'query': address,
    });
    if (!await _launch(ref, mapsUri)) {
      await Clipboard.setData(ClipboardData(text: address));
      if (context.mounted) {
        _showInfo(context, context.l10n.addressCopied);
      }
    }
  }

  Future<void> _launchSocial(
    BuildContext context,
    WidgetRef ref,
    Uri uri,
  ) async {
    if (!await _launch(ref, uri) && context.mounted) {
      _showWarning(context, context.l10n.socialLinkUnavailable);
    }
  }

  Future<bool> _launch(WidgetRef ref, Uri uri) =>
      tryLaunchExternal(ref.read(externalLinkLauncherProvider), uri);

  void _showInfo(BuildContext context, String message) {
    showAppFeedback(
      context,
      type: AppFeedbackType.info,
      title: context.l10n.infoTitle,
      message: message,
    );
  }

  void _showWarning(BuildContext context, String message) {
    showAppFeedback(
      context,
      type: AppFeedbackType.warning,
      title: context.l10n.warningTitle,
      message: message,
    );
  }
}

class _BusinessHeader extends StatelessWidget {
  const _BusinessHeader({required this.business, required this.openingSummary});

  final BusinessConfig business;
  final String? openingSummary;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final openingSummary = this.openingSummary;

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
            DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(AppRadii.xl),
                border: Border.all(color: Colors.white.withValues(alpha: 0.22)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(7),
                child: LocalAssetImage(
                  assetPath: business.logoAsset,
                  width: 74,
                  height: 74,
                  borderRadius: BorderRadius.circular(AppRadii.lg),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.lg),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    business.businessName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      height: 1.08,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    business.shortDescription,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withValues(alpha: 0.84),
                      height: 1.28,
                    ),
                  ),
                  if (openingSummary != null) ...[
                    const SizedBox(height: AppSpacing.sm),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(AppRadii.pill),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.18),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm,
                          vertical: AppSpacing.xs,
                        ),
                        child: Text(
                          openingSummary,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:business_catalog_app/app/theme/aurora_tokens.dart';
import 'package:business_catalog_app/core/constants/app_route_paths.dart';
import 'package:business_catalog_app/core/constants/app_spacing.dart';
import 'package:business_catalog_app/core/extensions/build_context_extensions.dart';
import 'package:business_catalog_app/core/widgets/app_async_state.dart';
import 'package:business_catalog_app/core/widgets/app_feedback.dart';
import 'package:business_catalog_app/core/widgets/app_skeleton.dart';
import 'package:business_catalog_app/core/widgets/aurora_background.dart';
import 'package:business_catalog_app/core/widgets/local_asset_image.dart';
import 'package:business_catalog_app/features/business_info/widgets/business_info_row.dart';
import 'package:business_catalog_app/features/catalog/data/catalog_providers.dart';
import 'package:business_catalog_app/models/business_config.dart';
import 'package:business_catalog_app/services/external_link_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

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
            loading: () => const AppSkeletonInfo(),
            error: (error, stackTrace) => AppErrorState(
              error: error,
              onRetry: () => ref.invalidate(catalogDataProvider),
            ),
            data: (catalog) => _BusinessInfoContent(business: catalog.business),
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
        BusinessInfoRow(
          icon: Icons.phone_outlined,
          title: l10n.phone,
          value: business.phoneNumber,
          onTap: () => _launch(
            context,
            ref,
            Uri(scheme: 'tel', path: business.phoneNumber),
          ),
        ),
        BusinessInfoRow(
          icon: Icons.email_outlined,
          title: l10n.email,
          value: business.email,
          onTap: () => _launch(
            context,
            ref,
            Uri(scheme: 'mailto', path: business.email),
          ),
        ),
        BusinessInfoRow(
          icon: Icons.place_outlined,
          title: l10n.address,
          value: business.address,
          onTap: () => _launch(
            context,
            ref,
            Uri.https('www.google.com', '/maps/search/', {
              'api': '1',
              'query': business.address,
            }),
          ),
        ),
        BusinessInfoRow(
          icon: Icons.schedule_outlined,
          title: l10n.openingHours,
          value: openingHours,
        ),
        BusinessInfoRow(
          icon: Icons.camera_alt_outlined,
          title: l10n.instagram,
          value: business.instagramUrl,
          onTap: () => _launchParsed(context, ref, business.instagramUrl),
        ),
        BusinessInfoRow(
          icon: Icons.facebook_outlined,
          title: l10n.facebook,
          value: business.facebookUrl,
          onTap: () => _launchParsed(context, ref, business.facebookUrl),
        ),
        BusinessInfoRow(
          icon: Icons.settings_outlined,
          title: l10n.settingsTitle,
          value: l10n.appearanceSection,
          onTap: () => context.push(AppRoutePaths.settings),
        ),
      ],
    );
  }

  Future<void> _launchParsed(
    BuildContext context,
    WidgetRef ref,
    String value,
  ) async {
    final uri = Uri.tryParse(value);
    if (uri == null) {
      _showError(context);
      return;
    }

    await _launch(context, ref, uri);
  }

  Future<void> _launch(BuildContext context, WidgetRef ref, Uri uri) async {
    final launcher = ref.read(externalLinkLauncherProvider);
    final canLaunch = await launcher.canLaunch(uri);
    final launched = canLaunch
        ? await launcher.launch(uri, mode: LaunchMode.externalApplication)
        : false;

    if (!context.mounted) {
      return;
    }

    if (!launched) {
      _showError(context);
    }
  }

  void _showError(BuildContext context) {
    showAppFeedback(
      context,
      type: AppFeedbackType.error,
      title: context.l10n.errorTitle,
      message: context.l10n.unableToOpenLink,
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

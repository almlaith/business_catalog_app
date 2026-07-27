import 'package:business_catalog_app/core/extensions/build_context_extensions.dart';
import 'package:business_catalog_app/core/widgets/app_async_state.dart';
import 'package:business_catalog_app/features/business_info/widgets/business_info_row.dart';
import 'package:business_catalog_app/features/catalog/data/catalog_providers.dart';
import 'package:business_catalog_app/models/business_config.dart';
import 'package:business_catalog_app/services/external_link_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
      ),
      body: SafeArea(
        child: catalogState.when(
          loading: () => const AppLoadingState(),
          error: (error, stackTrace) => AppErrorState(
            error: error,
            onRetry: () => ref.invalidate(catalogDataProvider),
          ),
          data: (catalog) => _BusinessInfoContent(business: catalog.business),
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
    final l10n = context.l10n;

    return ListView(
      key: const ValueKey('business-info-scroll-view'),
      padding: const EdgeInsets.symmetric(vertical: 8),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            business.businessName,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
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
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(context.l10n.unableToOpenLink)));
  }
}

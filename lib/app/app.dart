import 'package:business_catalog_app/app/router/app_router.dart';
import 'package:business_catalog_app/app/theme/app_theme.dart';
import 'package:business_catalog_app/core/constants/app_locales.dart';
import 'package:business_catalog_app/core/extensions/build_context_extensions.dart';
import 'package:business_catalog_app/core/utils/hex_color_parser.dart';
import 'package:business_catalog_app/core/utils/locale_resolver.dart';
import 'package:business_catalog_app/features/catalog/data/catalog_providers.dart';
import 'package:business_catalog_app/services/local_settings_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BusinessCatalogApp extends ConsumerWidget {
  const BusinessCatalogApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final settings = ref.watch(appSettingsProvider);
    final catalog = ref.watch(catalogDataProvider).asData?.value;
    final business = catalog?.business;
    final primaryColor = HexColorParser.parse(
      business?.primaryColorHex,
      fallback: AppTheme.fallbackPrimary,
    );
    final secondaryColor = HexColorParser.parse(
      business?.secondaryColorHex,
      fallback: AppTheme.fallbackSecondary,
    );
    final localeCode =
        settings.localeCode ??
        business?.defaultLocale ??
        AppLocales.english.languageCode;

    return MaterialApp.router(
      onGenerateTitle: (context) =>
          business?.businessName ?? context.l10n.appTitle,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(
        primaryColor: primaryColor,
        secondaryColor: secondaryColor,
      ),
      routerConfig: router,
      locale: resolveSupportedLocale(
        Locale(localeCode),
        AppLocales.supportedLocales,
      ),
      supportedLocales: AppLocales.supportedLocales,
      localizationsDelegates: AppLocales.localizationsDelegates,
      localeResolutionCallback: resolveSupportedLocale,
    );
  }
}

import 'package:business_catalog_app/app/router/app_router.dart';
import 'package:business_catalog_app/app/theme/app_theme.dart';
import 'package:business_catalog_app/core/constants/app_locales.dart';
import 'package:business_catalog_app/core/constants/app_strings.dart';
import 'package:business_catalog_app/core/utils/locale_resolver.dart';
import 'package:business_catalog_app/services/local_settings_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BusinessCatalogApp extends ConsumerWidget {
  const BusinessCatalogApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final settings = ref.watch(appSettingsProvider);

    return MaterialApp.router(
      title: AppStrings.appTitle,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      routerConfig: router,
      locale: resolveSupportedLocale(
        Locale(settings.localeCode),
        AppLocales.supportedLocales,
      ),
      supportedLocales: AppLocales.supportedLocales,
      localizationsDelegates: AppLocales.localizationsDelegates,
      localeResolutionCallback: resolveSupportedLocale,
    );
  }
}

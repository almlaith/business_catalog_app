import 'package:business_catalog_app/app/app_bootstrap.dart';
import 'package:business_catalog_app/app/app.dart';
import 'package:business_catalog_app/services/local_settings_service.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configurePortraitOrientation();

  final preferences = await SharedPreferencesWithCache.create(
    cacheOptions: const SharedPreferencesWithCacheOptions(
      allowList: LocalSettingsService.allowedKeys,
    ),
  );

  runApp(
    ProviderScope(
      overrides: [
        localSettingsServiceProvider.overrideWithValue(
          LocalSettingsService(preferences),
        ),
      ],
      child: const BusinessCatalogApp(),
    ),
  );
}

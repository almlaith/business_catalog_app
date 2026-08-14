import 'package:business_catalog_app/core/config/app_config.dart';
import 'package:business_catalog_app/core/network/api_client.dart';
import 'package:business_catalog_app/features/catalog/data/catalog_repository.dart';
import 'package:business_catalog_app/features/catalog/data/local_catalog_repository.dart';
import 'package:business_catalog_app/features/catalog/data/remote_catalog_repository.dart';
import 'package:business_catalog_app/models/catalog_data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final appConfigProvider = Provider<AppConfig>(
  (ref) => AppConfig.fromEnvironment(),
);

final catalogRepositoryProvider = Provider<CatalogRepository>((ref) {
  final config = ref.watch(appConfigProvider);
  return switch (config.catalogSource) {
    CatalogSource.local => LocalCatalogRepository(),
    CatalogSource.remote => RemoteCatalogRepository(
      ApiClient(baseUrl: config.apiBaseUrl!),
    ),
  };
});

final catalogDataProvider = FutureProvider<CatalogData>(
  (ref) => ref.watch(catalogRepositoryProvider).loadCatalog(),
);

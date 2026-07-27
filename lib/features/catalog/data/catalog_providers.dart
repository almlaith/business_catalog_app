import 'package:business_catalog_app/features/catalog/data/catalog_repository.dart';
import 'package:business_catalog_app/features/catalog/data/local_catalog_repository.dart';
import 'package:business_catalog_app/models/catalog_data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final catalogRepositoryProvider = Provider<CatalogRepository>(
  (ref) => LocalCatalogRepository(),
);

final catalogDataProvider = FutureProvider<CatalogData>(
  (ref) => ref.watch(catalogRepositoryProvider).loadCatalog(),
);

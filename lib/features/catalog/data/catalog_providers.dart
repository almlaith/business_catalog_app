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

final catalogControllerProvider =
    AsyncNotifierProvider<CatalogController, CatalogData>(
      CatalogController.new,
      // Initial-load errors are presented with an explicit retry action.
      retry: (retryCount, error) => null,
    );

// Kept as the UI-facing provider so existing consumers and test overrides do
// not need to know which controller owns catalog loading and refresh behavior.
final catalogDataProvider = Provider<AsyncValue<CatalogData>>(
  (ref) => ref.watch(catalogControllerProvider),
);

class CatalogController extends AsyncNotifier<CatalogData> {
  Future<void>? _activeRefresh;

  @override
  Future<CatalogData> build() {
    return ref.watch(catalogRepositoryProvider).loadCatalog();
  }

  Future<void> refreshCatalog() {
    final activeRefresh = _activeRefresh;
    if (activeRefresh != null) {
      return activeRefresh;
    }

    final refresh = _refreshCatalog().whenComplete(() {
      _activeRefresh = null;
    });
    _activeRefresh = refresh;
    return refresh;
  }

  Future<void> _refreshCatalog() async {
    // Refresh is deliberately non-destructive: the current AsyncData remains
    // authoritative while the repository request is in flight or if it fails.
    final catalog = await ref.read(catalogRepositoryProvider).loadCatalog();
    state = AsyncData(catalog);
  }

  Future<void> retryInitialLoad() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(catalogRepositoryProvider).loadCatalog(),
    );
  }
}

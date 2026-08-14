import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:business_catalog_app/core/constants/app_assets.dart';
import 'package:business_catalog_app/features/catalog/data/catalog_providers.dart';
import 'package:business_catalog_app/features/catalog/data/catalog_repository.dart';
import 'package:business_catalog_app/features/catalog/data/local_catalog_repository.dart';
import 'package:business_catalog_app/models/catalog_data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final catalogA = CatalogData.fromJson(
    jsonDecode(File(AppAssets.catalogData).readAsStringSync())
        as Map<String, Object?>,
  );
  final catalogB = catalogA.copyWith(
    business: catalogA.business.copyWith(businessName: 'Aura Atelier Updated'),
  );

  test('remote refresh keeps catalog A until catalog B succeeds', () async {
    final refreshResult = Completer<CatalogData>();
    final repository = _SequencedCatalogRepository([
      Future.value(catalogA),
      refreshResult.future,
    ]);
    final container = _container(repository);
    addTearDown(container.dispose);

    await container.read(catalogControllerProvider.future);
    final refresh = container
        .read(catalogControllerProvider.notifier)
        .refreshCatalog();
    await Future<void>.delayed(Duration.zero);

    expect(container.read(catalogDataProvider), isA<AsyncData<CatalogData>>());
    expect(
      container.read(catalogDataProvider).requireValue.business.businessName,
      'Aura Atelier',
    );

    refreshResult.complete(catalogB);
    await refresh;

    expect(
      container.read(catalogDataProvider).requireValue.business.businessName,
      'Aura Atelier Updated',
    );
  });

  test(
    'remote refresh failure preserves successful data and completes',
    () async {
      final refreshResult = Completer<CatalogData>();
      final repository = _SequencedCatalogRepository([
        Future.value(catalogA),
        refreshResult.future,
      ]);
      final container = _container(repository);
      addTearDown(container.dispose);

      await container.read(catalogControllerProvider.future);
      final refresh = container
          .read(catalogControllerProvider.notifier)
          .refreshCatalog();
      refreshResult.completeError(const CatalogRepositoryException.network());

      await expectLater(refresh, throwsA(isA<CatalogRepositoryException>()));
      final state = container.read(catalogDataProvider);
      expect(state, isA<AsyncData<CatalogData>>());
      expect(state.requireValue, catalogA);
      expect(state.isLoading, isFalse);
    },
  );

  test('initial remote failure exposes an error with no stale data', () async {
    final repository = _SequencedCatalogRepository([
      Future.error(const CatalogRepositoryException.network()),
    ]);
    final container = _container(repository);
    addTearDown(container.dispose);
    final errorObserved = Completer<void>();
    final subscription = container.listen(catalogDataProvider, (
      previous,
      next,
    ) {
      if (next.hasError && !errorObserved.isCompleted) {
        errorObserved.complete();
      }
    }, fireImmediately: true);
    addTearDown(subscription.close);

    await errorObserved.future;

    final state = container.read(catalogDataProvider);
    expect(state, isA<AsyncError<CatalogData>>());
    expect(state.hasValue, isFalse);
  });

  test('local repository still reloads on refresh', () async {
    final repository = _CountingLocalCatalogRepository();
    final container = _container(repository);
    addTearDown(container.dispose);

    final initial = await container.read(catalogControllerProvider.future);
    await container.read(catalogControllerProvider.notifier).refreshCatalog();

    expect(repository.loadCount, 2);
    expect(container.read(catalogDataProvider).requireValue, initial);
  });
}

ProviderContainer _container(CatalogRepository repository) => ProviderContainer(
  overrides: [catalogRepositoryProvider.overrideWithValue(repository)],
);

class _SequencedCatalogRepository implements CatalogRepository {
  _SequencedCatalogRepository(this.results);

  final List<Future<CatalogData>> results;
  var _index = 0;

  @override
  Future<CatalogData> loadCatalog() => results[_index++];
}

class _CountingLocalCatalogRepository extends LocalCatalogRepository {
  var loadCount = 0;

  @override
  Future<CatalogData> loadCatalog() {
    loadCount++;
    return super.loadCatalog();
  }
}

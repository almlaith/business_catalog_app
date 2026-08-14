import 'package:business_catalog_app/core/config/app_config.dart';
import 'package:business_catalog_app/features/catalog/data/catalog_providers.dart';
import 'package:business_catalog_app/features/catalog/data/local_catalog_repository.dart';
import 'package:business_catalog_app/features/catalog/data/remote_catalog_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('defaults to local catalog with no API URL', () {
    final config = AppConfig.fromEnvironment();
    expect(config.catalogSource, CatalogSource.local);
    expect(config.apiBaseUrl, isNull);
  });

  test('normalizes a remote API base URL', () {
    final config = AppConfig.fromEnvironment(
      catalogSource: 'remote',
      apiBaseUrl: 'http://10.0.2.2:8080/',
    );
    expect(config.catalogSource, CatalogSource.remote);
    expect(config.apiBaseUrl.toString(), 'http://10.0.2.2:8080');
  });

  test('remote mode requires an API base URL', () {
    expect(
      () => AppConfig.fromEnvironment(catalogSource: 'remote'),
      throwsArgumentError,
    );
  });

  test('rejects unsupported source and invalid URL', () {
    expect(
      () => AppConfig.fromEnvironment(catalogSource: 'automatic'),
      throwsArgumentError,
    );
    expect(
      () => AppConfig.fromEnvironment(
        catalogSource: 'remote',
        apiBaseUrl: 'localhost:8080',
      ),
      throwsArgumentError,
    );
  });

  test('provider selects local repository', () {
    final container = ProviderContainer(
      overrides: [
        appConfigProvider.overrideWithValue(
          const AppConfig(catalogSource: CatalogSource.local),
        ),
      ],
    );
    addTearDown(container.dispose);
    expect(
      container.read(catalogRepositoryProvider),
      isA<LocalCatalogRepository>(),
    );
  });

  test('provider selects remote repository', () {
    final container = ProviderContainer(
      overrides: [
        appConfigProvider.overrideWithValue(
          AppConfig(
            catalogSource: CatalogSource.remote,
            apiBaseUrl: Uri.parse('https://example.test'),
          ),
        ),
      ],
    );
    addTearDown(container.dispose);
    expect(
      container.read(catalogRepositoryProvider),
      isA<RemoteCatalogRepository>(),
    );
  });
}

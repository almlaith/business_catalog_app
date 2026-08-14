import 'package:business_catalog_app/models/catalog_data.dart';

abstract interface class CatalogRepository {
  Future<CatalogData> loadCatalog();
}

enum CatalogRepositoryError { network, timeout, server, invalidResponse }

class CatalogRepositoryException implements Exception {
  const CatalogRepositoryException._(this.error);

  const CatalogRepositoryException.network()
    : this._(CatalogRepositoryError.network);
  const CatalogRepositoryException.timeout()
    : this._(CatalogRepositoryError.timeout);
  const CatalogRepositoryException.server()
    : this._(CatalogRepositoryError.server);
  const CatalogRepositoryException.invalidResponse()
    : this._(CatalogRepositoryError.invalidResponse);

  final CatalogRepositoryError error;

  @override
  String toString() => 'Unable to load the catalog. Please try again.';
}

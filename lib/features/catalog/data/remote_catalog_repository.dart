import 'package:business_catalog_app/core/network/api_client.dart';
import 'package:business_catalog_app/features/catalog/data/catalog_repository.dart';
import 'package:business_catalog_app/features/catalog/data/catalog_validator.dart';
import 'package:business_catalog_app/features/catalog/data/remote_catalog_mapper.dart';
import 'package:business_catalog_app/models/catalog_data.dart';

class RemoteCatalogRepository implements CatalogRepository {
  RemoteCatalogRepository(this._apiClient);

  final ApiClient _apiClient;
  Future<CatalogData>? _inFlight;

  @override
  Future<CatalogData> loadCatalog() {
    return _inFlight ??= _load().whenComplete(() => _inFlight = null);
  }

  Future<CatalogData> _load() async {
    try {
      return validateCatalog(
        mapRemoteCatalog(await _apiClient.getJsonObject('/api/v1/catalog')),
      );
    } on CatalogRepositoryException {
      rethrow;
    } on FormatException catch (_) {
      throw const CatalogRepositoryException.invalidResponse();
    } on TypeError catch (_) {
      throw const CatalogRepositoryException.invalidResponse();
    }
  }
}

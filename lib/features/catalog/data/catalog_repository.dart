import 'package:business_catalog_app/models/catalog_data.dart';

abstract interface class CatalogRepository {
  Future<CatalogData> loadCatalog();
}

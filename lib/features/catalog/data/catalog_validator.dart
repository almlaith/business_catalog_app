import 'package:business_catalog_app/features/catalog/data/catalog_repository.dart';
import 'package:business_catalog_app/models/catalog_data.dart';

CatalogData validateCatalog(CatalogData catalog) {
  void required(String value) {
    if (value.trim().isEmpty) {
      throw const CatalogRepositoryException.invalidResponse();
    }
  }

  required(catalog.business.id);
  required(catalog.business.businessName);
  final categoryIds = <String>{};
  for (final category in catalog.categories) {
    required(category.id);
    required(category.name);
    if (!categoryIds.add(category.id)) {
      throw const CatalogRepositoryException.invalidResponse();
    }
  }
  final productIds = <String>{};
  for (final product in catalog.products) {
    required(product.id);
    required(product.categoryId);
    required(product.name);
    if (!productIds.add(product.id) ||
        !categoryIds.contains(product.categoryId) ||
        product.price < 0 ||
        (product.oldPrice ?? 0) < 0) {
      throw const CatalogRepositoryException.invalidResponse();
    }
  }
  return catalog;
}

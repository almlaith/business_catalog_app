import 'dart:convert';

import 'package:business_catalog_app/core/constants/app_assets.dart';
import 'package:business_catalog_app/features/catalog/data/catalog_repository.dart';
import 'package:business_catalog_app/models/catalog_data.dart';
import 'package:flutter/services.dart';

class LocalCatalogRepository implements CatalogRepository {
  LocalCatalogRepository({
    AssetBundle? assetBundle,
    this.assetPath = AppAssets.catalogData,
  }) : _assetBundle = assetBundle ?? rootBundle;

  final AssetBundle _assetBundle;
  final String assetPath;

  @override
  Future<CatalogData> loadCatalog() async {
    final rawJson = await _assetBundle.loadString(assetPath);
    final decodedJson = jsonDecode(rawJson);

    if (decodedJson is! Map<String, Object?>) {
      throw const FormatException('Catalog data must be a JSON object.');
    }

    final catalog = CatalogData.fromJson(decodedJson);
    _validateCatalog(catalog);

    return catalog;
  }

  void _validateCatalog(CatalogData catalog) {
    _validateRequiredId(catalog.business.id, 'business.id');
    _validateRequiredId(catalog.business.businessName, 'business.businessName');

    final categoryIds = <String>{};
    for (final category in catalog.categories) {
      _validateRequiredId(category.id, 'category.id');
      _validateRequiredId(category.name, 'category.name');
      if (!categoryIds.add(category.id)) {
        throw FormatException('Duplicate category id: ${category.id}');
      }
    }

    final productIds = <String>{};
    for (final product in catalog.products) {
      _validateRequiredId(product.id, 'product.id');
      _validateRequiredId(product.categoryId, 'product.categoryId');
      _validateRequiredId(product.name, 'product.name');
      if (!productIds.add(product.id)) {
        throw FormatException('Duplicate product id: ${product.id}');
      }
      if (!categoryIds.contains(product.categoryId)) {
        throw FormatException(
          'Product "${product.id}" references an unknown category.',
        );
      }
      if (product.price < 0 || (product.oldPrice ?? 0) < 0) {
        throw FormatException('Product "${product.id}" has a negative price.');
      }
    }
  }

  void _validateRequiredId(String value, String fieldName) {
    if (value.trim().isEmpty) {
      throw FormatException('$fieldName must not be empty.');
    }
  }
}

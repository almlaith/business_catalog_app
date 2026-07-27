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

    return CatalogData.fromJson(decodedJson);
  }
}

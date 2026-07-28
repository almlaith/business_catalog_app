import 'dart:convert';
import 'dart:io';

import 'package:business_catalog_app/core/constants/app_assets.dart';
import 'package:business_catalog_app/features/catalog/data/local_catalog_repository.dart';
import 'package:business_catalog_app/models/catalog_data.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('CatalogData', () {
    test('parses sample catalog JSON', () {
      final rawJson = File(AppAssets.catalogData).readAsStringSync();
      final catalogJson = jsonDecode(rawJson) as Map<String, Object?>;
      final catalog = CatalogData.fromJson(catalogJson);

      expect(catalog.business.businessName, 'Aura Atelier');
      expect(catalog.business.currencyCode, 'USD');
      expect(catalog.categories, hasLength(4));
      expect(catalog.products, hasLength(16));
      expect(
        catalog.products.where((product) => product.isFeatured),
        isNotEmpty,
      );
    });

    test('bundles every catalog image asset', () async {
      final rawJson = File(AppAssets.catalogData).readAsStringSync();
      final catalog = CatalogData.fromJson(
        jsonDecode(rawJson) as Map<String, Object?>,
      );
      final manifest = await AssetManifest.loadFromAssetBundle(rootBundle);
      final bundledAssets = manifest.listAssets().toSet();
      final catalogImages = <String>{
        catalog.business.logoAsset,
        ...catalog.categories.map((category) => category.imageAsset),
        ...catalog.products.map((product) => product.imageAsset),
      };

      for (final imagePath in catalogImages) {
        expect(
          bundledAssets,
          contains(imagePath),
          reason: 'Catalog image is not bundled: $imagePath',
        );
      }
    });
  });

  group('LocalCatalogRepository', () {
    test('loads and parses catalog JSON from an asset bundle', () async {
      final repository = LocalCatalogRepository(
        assetBundle: _FakeCatalogAssetBundle({
          AppAssets.catalogData: File(AppAssets.catalogData).readAsStringSync(),
        }),
      );

      final catalog = await repository.loadCatalog();

      expect(catalog.business.id, 'aura-atelier');
      expect(
        catalog.categories.map((category) => category.id),
        contains('oud-collection'),
      );
      expect(
        catalog.products.map((product) => product.categoryId).toSet(),
        containsAll([
          'signature-scents',
          'oud-collection',
          'body-care',
          'gift-sets',
        ]),
      );
    });

    test('throws a format exception when the asset root is not an object', () {
      final repository = LocalCatalogRepository(
        assetBundle: _FakeCatalogAssetBundle({AppAssets.catalogData: '[]'}),
      );

      expect(repository.loadCatalog, throwsA(isA<FormatException>()));
    });
  });
}

class _FakeCatalogAssetBundle extends CachingAssetBundle {
  _FakeCatalogAssetBundle(this._assets);

  final Map<String, String> _assets;

  @override
  Future<ByteData> load(String key) async {
    final content = _assets[key];

    if (content == null) {
      throw StateError('Unable to load asset: $key');
    }

    final bytes = Uint8List.fromList(utf8.encode(content));
    return ByteData.view(bytes.buffer);
  }

  @override
  Future<String> loadString(String key, {bool cache = true}) async {
    final content = _assets[key];

    if (content == null) {
      throw StateError('Unable to load asset: $key');
    }

    return content;
  }
}

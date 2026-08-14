import 'dart:async';
import 'dart:convert';

import 'package:business_catalog_app/core/network/api_client.dart';
import 'package:business_catalog_app/features/catalog/data/catalog_repository.dart';
import 'package:business_catalog_app/features/catalog/data/decimal_money.dart';
import 'package:business_catalog_app/features/catalog/data/remote_catalog_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  group('decimal money conversion', () {
    for (final entry in const {
      '0.99': 99,
      '9.99': 999,
      '29.95': 2995,
      '100.00': 10000,
      '199.99': 19999,
    }.entries) {
      test('${entry.key} converts exactly to ${entry.value} cents', () {
        expect(decimalToCents(entry.key), entry.value);
        expect((decimalToMoney(entry.key) * 100).round(), entry.value);
      });
    }
  });

  group('RemoteCatalogRepository', () {
    test('maps a complete successful catalog response', () async {
      final repository = _repository((request) async {
        expect(request.url.path, '/api/v1/catalog');
        return http.Response(jsonEncode(_catalogJson), 200);
      });

      final catalog = await repository.loadCatalog();

      expect(catalog.business.id, 'aura-atelier');
      expect(catalog.business.logoAsset, 'https://example.test/logo.png');
      expect(catalog.business.openingHours.keys, ['monday', 'tuesday']);
      expect(catalog.business.openingHours['monday'], '10:00 - 20:00');
      expect(catalog.business.openingHours['tuesday'], 'Closed');
      expect(catalog.categories.single.id, 'oud-collection');
      expect(catalog.categories.single.isActive, isTrue);
      final product = catalog.products.single;
      expect(product.id, 'imperial-oud');
      expect(product.categoryId, 'oud-collection');
      expect((product.price * 100).round(), 2995);
      expect(product.oldPrice, isNull);
      expect(product.isFeatured, isTrue);
      expect(product.isAvailable, isFalse);
      expect(product.tags, ['oud', 'amber']);
    });

    for (final status in [400, 404, 500]) {
      test('maps HTTP $status to a repository exception', () {
        final repository = _repository(
          (_) async => http.Response('failure details', status),
        );
        expect(
          repository.loadCatalog,
          throwsA(isA<CatalogRepositoryException>()),
        );
      });
    }

    test('maps invalid JSON to invalid response', () {
      final repository = _repository((_) async => http.Response('{', 200));
      expect(
        repository.loadCatalog,
        throwsA(
          isA<CatalogRepositoryException>().having(
            (error) => error.error,
            'error',
            CatalogRepositoryError.invalidResponse,
          ),
        ),
      );
    });

    test('maps incomplete JSON to invalid response', () {
      final repository = _repository((_) async => http.Response('{}', 200));
      expect(
        repository.loadCatalog,
        throwsA(isA<CatalogRepositoryException>()),
      );
    });

    test('maps request timeout without leaking TimeoutException', () {
      final repository = RemoteCatalogRepository(
        ApiClient(
          baseUrl: Uri.parse('https://example.test'),
          timeout: Duration.zero,
          httpClient: MockClient((_) => Completer<http.Response>().future),
        ),
      );
      expect(
        repository.loadCatalog,
        throwsA(
          isA<CatalogRepositoryException>().having(
            (error) => error.error,
            'error',
            CatalogRepositoryError.timeout,
          ),
        ),
      );
    });

    test('maps network failures without leaking client exceptions', () {
      final repository = _repository(
        (_) async => throw http.ClientException('connection refused'),
      );
      expect(
        repository.loadCatalog,
        throwsA(
          isA<CatalogRepositoryException>().having(
            (error) => error.error,
            'error',
            CatalogRepositoryError.network,
          ),
        ),
      );
    });

    test('refresh-style subsequent load requests new data', () async {
      var requests = 0;
      final repository = _repository((_) async {
        requests++;
        final json = Map<String, Object?>.from(_catalogJson);
        json['business'] = {
          ...(_catalogJson['business']! as Map<String, Object?>),
          'businessName': 'Aura $requests',
        };
        return http.Response(jsonEncode(json), 200);
      });
      expect((await repository.loadCatalog()).business.businessName, 'Aura 1');
      expect((await repository.loadCatalog()).business.businessName, 'Aura 2');
      expect(requests, 2);
    });

    test('deduplicates concurrent requests', () async {
      var requests = 0;
      final repository = _repository((_) async {
        requests++;
        await Future<void>.delayed(Duration.zero);
        return http.Response(jsonEncode(_catalogJson), 200);
      });
      await Future.wait([repository.loadCatalog(), repository.loadCatalog()]);
      expect(requests, 1);
    });
  });
}

RemoteCatalogRepository _repository(
  Future<http.Response> Function(http.Request) handler,
) => RemoteCatalogRepository(
  ApiClient(
    baseUrl: Uri.parse('https://example.test'),
    httpClient: MockClient(handler),
  ),
);

final Map<String, Object?> _catalogJson = {
  'business': {
    'id': 'aura-atelier',
    'businessName': 'Aura Atelier',
    'shortDescription': 'Curated scents.',
    'logoUrl': 'https://example.test/logo.png',
    'phoneNumber': '+1',
    'whatsappNumber': '1',
    'email': 'hello@example.test',
    'address': 'Amman',
    'currencyCode': 'USD',
    'defaultLocale': 'en',
    'primaryColorHex': '#000000',
    'secondaryColorHex': '#FFFFFF',
    'instagramUrl': '',
    'facebookUrl': '',
    'openingHours': [
      {
        'dayOfWeek': 'TUESDAY',
        'opensAt': null,
        'closesAt': null,
        'closed': true,
        'displayOrder': 2,
      },
      {
        'dayOfWeek': 'MONDAY',
        'opensAt': '10:00:00',
        'closesAt': '20:00:00',
        'closed': false,
        'displayOrder': 1,
      },
    ],
  },
  'categories': [
    {
      'id': 'oud-collection',
      'name': 'Oud Collection',
      'description': 'Oud',
      'imageUrl': 'assets/category.webp',
      'displayOrder': 1,
      'active': true,
    },
  ],
  'products': [
    {
      'id': 'imperial-oud',
      'categoryId': 'oud-collection',
      'name': 'Imperial Oud',
      'description': 'Oud perfume',
      'imageUrl': 'https://example.test/product.webp',
      'price': 29.95,
      'oldPrice': null,
      'featured': true,
      'available': false,
      'displayOrder': 1,
      'tags': ['oud', 'amber'],
    },
  ],
};

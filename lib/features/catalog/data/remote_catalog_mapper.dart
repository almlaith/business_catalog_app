import 'package:business_catalog_app/features/catalog/data/decimal_money.dart';
import 'package:business_catalog_app/models/business_config.dart';
import 'package:business_catalog_app/models/catalog_data.dart';
import 'package:business_catalog_app/models/category.dart';
import 'package:business_catalog_app/models/product.dart';

CatalogData mapRemoteCatalog(Map<String, Object?> json) {
  final business = _object(json, 'business');
  return CatalogData(
    business: BusinessConfig(
      id: _string(business, 'id'),
      businessName: _string(business, 'businessName'),
      shortDescription: _optionalString(business, 'shortDescription'),
      logoAsset: _optionalString(business, 'logoUrl'),
      phoneNumber: _optionalString(business, 'phoneNumber'),
      whatsappNumber: _optionalString(business, 'whatsappNumber'),
      email: _optionalString(business, 'email'),
      address: _optionalString(business, 'address'),
      currencyCode: _optionalString(business, 'currencyCode', fallback: 'USD'),
      defaultLocale: _optionalString(business, 'defaultLocale', fallback: 'en'),
      primaryColorHex: _optionalString(business, 'primaryColorHex'),
      secondaryColorHex: _optionalString(business, 'secondaryColorHex'),
      instagramUrl: _optionalString(business, 'instagramUrl'),
      facebookUrl: _optionalString(business, 'facebookUrl'),
      openingHours: _openingHours(business['openingHours']),
    ),
    categories: _list(json, 'categories')
        .map((value) {
          final item = _map(value);
          return Category(
            id: _string(item, 'id'),
            name: _string(item, 'name'),
            description: _optionalString(item, 'description'),
            imageAsset: _optionalString(item, 'imageUrl'),
            displayOrder: _int(item, 'displayOrder'),
            isActive: _bool(item, 'active'),
          );
        })
        .toList(growable: false),
    products: _list(json, 'products')
        .map((value) {
          final item = _map(value);
          return Product(
            id: _string(item, 'id'),
            categoryId: _string(item, 'categoryId'),
            name: _string(item, 'name'),
            description: _optionalString(item, 'description'),
            imageAsset: _optionalString(item, 'imageUrl'),
            price: decimalToMoney(item['price']),
            oldPrice: item['oldPrice'] == null
                ? null
                : decimalToMoney(item['oldPrice']),
            isFeatured: _bool(item, 'featured'),
            isAvailable: _bool(item, 'available'),
            displayOrder: _int(item, 'displayOrder'),
            tags: _list(
              item,
              'tags',
            ).map((tag) => tag as String).toList(growable: false),
          );
        })
        .toList(growable: false),
  );
}

Map<String, String> _openingHours(Object? value) {
  if (value == null) return const {};
  if (value is! List) throw const FormatException('Invalid openingHours.');
  final entries = <({int order, String day, String value})>[];
  for (final raw in value) {
    final item = _map(raw);
    final day = _string(item, 'dayOfWeek').toLowerCase();
    final closed = _bool(item, 'closed');
    final hours = closed
        ? 'Closed'
        : '${_time(item, 'opensAt')} - ${_time(item, 'closesAt')}';
    entries.add((order: _int(item, 'displayOrder'), day: day, value: hours));
  }
  entries.sort((a, b) => a.order.compareTo(b.order));
  return {for (final entry in entries) entry.day: entry.value};
}

String _time(Map<String, Object?> json, String key) {
  final value = _string(json, key);
  final match = RegExp(r'^(\d{2}):(\d{2})(?::\d{2})?$').firstMatch(value);
  if (match == null) {
    throw FormatException('Invalid $key.');
  }
  return '${match.group(1)}:${match.group(2)}';
}

Map<String, Object?> _object(Map<String, Object?> json, String key) =>
    _map(json[key]);
Map<String, Object?> _map(Object? value) {
  if (value is! Map<String, Object?>) {
    throw const FormatException('Expected object.');
  }
  return value;
}

List<Object?> _list(Map<String, Object?> json, String key) {
  final value = json[key];
  if (value is! List) throw FormatException('Expected list: $key.');
  return value;
}

String _string(Map<String, Object?> json, String key) {
  final value = json[key];
  if (value is! String || value.trim().isEmpty) {
    throw FormatException('Invalid $key.');
  }
  return value;
}

String _optionalString(
  Map<String, Object?> json,
  String key, {
  String fallback = '',
}) => json[key] == null ? fallback : (json[key] as String);
int _int(Map<String, Object?> json, String key) => (json[key] as num).toInt();
bool _bool(Map<String, Object?> json, String key) => json[key] as bool;

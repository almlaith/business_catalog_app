import 'package:business_catalog_app/models/business_config.dart';
import 'package:business_catalog_app/models/category.dart';
import 'package:business_catalog_app/models/product.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'catalog_data.freezed.dart';
part 'catalog_data.g.dart';

@freezed
abstract class CatalogData with _$CatalogData {
  const factory CatalogData({
    required BusinessConfig business,
    required List<Category> categories,
    required List<Product> products,
  }) = _CatalogData;

  factory CatalogData.fromJson(Map<String, Object?> json) =>
      _$CatalogDataFromJson(json);
}

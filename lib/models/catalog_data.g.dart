// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'catalog_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CatalogData _$CatalogDataFromJson(Map<String, dynamic> json) => _CatalogData(
  business: BusinessConfig.fromJson(json['business'] as Map<String, dynamic>),
  categories: (json['categories'] as List<dynamic>)
      .map((e) => Category.fromJson(e as Map<String, dynamic>))
      .toList(),
  products: (json['products'] as List<dynamic>)
      .map((e) => Product.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$CatalogDataToJson(_CatalogData instance) =>
    <String, dynamic>{
      'business': instance.business,
      'categories': instance.categories,
      'products': instance.products,
    };

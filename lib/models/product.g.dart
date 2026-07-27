// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Product _$ProductFromJson(Map<String, dynamic> json) => _Product(
  id: json['id'] as String,
  categoryId: json['categoryId'] as String,
  name: json['name'] as String,
  description: json['description'] as String,
  imageAsset: json['imageAsset'] as String,
  price: (json['price'] as num).toDouble(),
  oldPrice: (json['oldPrice'] as num?)?.toDouble(),
  isFeatured: json['isFeatured'] as bool,
  isAvailable: json['isAvailable'] as bool,
  displayOrder: (json['displayOrder'] as num).toInt(),
  tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
);

Map<String, dynamic> _$ProductToJson(_Product instance) => <String, dynamic>{
  'id': instance.id,
  'categoryId': instance.categoryId,
  'name': instance.name,
  'description': instance.description,
  'imageAsset': instance.imageAsset,
  'price': instance.price,
  'oldPrice': instance.oldPrice,
  'isFeatured': instance.isFeatured,
  'isAvailable': instance.isAvailable,
  'displayOrder': instance.displayOrder,
  'tags': instance.tags,
};

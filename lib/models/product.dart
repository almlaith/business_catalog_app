import 'package:freezed_annotation/freezed_annotation.dart';

part 'product.freezed.dart';
part 'product.g.dart';

@freezed
abstract class Product with _$Product {
  const factory Product({
    required String id,
    required String categoryId,
    required String name,
    required String description,
    required String imageAsset,
    required double price,
    required double? oldPrice,
    required bool isFeatured,
    required bool isAvailable,
    required int displayOrder,
    required List<String> tags,
  }) = _Product;

  factory Product.fromJson(Map<String, Object?> json) =>
      _$ProductFromJson(json);
}

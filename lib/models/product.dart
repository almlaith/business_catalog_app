import 'package:freezed_annotation/freezed_annotation.dart';

part 'product.freezed.dart';
part 'product.g.dart';

@freezed
abstract class Product with _$Product {
  const factory Product({
    required String id,
    required String categoryId,
    required String name,
    @Default('') String description,
    @Default('') String imageAsset,
    required double price,
    double? oldPrice,
    @Default(false) bool isFeatured,
    @Default(true) bool isAvailable,
    @Default(0) int displayOrder,
    @Default(<String>[]) List<String> tags,
  }) = _Product;

  factory Product.fromJson(Map<String, Object?> json) =>
      _$ProductFromJson(json);
}

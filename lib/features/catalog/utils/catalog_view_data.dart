import 'package:business_catalog_app/models/catalog_data.dart';
import 'package:business_catalog_app/models/category.dart';
import 'package:business_catalog_app/models/product.dart';

extension CatalogViewData on CatalogData {
  List<Category> get activeCategoriesSorted {
    return [...categories]
      ..removeWhere((category) => !category.isActive)
      ..sort((a, b) => a.displayOrder.compareTo(b.displayOrder));
  }

  List<Product> get availableProductsSorted {
    return [...products]
      ..removeWhere((product) => !product.isAvailable)
      ..sort((a, b) => a.displayOrder.compareTo(b.displayOrder));
  }

  List<Product> get featuredAvailableProductsSorted {
    return availableProductsSorted
        .where((product) => product.isFeatured)
        .toList(growable: false);
  }

  List<Product> availableProductsForCategory(String? categoryId) {
    final products = availableProductsSorted;

    if (categoryId == null || categoryId.isEmpty) {
      return products;
    }

    return products
        .where((product) => product.categoryId == categoryId)
        .toList(growable: false);
  }

  Category? categoryById(String categoryId) {
    for (final category in categories) {
      if (category.id == categoryId) {
        return category;
      }
    }

    return null;
  }

  Product? productById(String productId) {
    for (final product in products) {
      if (product.id == productId) {
        return product;
      }
    }

    return null;
  }
}

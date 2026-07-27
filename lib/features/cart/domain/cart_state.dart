import 'package:business_catalog_app/features/cart/domain/cart_item.dart';

class CartState {
  const CartState({this.items = const []});

  final List<CartItem> items;

  bool get isEmpty => items.isEmpty;

  bool get isNotEmpty => items.isNotEmpty;

  int get totalUniqueProducts => items.length;

  int get totalItemQuantity {
    return items.fold(0, (total, item) => total + item.quantity);
  }

  int get subtotalCents {
    return items.fold(0, (total, item) => total + item.lineTotalCents);
  }

  double get subtotal => subtotalCents / 100;

  CartItem? itemForProduct(String productId) {
    for (final item in items) {
      if (item.product.id == productId) {
        return item;
      }
    }

    return null;
  }

  CartState copyWith({List<CartItem>? items}) {
    return CartState(items: List.unmodifiable(items ?? this.items));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is CartState &&
            other.items.length == items.length &&
            _itemsEqual(other.items, items);
  }

  @override
  int get hashCode => Object.hashAll(items);

  static bool _itemsEqual(List<CartItem> a, List<CartItem> b) {
    for (var index = 0; index < a.length; index++) {
      if (a[index] != b[index]) {
        return false;
      }
    }

    return true;
  }
}

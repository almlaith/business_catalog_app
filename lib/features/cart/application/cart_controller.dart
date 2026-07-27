import 'package:business_catalog_app/features/cart/domain/cart_item.dart';
import 'package:business_catalog_app/features/cart/domain/cart_state.dart';
import 'package:business_catalog_app/models/product.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final cartControllerProvider = NotifierProvider<CartController, CartState>(
  CartController.new,
);

class CartController extends Notifier<CartState> {
  @override
  CartState build() {
    return const CartState();
  }

  void addProduct(Product product, {int quantity = 1}) {
    if (quantity <= 0) {
      return;
    }

    final nextItems = [...state.items];
    final index = nextItems.indexWhere((item) => item.product.id == product.id);

    if (index == -1) {
      nextItems.add(CartItem(product: product, quantity: quantity));
    } else {
      final existingItem = nextItems[index];
      nextItems[index] = existingItem.copyWith(
        product: product,
        quantity: existingItem.quantity + quantity,
      );
    }

    state = state.copyWith(items: nextItems);
  }

  void increaseQuantity(String productId) {
    _updateQuantity(productId, by: 1);
  }

  void decreaseQuantity(String productId) {
    _updateQuantity(productId, by: -1);
  }

  void removeProduct(String productId) {
    state = state.copyWith(
      items: [
        for (final item in state.items)
          if (item.product.id != productId) item,
      ],
    );
  }

  void clear() {
    state = const CartState();
  }

  void _updateQuantity(String productId, {required int by}) {
    final nextItems = <CartItem>[];

    for (final item in state.items) {
      if (item.product.id != productId) {
        nextItems.add(item);
        continue;
      }

      final nextQuantity = item.quantity + by;
      if (nextQuantity > 0) {
        nextItems.add(item.copyWith(quantity: nextQuantity));
      }
    }

    state = state.copyWith(items: nextItems);
  }
}

import 'package:business_catalog_app/models/product.dart';

class CartItem {
  const CartItem({required this.product, required this.quantity})
    : assert(quantity > 0, 'Quantity must be greater than zero.');

  final Product product;
  final int quantity;

  int get unitPriceCents => (product.price * 100).round();

  int get lineTotalCents => unitPriceCents * quantity;

  double get lineTotal => lineTotalCents / 100;

  CartItem copyWith({Product? product, int? quantity}) {
    return CartItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is CartItem &&
            other.product == product &&
            other.quantity == quantity;
  }

  @override
  int get hashCode => Object.hash(product, quantity);
}

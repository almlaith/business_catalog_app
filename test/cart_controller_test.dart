import 'dart:convert';
import 'dart:io';

import 'package:business_catalog_app/core/constants/app_assets.dart';
import 'package:business_catalog_app/features/cart/application/cart_controller.dart';
import 'package:business_catalog_app/models/catalog_data.dart';
import 'package:business_catalog_app/models/product.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late Product product;
  late Product secondProduct;

  setUpAll(() {
    final rawJson = File(AppAssets.catalogData).readAsStringSync();
    final catalog = CatalogData.fromJson(
      jsonDecode(rawJson) as Map<String, Object?>,
    );
    product = catalog.products.first;
    secondProduct = catalog.products[1];
  });

  ProviderContainer createContainer() {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    return container;
  }

  test('adds a new product', () {
    final container = createContainer();

    container.read(cartControllerProvider.notifier).addProduct(product);

    final cart = container.read(cartControllerProvider);
    expect(cart.items, hasLength(1));
    expect(cart.items.single.product, product);
    expect(cart.items.single.quantity, 1);
  });

  test('adding the same product twice increases quantity', () {
    final container = createContainer();
    final controller = container.read(cartControllerProvider.notifier);

    controller.addProduct(product);
    controller.addProduct(product);

    final cart = container.read(cartControllerProvider);
    expect(cart.items, hasLength(1));
    expect(cart.items.single.quantity, 2);
  });

  test('increases and decreases quantities', () {
    final container = createContainer();
    final controller = container.read(cartControllerProvider.notifier);

    controller.addProduct(product);
    controller.increaseQuantity(product.id);
    controller.decreaseQuantity(product.id);

    expect(container.read(cartControllerProvider).items.single.quantity, 1);
  });

  test('decreasing quantity to zero removes the product', () {
    final container = createContainer();
    final controller = container.read(cartControllerProvider.notifier);

    controller.addProduct(product);
    controller.decreaseQuantity(product.id);

    expect(container.read(cartControllerProvider).isEmpty, isTrue);
  });

  test('removes a product', () {
    final container = createContainer();
    final controller = container.read(cartControllerProvider.notifier);

    controller.addProduct(product);
    controller.addProduct(secondProduct);
    controller.removeProduct(product.id);

    final cart = container.read(cartControllerProvider);
    expect(cart.items, hasLength(1));
    expect(cart.items.single.product, secondProduct);
  });

  test('clears the cart', () {
    final container = createContainer();
    final controller = container.read(cartControllerProvider.notifier);

    controller.addProduct(product);
    controller.addProduct(secondProduct);
    controller.clear();

    expect(container.read(cartControllerProvider).isEmpty, isTrue);
  });

  test('calculates subtotal', () {
    final container = createContainer();
    final controller = container.read(cartControllerProvider.notifier);

    controller.addProduct(product, quantity: 2);
    controller.addProduct(secondProduct);

    final expectedCents =
        (product.price * 100).round() * 2 + (secondProduct.price * 100).round();

    expect(container.read(cartControllerProvider).subtotalCents, expectedCents);
  });

  test('calculates total quantity', () {
    final container = createContainer();
    final controller = container.read(cartControllerProvider.notifier);

    controller.addProduct(product, quantity: 2);
    controller.addProduct(secondProduct, quantity: 3);

    expect(container.read(cartControllerProvider).totalItemQuantity, 5);
  });
}

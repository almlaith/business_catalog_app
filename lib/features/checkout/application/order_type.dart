enum OrderType {
  pickup,
  delivery;

  String get label {
    return switch (this) {
      OrderType.pickup => 'Pickup',
      OrderType.delivery => 'Delivery',
    };
  }
}

// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Business Catalog';

  @override
  String get homeTitle => 'Home';

  @override
  String get catalogTitle => 'Catalog';

  @override
  String get productDetailsTitle => 'Product Details';

  @override
  String get cartTitle => 'Cart';

  @override
  String get businessInfoTitle => 'Business Information';

  @override
  String get placeholderLabel => 'Placeholder screen';

  @override
  String get loadingCatalog => 'Loading catalog...';

  @override
  String get unableToLoadCatalog => 'Unable to load catalog data.';

  @override
  String get productNotFound => 'Product not found.';

  @override
  String get retry => 'Retry';

  @override
  String get allCategories => 'All';

  @override
  String get categoriesSection => 'Categories';

  @override
  String get featuredSection => 'Featured';

  @override
  String get viewCatalog => 'View Catalog';

  @override
  String get noCategories => 'No active categories are available yet.';

  @override
  String get noFeaturedProducts => 'No featured products are available yet.';

  @override
  String get noProducts => 'No products are available for this category.';

  @override
  String get available => 'Available';

  @override
  String get unavailable => 'Unavailable';

  @override
  String get addToCart => 'Add to Cart';

  @override
  String get addedToCart => 'Added to cart';

  @override
  String get viewCart => 'View Cart';

  @override
  String get cartEmpty => 'Your cart is empty.';

  @override
  String get browseCatalog => 'Browse Catalog';

  @override
  String get subtotal => 'Subtotal';

  @override
  String get clearCart => 'Clear cart';

  @override
  String get clearCartQuestion => 'Clear cart?';

  @override
  String get clearCartMessage => 'This will remove all items from your cart.';

  @override
  String get cancel => 'Cancel';

  @override
  String get clear => 'Clear';

  @override
  String get continueAction => 'Continue';

  @override
  String get checkoutTitle => 'Checkout';

  @override
  String get checkoutNotImplemented =>
      'Payment and order history are not implemented yet.';

  @override
  String get customerDetails => 'Customer Details';

  @override
  String get orderSummary => 'Order Summary';

  @override
  String get customerName => 'Customer name';

  @override
  String get phoneNumber => 'Phone number';

  @override
  String get orderNotes => 'Order notes';

  @override
  String get orderType => 'Order type';

  @override
  String get pickup => 'Pickup';

  @override
  String get delivery => 'Delivery';

  @override
  String get deliveryAddress => 'Delivery address';

  @override
  String get sendOrderViaWhatsapp => 'Send Order via WhatsApp';

  @override
  String get requiredField => 'This field is required.';

  @override
  String get whatsappUnavailable => 'Unable to open WhatsApp.';

  @override
  String get invalidWhatsappNumber =>
      'The business WhatsApp number is missing or invalid.';

  @override
  String get orderSent => 'Order opened in WhatsApp.';

  @override
  String get clearCartAfterOrderQuestion => 'Clear cart?';

  @override
  String get clearCartAfterOrderMessage =>
      'Would you like to clear the cart now?';

  @override
  String get keepCart => 'Keep cart';

  @override
  String get businessDescription => 'Description';

  @override
  String get phone => 'Phone';

  @override
  String get email => 'Email';

  @override
  String get address => 'Address';

  @override
  String get openingHours => 'Opening hours';

  @override
  String get instagram => 'Instagram';

  @override
  String get facebook => 'Facebook';

  @override
  String get unableToOpenLink => 'Unable to open this link.';

  @override
  String get removeItem => 'Remove item';

  @override
  String get decreaseQuantity => 'Decrease quantity';

  @override
  String get increaseQuantity => 'Increase quantity';

  @override
  String get missingImage => 'Image unavailable';

  @override
  String orderMessageGreeting(Object businessName) {
    return 'Hello $businessName,';
  }

  @override
  String get orderMessageIntro => 'I would like to place an order.';

  @override
  String get orderMessageCustomerSection => 'Customer:';

  @override
  String get orderMessageName => 'Name';

  @override
  String get orderMessagePhone => 'Phone';

  @override
  String get orderMessageOrderType => 'Order type';

  @override
  String get orderMessageDeliveryAddress => 'Delivery address';

  @override
  String get orderMessageItems => 'Items:';

  @override
  String get orderMessageNotes => 'Notes:';
}

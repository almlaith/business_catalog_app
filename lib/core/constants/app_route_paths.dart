abstract final class AppRouteNames {
  static const home = 'home';
  static const catalog = 'catalog';
  static const productDetails = 'productDetails';
  static const cart = 'cart';
  static const checkout = 'checkout';
  static const businessInfo = 'businessInfo';
  static const settings = 'settings';
  static const helpSupport = 'helpSupport';
}

abstract final class AppRouteParams {
  static const productId = 'productId';
  static const categoryId = 'categoryId';
}

abstract final class AppRoutePaths {
  static const home = '/';
  static const catalog = '/catalog';
  static const productDetailsSegment = ':${AppRouteParams.productId}';
  static const productDetails = '/catalog/$productDetailsSegment';
  static const cart = '/cart';
  static const checkoutSegment = 'checkout';
  static const checkout = '/cart/$checkoutSegment';
  static const businessInfo = '/business-info';
  static const settingsSegment = 'settings';
  static const settings = '/business-info/$settingsSegment';
  static const helpSupportSegment = 'help-support';
  static const helpSupport = '$settings/$helpSupportSegment';

  static String productDetailsPath(String productId) => '/catalog/$productId';

  static String catalogForCategory(String categoryId) {
    return Uri(
      path: catalog,
      queryParameters: {AppRouteParams.categoryId: categoryId},
    ).toString();
  }
}

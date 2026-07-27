abstract final class AppRouteNames {
  static const home = 'home';
  static const catalog = 'catalog';
  static const productDetails = 'productDetails';
  static const cart = 'cart';
  static const businessInfo = 'businessInfo';
}

abstract final class AppRouteParams {
  static const productId = 'productId';
}

abstract final class AppRoutePaths {
  static const home = '/';
  static const catalog = '/catalog';
  static const productDetailsSegment = ':${AppRouteParams.productId}';
  static const productDetails = '/catalog/$productDetailsSegment';
  static const cart = '/cart';
  static const businessInfo = '/business-info';

  static String productDetailsPath(String productId) => '/catalog/$productId';
}

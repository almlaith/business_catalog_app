import 'package:business_catalog_app/core/constants/app_route_paths.dart';
import 'package:business_catalog_app/features/business_info/presentation/business_info_screen.dart';
import 'package:business_catalog_app/features/cart/presentation/cart_screen.dart';
import 'package:business_catalog_app/features/catalog/presentation/catalog_screen.dart';
import 'package:business_catalog_app/features/home/presentation/home_screen.dart';
import 'package:business_catalog_app/features/product_details/presentation/product_details_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final appRouterProvider = Provider<GoRouter>(
  (ref) => GoRouter(
    initialLocation: AppRoutePaths.home,
    routes: [
      GoRoute(
        path: AppRoutePaths.home,
        name: AppRouteNames.home,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: AppRoutePaths.catalog,
        name: AppRouteNames.catalog,
        builder: (context, state) => const CatalogScreen(),
      ),
      GoRoute(
        path: AppRoutePaths.productDetails,
        name: AppRouteNames.productDetails,
        builder: (context, state) => ProductDetailsScreen(
          productId: state.pathParameters[AppRouteParams.productId] ?? '',
        ),
      ),
      GoRoute(
        path: AppRoutePaths.cart,
        name: AppRouteNames.cart,
        builder: (context, state) => const CartScreen(),
      ),
      GoRoute(
        path: AppRoutePaths.businessInfo,
        name: AppRouteNames.businessInfo,
        builder: (context, state) => const BusinessInfoScreen(),
      ),
    ],
  ),
);

import 'package:business_catalog_app/app/shell/app_shell.dart';
import 'package:business_catalog_app/core/constants/app_route_paths.dart';
import 'package:business_catalog_app/features/business_info/presentation/business_info_screen.dart';
import 'package:business_catalog_app/features/cart/presentation/cart_screen.dart';
import 'package:business_catalog_app/features/catalog/presentation/catalog_screen.dart';
import 'package:business_catalog_app/features/home/presentation/home_screen.dart';
import 'package:business_catalog_app/features/product_details/presentation/product_details_screen.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _homeNavigatorKey = GlobalKey<NavigatorState>();
final _catalogNavigatorKey = GlobalKey<NavigatorState>();
final _cartNavigatorKey = GlobalKey<NavigatorState>();
final _businessInfoNavigatorKey = GlobalKey<NavigatorState>();

final appRouterProvider = Provider<GoRouter>(
  (ref) => GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutePaths.home,
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            AppShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            navigatorKey: _homeNavigatorKey,
            routes: [
              GoRoute(
                path: AppRoutePaths.home,
                name: AppRouteNames.home,
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _catalogNavigatorKey,
            routes: [
              GoRoute(
                path: AppRoutePaths.catalog,
                name: AppRouteNames.catalog,
                builder: (context, state) => CatalogScreen(
                  initialCategoryId:
                      state.uri.queryParameters[AppRouteParams.categoryId],
                ),
                routes: [
                  GoRoute(
                    path: AppRoutePaths.productDetailsSegment,
                    name: AppRouteNames.productDetails,
                    builder: (context, state) => ProductDetailsScreen(
                      productId:
                          state.pathParameters[AppRouteParams.productId] ?? '',
                    ),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _cartNavigatorKey,
            routes: [
              GoRoute(
                path: AppRoutePaths.cart,
                name: AppRouteNames.cart,
                builder: (context, state) => const CartScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _businessInfoNavigatorKey,
            routes: [
              GoRoute(
                path: AppRoutePaths.businessInfo,
                name: AppRouteNames.businessInfo,
                builder: (context, state) => const BusinessInfoScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  ),
);

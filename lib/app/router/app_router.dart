import 'package:business_catalog_app/app/shell/app_shell.dart';
import 'package:business_catalog_app/core/constants/app_route_paths.dart';
import 'package:business_catalog_app/features/business_info/presentation/business_info_screen.dart';
import 'package:business_catalog_app/features/cart/presentation/cart_screen.dart';
import 'package:business_catalog_app/features/catalog/presentation/catalog_screen.dart';
import 'package:business_catalog_app/features/checkout/presentation/checkout_screen.dart';
import 'package:business_catalog_app/features/help_support/presentation/help_support_screen.dart';
import 'package:business_catalog_app/features/home/presentation/home_screen.dart';
import 'package:business_catalog_app/features/product_details/presentation/product_details_screen.dart';
import 'package:business_catalog_app/features/settings/presentation/settings_screen.dart';
import 'package:flutter/material.dart';
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
                    pageBuilder: (context, state) => _nestedPage(
                      state,
                      ProductDetailsScreen(
                        productId:
                            state.pathParameters[AppRouteParams.productId] ??
                            '',
                      ),
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
                routes: [
                  GoRoute(
                    path: AppRoutePaths.checkoutSegment,
                    name: AppRouteNames.checkout,
                    pageBuilder: (context, state) =>
                        _nestedPage(state, const CheckoutScreen()),
                  ),
                ],
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
                routes: [
                  GoRoute(
                    path: AppRoutePaths.settingsSegment,
                    name: AppRouteNames.settings,
                    pageBuilder: (context, state) =>
                        _nestedPage(state, const SettingsScreen()),
                    routes: [
                      GoRoute(
                        path: AppRoutePaths.helpSupportSegment,
                        name: AppRouteNames.helpSupport,
                        pageBuilder: (context, state) =>
                            _nestedPage(state, const HelpSupportScreen()),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  ),
);

CustomTransitionPage<void> _nestedPage(GoRouterState state, Widget child) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    transitionDuration: const Duration(milliseconds: 260),
    reverseTransitionDuration: const Duration(milliseconds: 220),
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final reduceMotion =
          MediaQuery.disableAnimationsOf(context) ||
          MediaQuery.accessibleNavigationOf(context);
      final isRtl = Directionality.of(context) == TextDirection.rtl;
      final background = Theme.of(context).colorScheme.surfaceContainerLowest;
      if (reduceMotion) {
        return ColoredBox(color: background, child: child);
      }

      final offset = Tween<Offset>(
        begin: Offset(isRtl ? -0.10 : 0.10, 0),
        end: Offset.zero,
      ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic));
      final fade = CurvedAnimation(parent: animation, curve: Curves.easeOut);

      return ColoredBox(
        color: background,
        child: FadeTransition(
          opacity: fade,
          child: SlideTransition(position: offset, child: child),
        ),
      );
    },
  );
}

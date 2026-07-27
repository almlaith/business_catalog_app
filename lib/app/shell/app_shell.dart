import 'package:business_catalog_app/app/theme/aurora_tokens.dart';
import 'package:business_catalog_app/core/constants/app_spacing.dart';
import 'package:business_catalog_app/core/extensions/build_context_extensions.dart';
import 'package:business_catalog_app/features/cart/application/cart_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AppShell extends ConsumerWidget {
  const AppShell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final totalItemQuantity = ref.watch(
      cartControllerProvider.select((cart) => cart.totalItemQuantity),
    );
    final l10n = context.l10n;
    final reduceMotion =
        MediaQuery.disableAnimationsOf(context) ||
        MediaQuery.accessibleNavigationOf(context);

    return Scaffold(
      body: TweenAnimationBuilder<double>(
        key: ValueKey(navigationShell.currentIndex),
        tween: Tween(begin: 0, end: 1),
        duration: reduceMotion ? Duration.zero : AppDurations.medium,
        curve: AuroraMotion.curve,
        builder: (context, value, child) {
          return ColoredBox(
            color: Theme.of(context).colorScheme.surfaceContainerLowest,
            child: Opacity(
              opacity: value,
              child: Transform.translate(
                offset: Offset(0, 8 * (1 - value)),
                child: child,
              ),
            ),
          );
        },
        child: navigationShell,
      ),
      extendBody: true,
      bottomNavigationBar: _AuroraBottomNavigation(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: _goToBranch,
        items: [
          _AuroraNavItem(
            icon: Icons.home_rounded,
            inactiveIcon: Icons.home_outlined,
            label: l10n.homeTitle,
          ),
          _AuroraNavItem(
            icon: Icons.storefront_rounded,
            inactiveIcon: Icons.storefront_outlined,
            label: l10n.catalogTitle,
          ),
          _AuroraNavItem(
            icon: Icons.shopping_bag_rounded,
            inactiveIcon: Icons.shopping_bag_outlined,
            label: l10n.cartTitle,
            badgeCount: totalItemQuantity,
          ),
          _AuroraNavItem(
            icon: Icons.info_rounded,
            inactiveIcon: Icons.info_outline_rounded,
            label: l10n.businessInfoNavLabel,
          ),
        ],
      ),
    );
  }

  void _goToBranch(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}

class _AuroraBottomNavigation extends StatelessWidget {
  const _AuroraBottomNavigation({
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.items,
  });

  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final List<_AuroraNavItem> items;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return LayoutBuilder(
      builder: (context, constraints) {
        final horizontalMargin = constraints.maxWidth < 340 ? 8.0 : 14.0;
        final itemSpacing = constraints.maxWidth < 340 ? 3.0 : 5.0;
        final horizontalPadding = constraints.maxWidth < 340 ? 3.0 : 6.0;

        return SafeArea(
          minimum: EdgeInsets.fromLTRB(
            horizontalMargin,
            0,
            horizontalMargin,
            12,
          ),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerLow.withValues(
                alpha: isDark ? 0.92 : 0.88,
              ),
              borderRadius: BorderRadius.circular(AppRadii.xxl),
              border: Border.all(
                color: colorScheme.outlineVariant.withValues(alpha: 0.88),
              ),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.shadow.withValues(
                    alpha: isDark ? 0.35 : 0.12,
                  ),
                  blurRadius: 34,
                  offset: const Offset(0, 18),
                ),
                BoxShadow(
                  color: colorScheme.primary.withValues(
                    alpha: isDark ? 0.18 : 0.10,
                  ),
                  blurRadius: 28,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppRadii.xxl),
              child: SizedBox(
                height: AppHeights.navDock,
                child: Row(
                  children: [
                    for (var index = 0; index < items.length; index++)
                      Expanded(
                        child: _AuroraNavDestination(
                          item: items[index],
                          selected: selectedIndex == index,
                          onTap: () => onDestinationSelected(index),
                          margin: EdgeInsets.symmetric(
                            horizontal: itemSpacing,
                            vertical: 9,
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: horizontalPadding,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _AuroraNavDestination extends StatelessWidget {
  const _AuroraNavDestination({
    required this.item,
    required this.selected,
    required this.onTap,
    required this.margin,
    required this.padding,
  });

  final _AuroraNavItem item;
  final bool selected;
  final VoidCallback onTap;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Semantics(
      button: true,
      selected: selected,
      label: item.label,
      child: InkWell(
        onTap: onTap,
        customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.xxl),
        ),
        child: AnimatedContainer(
          duration: AppDurations.medium,
          curve: AuroraMotion.curve,
          margin: margin,
          padding: padding,
          decoration: BoxDecoration(
            gradient: selected ? AuroraGradients.primary : null,
            color: selected ? null : Colors.transparent,
            borderRadius: BorderRadius.circular(AppRadii.xl),
            boxShadow: selected
                ? AuroraShadows.glow(colorScheme.primary, opacity: 0.24)
                : null,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _AuroraNavIcon(item: item, selected: selected),
              const SizedBox(height: 4),
              AnimatedDefaultTextStyle(
                duration: AppDurations.fast,
                curve: AuroraMotion.curve,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.labelSmall!.copyWith(
                  color: selected
                      ? Colors.white
                      : colorScheme.onSurfaceVariant.withValues(alpha: 0.88),
                  fontSize: 10.5,
                  fontWeight: selected ? FontWeight.w900 : FontWeight.w700,
                ),
                child: Text(
                  item.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AuroraNavIcon extends StatelessWidget {
  const _AuroraNavIcon({required this.item, required this.selected});

  final _AuroraNavItem item;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final iconWidget = AnimatedSwitcher(
      duration: AppDurations.fast,
      child: Icon(
        selected ? item.icon : item.inactiveIcon,
        key: ValueKey(selected),
        size: 23,
        color: selected ? Colors.white : colorScheme.onSurfaceVariant,
      ),
    );

    if (item.badgeCount <= 0) {
      return iconWidget;
    }

    return TweenAnimationBuilder<double>(
      key: ValueKey(item.badgeCount),
      tween: Tween(begin: 0.86, end: 1),
      duration: const Duration(milliseconds: 220),
      curve: AuroraMotion.emphasized,
      builder: (context, scale, child) =>
          Transform.scale(scale: scale, child: child),
      child: Badge(
        backgroundColor: AuroraColors.coral,
        textColor: Colors.white,
        largeSize: 18,
        padding: const EdgeInsets.symmetric(horizontal: 5),
        label: Text('${item.badgeCount}'),
        child: iconWidget,
      ),
    );
  }
}

class _AuroraNavItem {
  const _AuroraNavItem({
    required this.icon,
    required this.inactiveIcon,
    required this.label,
    this.badgeCount = 0,
  });

  final IconData icon;
  final IconData inactiveIcon;
  final String label;
  final int badgeCount;
}

import 'package:business_catalog_app/core/constants/app_spacing.dart';
import 'package:business_catalog_app/core/extensions/build_context_extensions.dart';
import 'package:flutter/material.dart';

class AppSkeletonBox extends StatelessWidget {
  const AppSkeletonBox({
    this.width,
    this.height = 16,
    this.borderRadius = AppRadii.sm,
    super.key,
  });

  final double? width;
  final double height;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(
      context,
    ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.72);

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.45, end: 1),
      duration: AppDurations.slow,
      curve: Curves.easeInOut,
      builder: (context, opacity, child) =>
          Opacity(opacity: opacity, child: child),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: SizedBox(width: width, height: height),
      ),
    );
  }
}

class AppSkeletonCatalog extends StatelessWidget {
  const AppSkeletonCatalog({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: AppSpacing.page,
      children: [
        Text(
          context.l10n.loadingCatalog,
          style: Theme.of(context).textTheme.labelLarge,
        ),
        const SizedBox(height: AppSpacing.md),
        const AppSkeletonBox(height: 156, borderRadius: AppRadii.lg),
        const SizedBox(height: AppSpacing.xxl),
        const AppSkeletonBox(width: 140, height: 22),
        const SizedBox(height: AppSpacing.md),
        SizedBox(
          height: 128,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: 3,
            separatorBuilder: (context, index) =>
                const SizedBox(width: AppSpacing.md),
            itemBuilder: (context, index) =>
                const AppSkeletonBox(width: 150, height: 128),
          ),
        ),
        const SizedBox(height: AppSpacing.xxl),
        const AppSkeletonBox(width: 160, height: 22),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: const [
            Expanded(child: AppSkeletonBox(height: 220)),
            SizedBox(width: AppSpacing.md),
            Expanded(child: AppSkeletonBox(height: 220)),
          ],
        ),
      ],
    );
  }
}

class AppSkeletonDetails extends StatelessWidget {
  const AppSkeletonDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(bottom: 120),
      children: const [
        AspectRatio(aspectRatio: 1.08, child: AppSkeletonBox(height: 260)),
        Padding(
          padding: AppSpacing.page,
          child: AppSkeletonBox(height: 220, borderRadius: AppRadii.lg),
        ),
      ],
    );
  }
}

class AppSkeletonInfo extends StatelessWidget {
  const AppSkeletonInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: AppSpacing.page,
      children: const [
        AppSkeletonBox(height: 116, borderRadius: AppRadii.lg),
        SizedBox(height: AppSpacing.lg),
        AppSkeletonBox(height: 72),
        SizedBox(height: AppSpacing.md),
        AppSkeletonBox(height: 72),
        SizedBox(height: AppSpacing.md),
        AppSkeletonBox(height: 72),
      ],
    );
  }
}

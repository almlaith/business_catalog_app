import 'package:business_catalog_app/core/constants/app_spacing.dart';
import 'package:business_catalog_app/core/extensions/build_context_extensions.dart';
import 'package:business_catalog_app/core/widgets/aurora_background.dart';
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
    final colorScheme = Theme.of(context).colorScheme;
    final color = Color.alphaBlend(
      colorScheme.primary.withValues(alpha: 0.05),
      colorScheme.surfaceContainerHighest.withValues(alpha: 0.86),
    );

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.45, end: 1),
      duration: AppDurations.slow,
      curve: Curves.easeInOut,
      builder: (context, opacity, child) =>
          Opacity(opacity: opacity, child: child),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: color,
          gradient: LinearGradient(
            begin: AlignmentDirectional.topStart,
            end: AlignmentDirectional.bottomEnd,
            colors: [
              color,
              colorScheme.surfaceContainerHigh.withValues(alpha: 0.72),
            ],
          ),
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(
            color: colorScheme.outlineVariant.withValues(alpha: 0.62),
          ),
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
    return AuroraBackground(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.lg,
          AppSpacing.lg,
          112,
        ),
        children: [
          Text(
            context.l10n.loadingCatalog,
            style: Theme.of(context).textTheme.labelLarge,
          ),
          const SizedBox(height: AppSpacing.md),
          const AppSkeletonBox(height: 178, borderRadius: AppRadii.xxl),
          const SizedBox(height: AppSpacing.xxl),
          const AppSkeletonBox(
            width: 140,
            height: 22,
            borderRadius: AppRadii.md,
          ),
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            height: 146,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: 3,
              separatorBuilder: (context, index) =>
                  const SizedBox(width: AppSpacing.md),
              itemBuilder: (context, index) => const AppSkeletonBox(
                width: 160,
                height: 146,
                borderRadius: AppRadii.xl,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),
          const AppSkeletonBox(
            width: 160,
            height: 22,
            borderRadius: AppRadii.md,
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: const [
              Expanded(
                child: AppSkeletonBox(height: 248, borderRadius: AppRadii.xl),
              ),
              SizedBox(width: AppSpacing.md),
              Expanded(
                child: AppSkeletonBox(height: 248, borderRadius: AppRadii.xl),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class AppSkeletonDetails extends StatelessWidget {
  const AppSkeletonDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return AuroraBackground(
      child: ListView(
        padding: const EdgeInsets.only(bottom: 120),
        children: const [
          AspectRatio(
            aspectRatio: 1.02,
            child: AppSkeletonBox(height: 300, borderRadius: 0),
          ),
          Padding(
            padding: AppSpacing.page,
            child: AppSkeletonBox(height: 240, borderRadius: AppRadii.xxl),
          ),
        ],
      ),
    );
  }
}

class AppSkeletonInfo extends StatelessWidget {
  const AppSkeletonInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return AuroraBackground(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.lg,
          AppSpacing.lg,
          112,
        ),
        children: const [
          AppSkeletonBox(height: 132, borderRadius: AppRadii.xxl),
          SizedBox(height: AppSpacing.lg),
          AppSkeletonBox(height: 82, borderRadius: AppRadii.xl),
          SizedBox(height: AppSpacing.md),
          AppSkeletonBox(height: 82, borderRadius: AppRadii.xl),
          SizedBox(height: AppSpacing.md),
          AppSkeletonBox(height: 82, borderRadius: AppRadii.xl),
        ],
      ),
    );
  }
}

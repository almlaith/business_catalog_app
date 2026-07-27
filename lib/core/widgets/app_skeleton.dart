import 'package:business_catalog_app/core/constants/app_spacing.dart';
import 'package:business_catalog_app/core/extensions/build_context_extensions.dart';
import 'package:business_catalog_app/core/widgets/aurora_background.dart';
import 'package:flutter/material.dart';

class AppSkeletonBox extends StatefulWidget {
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
  State<AppSkeletonBox> createState() => _AppSkeletonBoxState();
}

class _AppSkeletonBoxState extends State<AppSkeletonBox>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: AppDurations.slow)
      ..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final reduceMotion =
        MediaQuery.disableAnimationsOf(context) ||
        MediaQuery.accessibleNavigationOf(context);
    final base = Color.alphaBlend(
      colorScheme.primary.withValues(alpha: 0.06),
      colorScheme.surfaceContainerHigh,
    );
    final highlight = Color.alphaBlend(
      colorScheme.secondary.withValues(alpha: 0.08),
      colorScheme.surfaceContainerHighest,
    );

    Widget box(double value) {
      return DecoratedBox(
        decoration: BoxDecoration(
          color: base,
          gradient: reduceMotion
              ? null
              : LinearGradient(
                  begin: Alignment(-1.4 + value * 1.8, -1),
                  end: Alignment(-0.2 + value * 1.8, 1),
                  colors: [base, highlight, base],
                ),
          borderRadius: BorderRadius.circular(widget.borderRadius),
          border: Border.all(
            color: colorScheme.outlineVariant.withValues(alpha: 0.58),
          ),
        ),
        child: SizedBox(width: widget.width, height: widget.height),
      );
    }

    if (reduceMotion) {
      return box(0);
    }

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => box(_controller.value),
    );
  }
}

class AppSkeletonHome extends StatelessWidget {
  const AppSkeletonHome({super.key});

  @override
  Widget build(BuildContext context) {
    return AuroraBackground(
      child: ListView(
        key: const ValueKey('catalog-skeleton-scroll-view'),
        physics: const AlwaysScrollableScrollPhysics(),
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

class AppSkeletonCatalog extends StatelessWidget {
  const AppSkeletonCatalog({super.key});

  @override
  Widget build(BuildContext context) {
    return AuroraBackground(
      child: ListView(
        key: const ValueKey('catalog-skeleton-scroll-view'),
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.lg,
          AppSpacing.lg,
          112,
        ),
        children: const [
          AppSkeletonBox(height: 112, borderRadius: AppRadii.xxl),
          SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              AppSkeletonBox(
                width: 82,
                height: 42,
                borderRadius: AppRadii.pill,
              ),
              SizedBox(width: AppSpacing.sm),
              AppSkeletonBox(
                width: 110,
                height: 42,
                borderRadius: AppRadii.pill,
              ),
              SizedBox(width: AppSpacing.sm),
              AppSkeletonBox(
                width: 96,
                height: 42,
                borderRadius: AppRadii.pill,
              ),
            ],
          ),
          SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(
                child: AppSkeletonBox(height: 248, borderRadius: AppRadii.xl),
              ),
              SizedBox(width: AppSpacing.md),
              Expanded(
                child: AppSkeletonBox(height: 248, borderRadius: AppRadii.xl),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.md),
          Row(
            children: [
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
        physics: const AlwaysScrollableScrollPhysics(),
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
        key: const ValueKey('info-skeleton-scroll-view'),
        physics: const AlwaysScrollableScrollPhysics(),
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

class AppSkeletonHelpSupport extends StatelessWidget {
  const AppSkeletonHelpSupport({super.key});

  @override
  Widget build(BuildContext context) {
    return AuroraBackground(
      child: ListView(
        key: const ValueKey('help-skeleton-scroll-view'),
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.lg,
          AppSpacing.lg,
          112,
        ),
        children: const [
          AppSkeletonBox(height: 128, borderRadius: AppRadii.xxl),
          SizedBox(height: AppSpacing.lg),
          AppSkeletonBox(height: 84, borderRadius: AppRadii.xl),
          SizedBox(height: AppSpacing.md),
          AppSkeletonBox(height: 84, borderRadius: AppRadii.xl),
          SizedBox(height: AppSpacing.md),
          AppSkeletonBox(height: 84, borderRadius: AppRadii.xl),
          SizedBox(height: AppSpacing.xxl),
          AppSkeletonBox(width: 170, height: 22, borderRadius: AppRadii.md),
          SizedBox(height: AppSpacing.md),
          AppSkeletonBox(height: 68, borderRadius: AppRadii.xl),
          SizedBox(height: AppSpacing.sm),
          AppSkeletonBox(height: 68, borderRadius: AppRadii.xl),
          SizedBox(height: AppSpacing.xxl),
          AppSkeletonBox(height: 118, borderRadius: AppRadii.xl),
        ],
      ),
    );
  }
}

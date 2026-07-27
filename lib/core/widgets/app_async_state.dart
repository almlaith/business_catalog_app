import 'package:business_catalog_app/app/theme/aurora_tokens.dart';
import 'package:business_catalog_app/core/constants/app_spacing.dart';
import 'package:business_catalog_app/core/extensions/build_context_extensions.dart';
import 'package:business_catalog_app/core/widgets/aurora_components.dart';
import 'package:flutter/material.dart';

class AppLoadingState extends StatelessWidget {
  const AppLoadingState({this.message, super.key});

  final String? message;

  @override
  Widget build(BuildContext context) {
    final text = message ?? context.l10n.loadingCatalog;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: AuroraCard(
          useGradientBorder: true,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const _AuroraLoader(),
              const SizedBox(height: AppSpacing.lg),
              Text(
                text,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AppErrorState extends StatelessWidget {
  const AppErrorState({
    required this.error,
    this.onRetry,
    this.title,
    super.key,
  });

  final Object error;
  final VoidCallback? onRetry;
  final String? title;

  @override
  Widget build(BuildContext context) {
    final title = this.title ?? context.l10n.unableToLoadCatalog;
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: AuroraCard(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const AuroraIconContainer(
                icon: Icons.error_rounded,
                color: AuroraColors.error,
                size: 58,
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                title,
                textAlign: TextAlign.center,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                error.toString(),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              if (onRetry != null) ...[
                const SizedBox(height: AppSpacing.lg),
                FilledButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh_rounded),
                  label: Text(context.l10n.retry),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class AppEmptyState extends StatelessWidget {
  const AppEmptyState({required this.message, super.key});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: AppDurations.medium,
          curve: AuroraMotion.curve,
          builder: (context, value, child) => Opacity(
            opacity: value,
            child: Transform.translate(
              offset: Offset(0, 12 * (1 - value)),
              child: child,
            ),
          ),
          child: AuroraCard(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: AuroraGradients.primary,
                    borderRadius: BorderRadius.circular(AppRadii.xl),
                    boxShadow: AuroraShadows.glow(
                      Theme.of(context).colorScheme.primary,
                      opacity: 0.18,
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(AppSpacing.lg),
                    child: Icon(
                      Icons.inventory_2_outlined,
                      size: 34,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AuroraLoader extends StatelessWidget {
  const _AuroraLoader();

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: AppDurations.slow,
      curve: AuroraMotion.emphasized,
      builder: (context, value, child) =>
          Transform.rotate(angle: value * 0.35, child: child),
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: AuroraGradients.primary,
          borderRadius: BorderRadius.circular(AppRadii.xl),
          boxShadow: AuroraShadows.glow(
            Theme.of(context).colorScheme.primary,
            opacity: 0.18,
          ),
        ),
        child: const SizedBox.square(
          dimension: 48,
          child: Icon(Icons.auto_awesome_rounded, color: Colors.white),
        ),
      ),
    );
  }
}

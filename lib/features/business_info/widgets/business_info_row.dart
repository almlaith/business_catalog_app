import 'package:business_catalog_app/core/constants/app_spacing.dart';
import 'package:business_catalog_app/core/widgets/aurora_components.dart';
import 'package:flutter/material.dart';

class BusinessInfoRow extends StatelessWidget {
  const BusinessInfoRow({
    required this.icon,
    required this.title,
    required this.value,
    this.actionLabel,
    this.onTap,
    super.key,
  });

  final IconData icon;
  final String title;
  final String value;
  final String? actionLabel;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    if (value.trim().isEmpty) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.xs,
      ),
      child: AuroraCard(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(AppRadii.xl),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.xs),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AuroraIconContainer(icon: icon),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          value,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            height: 1.32,
                          ),
                        ),
                        if (actionLabel != null) ...[
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            actionLabel!,
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (onTap != null) ...[
                    const SizedBox(width: AppSpacing.sm),
                    Icon(
                      Icons.north_east_rounded,
                      color: theme.colorScheme.onSurfaceVariant,
                      size: AppIconSizes.sm,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

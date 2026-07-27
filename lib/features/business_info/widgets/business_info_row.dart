import 'package:business_catalog_app/core/constants/app_spacing.dart';
import 'package:flutter/material.dart';

class BusinessInfoRow extends StatelessWidget {
  const BusinessInfoRow({
    required this.icon,
    required this.title,
    required this.value,
    this.onTap,
    super.key,
  });

  final IconData icon;
  final String title;
  final String value;
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
      child: Card(
        child: ListTile(
          minVerticalPadding: AppSpacing.md,
          leading: DecoratedBox(
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.sm),
              child: Icon(icon, color: theme.colorScheme.onPrimaryContainer),
            ),
          ),
          title: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.labelLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w700,
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: AppSpacing.xs),
            child: Text(
              value,
              style: theme.textTheme.bodyMedium?.copyWith(height: 1.32),
            ),
          ),
          trailing: onTap == null ? null : const Icon(Icons.open_in_new),
          onTap: onTap,
        ),
      ),
    );
  }
}

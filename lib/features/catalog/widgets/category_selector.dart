import 'package:business_catalog_app/app/theme/aurora_tokens.dart';
import 'package:business_catalog_app/core/constants/app_spacing.dart';
import 'package:business_catalog_app/core/extensions/build_context_extensions.dart';
import 'package:business_catalog_app/models/category.dart';
import 'package:flutter/material.dart';

class CategorySelector extends StatelessWidget {
  const CategorySelector({
    required this.categories,
    required this.selectedCategoryId,
    required this.onSelected,
    super.key,
  });

  final List<Category> categories;
  final String? selectedCategoryId;
  final ValueChanged<String?> onSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return SizedBox(
      height: AppHeights.chip,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        itemCount: categories.length + 1,
        separatorBuilder: (context, index) =>
            const SizedBox(width: AppSpacing.sm),
        itemBuilder: (context, index) {
          if (index == 0) {
            return _CategoryFilterChip(
              label: l10n.allCategories,
              selected: selectedCategoryId == null,
              onTap: () => onSelected(null),
            );
          }

          final category = categories[index - 1];

          return _CategoryFilterChip(
            label: category.name,
            selected: selectedCategoryId == category.id,
            onTap: () => onSelected(category.id),
          );
        },
      ),
    );
  }
}

class _CategoryFilterChip extends StatelessWidget {
  const _CategoryFilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AnimatedContainer(
      duration: AppDurations.medium,
      curve: AuroraMotion.curve,
      decoration: BoxDecoration(
        gradient: selected ? AuroraGradients.primary : null,
        color: selected ? null : colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadii.pill),
        border: Border.all(
          color: selected
              ? Colors.white.withValues(alpha: 0.20)
              : colorScheme.outlineVariant,
        ),
        boxShadow: selected
            ? AuroraShadows.glow(colorScheme.primary, opacity: 0.18, blur: 18)
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadii.pill),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.sm,
            ),
            child: AnimatedDefaultTextStyle(
              duration: AppDurations.fast,
              style: theme.textTheme.labelLarge!.copyWith(
                color: selected ? Colors.white : colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w900,
              ),
              child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
            ),
          ),
        ),
      ),
    );
  }
}

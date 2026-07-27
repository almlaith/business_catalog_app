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
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      height: 52,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        itemCount: categories.length + 1,
        separatorBuilder: (context, index) =>
            const SizedBox(width: AppSpacing.sm),
        itemBuilder: (context, index) {
          if (index == 0) {
            return ChoiceChip(
              label: Text(l10n.allCategories),
              selected: selectedCategoryId == null,
              showCheckmark: false,
              selectedColor: colorScheme.primary,
              labelStyle: TextStyle(
                color: selectedCategoryId == null
                    ? colorScheme.onPrimary
                    : colorScheme.onSurface,
                fontWeight: FontWeight.w700,
              ),
              onSelected: (_) => onSelected(null),
            );
          }

          final category = categories[index - 1];

          return ChoiceChip(
            label: Text(category.name),
            selected: selectedCategoryId == category.id,
            showCheckmark: false,
            selectedColor: colorScheme.primary,
            labelStyle: TextStyle(
              color: selectedCategoryId == category.id
                  ? colorScheme.onPrimary
                  : colorScheme.onSurface,
              fontWeight: FontWeight.w700,
            ),
            onSelected: (_) => onSelected(category.id),
          );
        },
      ),
    );
  }
}

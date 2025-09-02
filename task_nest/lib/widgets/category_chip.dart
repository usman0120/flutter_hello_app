import 'package:flutter/material.dart';
import 'package:tasknest/models/category_model.dart';
import 'package:tasknest/utils/helpers.dart';

class CategoryChip extends StatelessWidget {
  final Category category;
  final bool isSelected;
  final VoidCallback onTap;
  final bool showCounts;

  const CategoryChip({
    super.key,
    required this.category,
    this.isSelected = false,
    required this.onTap,
    this.showCounts = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = Helpers.hexToColor(category.colorCode);

    // Create colors with proper opacity using withAlpha instead of withOpacity
    final backgroundColor = color.withAlpha((255 * 0.2).round()); // 20% opacity
    final selectedColor = color.withAlpha((255 * 0.4).round()); // 40% opacity
    final surfaceColorWithOpacity = theme.colorScheme.onSurface
        .withAlpha((255 * 0.7).round()); // 70% opacity

    return FilterChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(category.icon),
          const SizedBox(width: 4),
          Text(category.name),
          if (showCounts) ...[
            const SizedBox(width: 4),
            Text(
              '(${category.taskCount + category.habitCount})',
              style: theme.textTheme.bodySmall?.copyWith(
                color: surfaceColorWithOpacity,
              ),
            ),
          ],
        ],
      ),
      selected: isSelected,
      onSelected: (_) => onTap(),
      backgroundColor: backgroundColor,
      selectedColor: selectedColor,
      checkmarkColor: theme.colorScheme.onPrimary,
      labelStyle: theme.textTheme.bodyMedium?.copyWith(
        color: isSelected
            ? theme.colorScheme.onPrimary
            : theme.colorScheme.onSurface,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: color,
          width: isSelected ? 2 : 1,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact,
    );
  }
}

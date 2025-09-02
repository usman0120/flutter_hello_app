// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:tasknest/models/habit_model.dart';
import 'package:tasknest/utils/helpers.dart';
import 'package:tasknest/utils/theme.dart';
import 'package:tasknest/widgets/progress_ring.dart';

class HabitTile extends StatelessWidget {
  final Habit habit;
  final VoidCallback onTap;
  final VoidCallback onComplete;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const HabitTile({
    super.key,
    required this.habit,
    required this.onTap,
    required this.onComplete,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final completionRate = habit.completionRate;
    final streak = habit.currentStreak;
    final colorScheme = theme.colorScheme;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration:
              AppThemes.getCardDecoration(context, colorHex: habit.colorCode),
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              ProgressRing(
                progress: completionRate,
                radius: 30,
                progressColor: Helpers.hexToColor(habit.colorCode),
                centerText: '${(completionRate * 100).toInt()}%',
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      habit.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (habit.description.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        habit.description,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurface.withOpacity(0.7),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: [
                        _buildChip(
                          context,
                          icon: Icons.category,
                          label: habit.category,
                          color: Helpers.hexToColor(habit.colorCode),
                        ),
                        if (streak > 0)
                          _buildChip(
                            context,
                            icon: Icons.local_fire_department,
                            label: '$streak day streak',
                            color: Colors.orange,
                          ),
                        _buildChip(
                          context,
                          icon: Icons.repeat,
                          label: '${habit.targetFrequency}x/week',
                          color: colorScheme.secondary,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.check_circle,
                      color: colorScheme.primary,
                      size: 28,
                    ),
                    onPressed: onComplete,
                    tooltip: 'Mark as completed today',
                  ),
                  const SizedBox(height: 8),
                  PopupMenuButton(
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit,
                                size: 20, color: colorScheme.primary),
                            const SizedBox(width: 8),
                            const Text('Edit'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete, size: 20, color: Colors.red),
                            SizedBox(width: 8),
                            Text('Delete'),
                          ],
                        ),
                      ),
                    ],
                    onSelected: (value) {
                      if (value == 'edit') onEdit();
                      if (value == 'delete') onDelete();
                    },
                    icon: Icon(
                      Icons.more_vert,
                      color: colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChip(
    BuildContext context, {
    IconData? icon,
    required String label,
    required Color color,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Chip(
      label: Text(
        label,
        style: theme.textTheme.labelSmall?.copyWith(
          color: colorScheme.onPrimary,
        ),
      ),
      backgroundColor: color,
      avatar: icon != null
          ? Icon(
              icon,
              size: 14,
              color: colorScheme.onPrimary,
            )
          : null,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
      labelPadding: const EdgeInsets.symmetric(horizontal: 4),
    );
  }
}

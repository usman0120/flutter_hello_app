// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:tasknest/models/task_model.dart';
import 'package:tasknest/utils/helpers.dart';
import 'package:tasknest/utils/theme.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onTap;
  final VoidCallback onComplete;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const TaskCard({
    super.key,
    required this.task,
    required this.onTap,
    required this.onComplete,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isOverdue = Helpers.isTaskOverdue(task);
    final isDueSoon = Helpers.isTaskDueSoon(task);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration:
              AppThemes.getCardDecoration(context, colorHex: task.colorCode),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      task.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        decoration: task.isCompleted
                            ? TextDecoration.lineThrough
                            : null,
                        color: task.isCompleted
                            ? theme.colorScheme.onSurface.withOpacity(0.6)
                            : null,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      task.isCompleted ? Icons.undo : Icons.check_circle,
                      color: task.isCompleted
                          ? Colors.grey
                          : theme.colorScheme.primary,
                    ),
                    onPressed: onComplete,
                    tooltip: task.isCompleted
                        ? 'Mark as incomplete'
                        : 'Mark as complete',
                  ),
                ],
              ),
              if (task.description.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  task.description,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: [
                  _buildChip(
                    context,
                    icon: Icons.category,
                    label: task.category,
                    color: Helpers.hexToColor(task.colorCode),
                  ),
                  _buildChip(
                    context,
                    icon: Icons.flag,
                    label: task.priority,
                    color: _getPriorityColor(task.priority),
                  ),
                  _buildChip(
                    context,
                    icon: Icons.calendar_today,
                    label: Helpers.formatDate(task.dueDate),
                    color: isOverdue
                        ? Colors.red
                        : isDueSoon
                            ? Colors.orange
                            : theme.colorScheme.primary,
                  ),
                  ...task.tags.map((tag) => _buildChip(
                        context,
                        label: tag,
                        color: theme.colorScheme.secondary.withOpacity(0.3),
                      )),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (task.hasReminder)
                    Icon(
                      Icons.notifications_active,
                      size: 16,
                      color: theme.colorScheme.primary,
                    ),
                  const SizedBox(width: 8),
                  Text(
                    Helpers.getRelativeDate(task.dueDate),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isOverdue
                          ? Colors.red
                          : isDueSoon
                              ? Colors.orange
                              : theme.colorScheme.onSurface.withOpacity(0.6),
                      fontWeight:
                          isOverdue || isDueSoon ? FontWeight.bold : null,
                    ),
                  ),
                  const Spacer(),
                  PopupMenuButton(
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit,
                                size: 20, color: theme.colorScheme.primary),
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
                    icon: Icon(Icons.more_vert,
                        color: theme.colorScheme.onSurface.withOpacity(0.6)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      case 'low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  Widget _buildChip(
    BuildContext context, {
    IconData? icon,
    required String label,
    required Color color,
  }) {
    return Chip(
      label: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Theme.of(context).colorScheme.onPrimary,
            ),
      ),
      backgroundColor: color,
      avatar: icon != null
          ? Icon(
              icon,
              size: 14,
              color: Theme.of(context).colorScheme.onPrimary,
            )
          : null,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
      labelPadding: const EdgeInsets.symmetric(horizontal: 4),
    );
  }
}

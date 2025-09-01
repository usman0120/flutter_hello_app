import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasknest/models/task_model.dart';
import 'package:tasknest/services/database_service.dart';
import 'package:tasknest/services/notification_service.dart';
import 'package:tasknest/utils/helpers.dart';

class TaskCard extends StatefulWidget {
  final Task task;

  const TaskCard({super.key, required this.task});

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  late Task _task;
  final NotificationService _notificationService = NotificationService();

  @override
  void initState() {
    super.initState();
    _task = widget.task;
  }

  @override
  Widget build(BuildContext context) {
    final isOverdue = Helpers.isOverdue(_task.dueDate) && !_task.isCompleted;
    final isToday = Helpers.isToday(_task.dueDate);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isOverdue
            ? const BorderSide(color: Colors.red, width: 1)
            : BorderSide.none,
      ),
      child: InkWell(
        onTap: () => _showTaskDetails(context),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with title and checkbox
              Row(
                children: [
                  // Checkbox
                  Checkbox(
                    value: _task.isCompleted,
                    onChanged: (value) => _toggleTaskCompletion(value ?? false),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Title
                  Expanded(
                    child: Text(
                      _task.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        decoration: _task.isCompleted
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                        color: _task.isCompleted
                            ? Colors.grey
                            : Theme.of(context).colorScheme.onSurface,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  // Priority indicator
                  if (_task.priority != 'Medium')
                    Icon(
                      Helpers.getPriorityIcon(_task.priority),
                      size: 16,
                      color: Helpers.getPriorityColor(_task.priority),
                    ),
                ],
              ),
              const SizedBox(height: 12),

              // Description (if exists)
              if (_task.description.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    _task.description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                      fontStyle: FontStyle.italic,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

              // Metadata row
              Row(
                children: [
                  // Category chip
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      gradient: Helpers.getCategoryGradient(_task.category),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _task.category,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Due date
                  if (!_task.isCompleted)
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 14,
                          color: isOverdue
                              ? Colors.red
                              : isToday
                                  ? Colors.green
                                  : Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          Helpers.formatDate(_task.dueDate),
                          style: TextStyle(
                            fontSize: 12,
                            color: isOverdue
                                ? Colors.red
                                : isToday
                                    ? Colors.green
                                    : Colors.grey,
                            fontWeight: isOverdue || isToday
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                ],
              ),

              // Tags (if any)
              if (_task.tags.isNotEmpty) ...[
                const SizedBox(height: 8),
                Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  children: _task.tags.map((tag) {
                    return Chip(
                      label: Text(
                        tag,
                        style: const TextStyle(fontSize: 10),
                      ),
                      backgroundColor: Colors.grey.shade100,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      visualDensity: VisualDensity.compact,
                    );
                  }).toList(),
                ),
              ],

              // Reminder indicator
              if (_task.hasReminder && _task.reminderDate != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Row(
                    children: [
                      Icon(
                        Icons.notifications,
                        size: 14,
                        color: Theme.of(context).primaryColor,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Reminder: ${Helpers.formatDate(_task.reminderDate!)}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _toggleTaskCompletion(bool isCompleted) async {
    final databaseService =
        Provider.of<DatabaseService>(context, listen: false);

    try {
      final updatedTask = _task.copyWith(isCompleted: isCompleted);
      await databaseService.updateTask(updatedTask);

      // Cancel reminder if task is completed
      if (isCompleted && _task.hasReminder) {
        await _notificationService.cancelTaskReminder(_task.id!);
      }

      setState(() {
        _task = updatedTask;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isCompleted ? 'Task completed!' : 'Task marked as incomplete',
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error updating task'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showTaskDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return TaskDetailsBottomSheet(task: _task);
      },
    );
  }
}

class TaskDetailsBottomSheet extends StatefulWidget {
  final Task task;

  const TaskDetailsBottomSheet({super.key, required this.task});

  @override
  State<TaskDetailsBottomSheet> createState() => _TaskDetailsBottomSheetState();
}

class _TaskDetailsBottomSheetState extends State<TaskDetailsBottomSheet> {
  late Task _task;

  @override
  void initState() {
    super.initState();
    _task = widget.task;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Task Details',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Title
          Text(
            _task.title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),

          // Description
          if (_task.description.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Description:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 4),
                Text(_task.description),
                const SizedBox(height: 16),
              ],
            ),

          // Details Grid
          GridView.count(
            shrinkWrap: true,
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 3,
            children: [
              _buildDetailItem('Category', _task.category, Icons.category),
              _buildDetailItem('Priority', _task.priority, Icons.flag),
              _buildDetailItem(
                'Due Date',
                Helpers.formatDate(_task.dueDate, includeTime: true),
                Icons.calendar_today,
              ),
              if (_task.hasReminder && _task.reminderDate != null)
                _buildDetailItem(
                  'Reminder',
                  Helpers.formatDate(_task.reminderDate!, includeTime: true),
                  Icons.notifications,
                ),
            ],
          ),

          // Tags
          if (_task.tags.isNotEmpty) ...[
            const SizedBox(height: 16),
            const Text(
              'Tags:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: _task.tags
                  .map((tag) => Chip(
                        label: Text(tag),
                        backgroundColor: Colors.blue.shade100,
                      ))
                  .toList(),
            ),
          ],

          const SizedBox(height: 24),

          // Action Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: () => _editTask(),
                child: const Text('Edit'),
              ),
              ElevatedButton(
                onPressed: () => _deleteTask(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Delete'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _editTask() {
    Navigator.pop(context);
    // Navigate to edit task screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Edit task functionality coming soon')),
    );
  }

  void _deleteTask() async {
    final databaseService =
        Provider.of<DatabaseService>(context, listen: false);
    final notificationService = NotificationService();

    try {
      await databaseService.deleteTask(_task.id!);
      if (_task.hasReminder) {
        await notificationService.cancelTaskReminder(_task.id!);
      }
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Task deleted successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error deleting task'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}

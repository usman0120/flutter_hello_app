import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasknest/models/task_model.dart';
import 'package:tasknest/models/category_model.dart';
import 'package:tasknest/services/database_service.dart';
import 'package:tasknest/services/notification_service.dart';
import 'package:tasknest/utils/constants.dart';
import 'package:tasknest/utils/helpers.dart';
import 'package:tasknest/widgets/custom_appbar.dart';

class AddEditTaskScreen extends StatefulWidget {
  final Task? task;
  final VoidCallback onSave;

  const AddEditTaskScreen({
    super.key,
    this.task,
    required this.onSave,
  });

  @override
  State<AddEditTaskScreen> createState() => _AddEditTaskScreenState();
}

class _AddEditTaskScreenState extends State<AddEditTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late DateTime _dueDate;
  late String _priority;
  late String _category;
  late String _colorCode;
  late List<String> _tags;
  late bool _hasReminder;
  final TextEditingController _tagController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final task = widget.task;
    _titleController = TextEditingController(text: task?.title ?? '');
    _descriptionController =
        TextEditingController(text: task?.description ?? '');
    _dueDate = task?.dueDate ?? DateTime.now().add(const Duration(days: 1));
    _priority = task?.priority ?? AppConstants.priorityLevels[1];
    _category = task?.category ?? Categories.defaultCategories.first.name;
    _colorCode = task?.colorCode ?? AppConstants.colorOptions.first;
    _tags = task?.tags ?? [];
    _hasReminder = task?.hasReminder ?? false;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _tagController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final databaseService =
        Provider.of<DatabaseService>(context, listen: false);
    final isEditing = widget.task != null;

    return Scaffold(
      appBar: CustomAppBar(
        title: isEditing ? 'Edit Task' : 'Add New Task',
        showBackButton: true,
        onBackPressed: () => _confirmExit(context),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTitleField(),
              const SizedBox(height: 16),
              _buildDescriptionField(),
              const SizedBox(height: 16),
              _buildDueDatePicker(),
              const SizedBox(height: 16),
              _buildPriorityDropdown(),
              const SizedBox(height: 16),
              _buildCategoryDropdown(databaseService),
              const SizedBox(height: 16),
              _buildColorPicker(),
              const SizedBox(height: 16),
              _buildTagsInput(),
              const SizedBox(height: 16),
              _buildReminderSwitch(),
              const SizedBox(height: 24),
              _buildSaveButton(databaseService, isEditing),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitleField() {
    return TextFormField(
      controller: _titleController,
      decoration: const InputDecoration(
        labelText: 'Task Title',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.title),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a task title';
        }
        return null;
      },
    );
  }

  Widget _buildDescriptionField() {
    return TextFormField(
      controller: _descriptionController,
      decoration: const InputDecoration(
        labelText: 'Description (Optional)',
        border: OutlineInputBorder(),
        alignLabelWithHint: true,
      ),
      maxLines: 3,
    );
  }

  Widget _buildDueDatePicker() {
    return InkWell(
      onTap: () => _selectDate(context),
      child: InputDecorator(
        decoration: const InputDecoration(
          labelText: 'Due Date',
          border: OutlineInputBorder(),
          prefixIcon: Icon(Icons.calendar_today),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(Helpers.formatDate(_dueDate)),
            const Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }

  Widget _buildPriorityDropdown() {
    return DropdownButtonFormField<String>(
      initialValue: _priority,
      decoration: const InputDecoration(
        labelText: 'Priority',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.flag),
      ),
      items: AppConstants.priorityLevels.map((String priority) {
        return DropdownMenuItem<String>(
          value: priority,
          child: Text(priority),
        );
      }).toList(),
      onChanged: (String? newValue) {
        if (newValue != null) {
          setState(() {
            _priority = newValue;
          });
        }
      },
    );
  }

  Widget _buildCategoryDropdown(DatabaseService databaseService) {
    return FutureBuilder<List<Category>>(
      future:
          databaseService.getAllCategories().then((categories) => categories),
      builder: (context, snapshot) {
        final categories = snapshot.data ?? Categories.defaultCategories;
        return DropdownButtonFormField<String>(
          initialValue: _category,
          decoration: const InputDecoration(
            labelText: 'Category',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.category),
          ),
          items: categories.map((Category category) {
            return DropdownMenuItem<String>(
              value: category.name,
              child: Row(
                children: [
                  Text(category.icon),
                  const SizedBox(width: 8),
                  Text(category.name),
                ],
              ),
            );
          }).toList(),
          onChanged: (String? newValue) {
            if (newValue != null) {
              setState(() {
                _category = newValue;
                // Set color to match category
                final selectedCategory = categories.firstWhere(
                  (cat) => cat.name == newValue,
                  orElse: () => Categories.defaultCategories.first,
                );
                _colorCode = selectedCategory.colorCode;
              });
            }
          },
        );
      },
    );
  }

  Widget _buildColorPicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Color', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: AppConstants.colorOptions.map((color) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  _colorCode = color;
                });
              },
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Helpers.hexToColor(color),
                  shape: BoxShape.circle,
                  border: _colorCode == color
                      ? Border.all(color: Colors.white, width: 3)
                      : null,
                ),
                child: _colorCode == color
                    ? const Icon(Icons.check, color: Colors.white, size: 20)
                    : null,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildTagsInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Tags', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: _tags.map((tag) {
            return Chip(
              label: Text(tag),
              onDeleted: () {
                setState(() {
                  _tags.remove(tag);
                });
              },
            );
          }).toList(),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _tagController,
          decoration: InputDecoration(
            labelText: 'Add tag',
            border: const OutlineInputBorder(),
            suffixIcon: IconButton(
              icon: const Icon(Icons.add),
              onPressed: _addTag,
            ),
          ),
          onFieldSubmitted: (_) => _addTag(),
        ),
      ],
    );
  }

  Widget _buildReminderSwitch() {
    return SwitchListTile(
      title: const Text('Set Reminder'),
      subtitle: const Text('Get notified before the due date'),
      value: _hasReminder,
      onChanged: (value) {
        setState(() {
          _hasReminder = value;
        });
      },
    );
  }

  Widget _buildSaveButton(DatabaseService databaseService, bool isEditing) {
    return ElevatedButton(
      onPressed: () => _saveTask(databaseService, isEditing),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Text(isEditing ? 'Update Task' : 'Create Task'),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (picked != null && picked != _dueDate && mounted) {
      setState(() {
        _dueDate = picked;
      });
    }
  }

  void _addTag() {
    final tag = _tagController.text.trim();
    if (tag.isNotEmpty && !_tags.contains(tag) && mounted) {
      setState(() {
        _tags.add(tag);
        _tagController.clear();
      });
    }
  }

  Future<void> _saveTask(
      DatabaseService databaseService, bool isEditing) async {
    if (_formKey.currentState!.validate()) {
      final task = Task(
        id: widget.task?.id,
        title: _titleController.text,
        description: _descriptionController.text,
        dueDate: _dueDate,
        priority: _priority,
        category: _category,
        colorCode: _colorCode,
        tags: _tags,
        hasReminder: _hasReminder,
        createdAt: widget.task?.createdAt ?? DateTime.now(),
        isCompleted: widget.task?.isCompleted ?? false,
        completedAt: widget.task?.completedAt,
        reminderId: widget.task?.reminderId ?? -1,
      );

      try {
        if (isEditing) {
          await databaseService.updateTask(task);
        } else {
          await databaseService.insertTask(task);
        }

        // Schedule notification if reminder is enabled
        if (_hasReminder) {
          final notificationService = NotificationService();
          await notificationService.scheduleNotification(
            id: task.id ?? DateTime.now().millisecondsSinceEpoch,
            title: 'Task Reminder: ${task.title}',
            body: 'Your task is due on ${Helpers.formatDate(task.dueDate)}',
            scheduledTime: task.dueDate.subtract(const Duration(hours: 1)),
          );
        }

        if (mounted) {
          widget.onSave();
          Navigator.pop(context);
        }
      } catch (error) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error saving task: ${error.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  Future<void> _confirmExit(BuildContext context) async {
    final shouldExit = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Discard Changes?'),
        content: const Text('Are you sure you want to discard your changes?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Discard'),
          ),
        ],
      ),
    );

    if (shouldExit == true && mounted) {
      Navigator.pop(context);
    }
  }
}

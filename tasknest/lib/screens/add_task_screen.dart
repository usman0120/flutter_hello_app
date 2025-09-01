// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasknest/models/task_model.dart';
import 'package:tasknest/services/database_service.dart';
import 'package:tasknest/services/notification_service.dart';
import 'package:tasknest/utils/constants.dart';
import 'package:tasknest/utils/helpers.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class AddTaskScreen extends StatefulWidget {
  final Task? task;

  const AddTaskScreen({super.key, this.task});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final NotificationService _notificationService = NotificationService();

  DateTime _dueDate = DateTime.now().add(const Duration(hours: 1));
  String _category = AppConstants.taskCategories.first;
  String _priority = AppConstants.priorities[1]; // Medium
  List<String> _selectedTags = [];
  String _colorCode = '#6C63FF';
  bool _hasReminder = false;
  DateTime? _reminderDate;
  bool _isRepeating = false;
  String _repeatFrequency = 'None';

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      _populateForm(widget.task!);
    }
  }

  void _populateForm(Task task) {
    _titleController.text = task.title;
    _descriptionController.text = task.description;
    _dueDate = task.dueDate;
    _category = task.category;
    _priority = task.priority;
    _selectedTags = List.from(task.tags);
    _colorCode = task.colorCode;
    _hasReminder = task.hasReminder;
    _reminderDate = task.reminderDate;
    _isRepeating = task.isRepeating;
    _repeatFrequency = task.repeatFrequency;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task == null ? 'Add Task' : 'Edit Task'),
        actions: [
          if (widget.task != null)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: _deleteTask,
            ),
        ],
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
              _buildDueDateField(),
              const SizedBox(height: 16),
              _buildCategoryField(),
              const SizedBox(height: 16),
              _buildPriorityField(),
              const SizedBox(height: 16),
              _buildTagsField(),
              const SizedBox(height: 16),
              _buildColorPicker(),
              const SizedBox(height: 16),
              _buildReminderToggle(),
              if (_hasReminder) ...[
                const SizedBox(height: 16),
                _buildReminderDateField(),
              ],
              const SizedBox(height: 16),
              _buildRepeatToggle(),
              if (_isRepeating) ...[
                const SizedBox(height: 16),
                _buildRepeatFrequencyField(),
              ],
              const SizedBox(height: 32),
              _buildSubmitButton(),
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
        labelText: 'Title *',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.title),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a title';
        }
        return null;
      },
    );
  }

  Widget _buildDescriptionField() {
    return TextFormField(
      controller: _descriptionController,
      decoration: const InputDecoration(
        labelText: 'Description',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.description),
      ),
      maxLines: 3,
    );
  }

  Widget _buildDueDateField() {
    return ListTile(
      leading: const Icon(Icons.calendar_today),
      title: const Text('Due Date'),
      subtitle: Text(Helpers.formatDate(_dueDate, includeTime: true)),
      trailing: const Icon(Icons.arrow_drop_down),
      onTap: () async {
        final DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: _dueDate,
          firstDate: DateTime.now(),
          lastDate: DateTime(2100),
        );
        if (pickedDate != null) {
          final TimeOfDay? pickedTime = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.fromDateTime(_dueDate),
          );
          if (pickedTime != null) {
            setState(() {
              _dueDate = DateTime(
                pickedDate.year,
                pickedDate.month,
                pickedDate.day,
                pickedTime.hour,
                pickedTime.minute,
              );
            });
          }
        }
      },
    );
  }

  Widget _buildCategoryField() {
    return DropdownButtonFormField<String>(
      initialValue: _category,
      decoration: const InputDecoration(
        labelText: 'Category',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.category),
      ),
      items: AppConstants.taskCategories
          .map((category) => DropdownMenuItem<String>(
                value: category,
                child: Text(category),
              ))
          .toList(),
      onChanged: (value) => setState(() => _category = value!),
    );
  }

  Widget _buildPriorityField() {
    return DropdownButtonFormField<String>(
      initialValue: _priority,
      decoration: const InputDecoration(
        labelText: 'Priority',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.priority_high),
      ),
      items: AppConstants.priorities
          .map((priority) => DropdownMenuItem<String>(
                value: priority,
                child: Row(
                  children: [
                    Icon(
                      Helpers.getPriorityIcon(priority),
                      color: Helpers.getPriorityColor(priority),
                    ),
                    const SizedBox(width: 8),
                    Text(priority),
                  ],
                ),
              ))
          .toList(),
      onChanged: (value) => setState(() => _priority = value!),
    );
  }

  Widget _buildTagsField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Tags'),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: AppConstants.defaultTags.map((tag) {
            final isSelected = _selectedTags.contains(tag);
            return FilterChip(
              label: Text(tag),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _selectedTags.add(tag);
                  } else {
                    _selectedTags.remove(tag);
                  }
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildColorPicker() {
    return ListTile(
      leading: const Icon(Icons.color_lens),
      title: const Text('Color'),
      trailing: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: Helpers.parseColor(_colorCode),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey),
        ),
      ),
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Pick a color'),
            content: SingleChildScrollView(
              child: ColorPicker(
                pickerColor: Helpers.parseColor(_colorCode),
                onColorChanged: (color) {
                  setState(() {
                    _colorCode =
                        // ignore: deprecated_member_use
                        '#${color.value.toRadixString(16).substring(2)}';
                  });
                },
                pickerAreaHeightPercent: 0.8,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildReminderToggle() {
    return SwitchListTile(
      title: const Text('Set Reminder'),
      value: _hasReminder,
      onChanged: (value) {
        setState(() {
          _hasReminder = value;
          if (value && _reminderDate == null) {
            _reminderDate = _dueDate.subtract(const Duration(minutes: 30));
          }
        });
      },
    );
  }

  Widget _buildReminderDateField() {
    return ListTile(
      leading: const Icon(Icons.notifications),
      title: const Text('Reminder Time'),
      subtitle: Text(_reminderDate != null
          ? Helpers.formatDate(_reminderDate!, includeTime: true)
          : 'Select reminder time'),
      trailing: const Icon(Icons.arrow_drop_down),
      onTap: () async {
        final DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: _reminderDate ?? _dueDate,
          firstDate: DateTime.now(),
          lastDate: _dueDate,
        );
        if (pickedDate != null) {
          final TimeOfDay? pickedTime = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.fromDateTime(_reminderDate ?? _dueDate),
          );
          if (pickedTime != null) {
            setState(() {
              _reminderDate = DateTime(
                pickedDate.year,
                pickedDate.month,
                pickedDate.day,
                pickedTime.hour,
                pickedTime.minute,
              );
            });
          }
        }
      },
    );
  }

  Widget _buildRepeatToggle() {
    return SwitchListTile(
      title: const Text('Repeat Task'),
      value: _isRepeating,
      onChanged: (value) {
        setState(() {
          _isRepeating = value;
          if (value && _repeatFrequency == 'None') {
            _repeatFrequency = 'Daily';
          }
        });
      },
    );
  }

  Widget _buildRepeatFrequencyField() {
    return DropdownButtonFormField<String>(
      initialValue: _repeatFrequency,
      decoration: const InputDecoration(
        labelText: 'Repeat Frequency',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.repeat),
      ),
      items: AppConstants.repeatFrequencies
          .where((freq) => freq != 'None')
          .map((freq) => DropdownMenuItem<String>(
                value: freq,
                child: Text(freq),
              ))
          .toList(),
      onChanged: (value) => setState(() => _repeatFrequency = value!),
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: _submitForm,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      child: Text(widget.task == null ? 'Create Task' : 'Update Task'),
    );
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final databaseService =
          Provider.of<DatabaseService>(context, listen: false);
      final now = DateTime.now();

      final task = Task(
        id: widget.task?.id,
        title: _titleController.text,
        description: _descriptionController.text,
        dueDate: _dueDate,
        category: _category,
        tags: _selectedTags,
        priority: _priority,
        colorCode: _colorCode,
        hasReminder: _hasReminder,
        reminderDate: _hasReminder ? _reminderDate : null,
        isRepeating: _isRepeating,
        repeatFrequency: _repeatFrequency,
        createdAt: widget.task?.createdAt ?? now,
        updatedAt: now,
      );

      try {
        if (widget.task == null) {
          final id = await databaseService.insertTask(task);
          task.id = id;
          if (_hasReminder) {
            await _notificationService.scheduleTaskReminder(task);
          }
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Task created successfully!')),
            );
          }
        } else {
          await databaseService.updateTask(task);
          if (_hasReminder) {
            await _notificationService.scheduleTaskReminder(task);
          } else {
            await _notificationService.cancelTaskReminder(task.id!);
          }
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Task updated successfully!')),
            );
          }
        }

        if (mounted) {
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${e.toString()}')),
          );
        }
      }
    }
  }

  Future<void> _deleteTask() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Task'),
        content: const Text('Are you sure you want to delete this task?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        final databaseService =
            Provider.of<DatabaseService>(context, listen: false);
        await databaseService.deleteTask(widget.task!.id!);
        await _notificationService.cancelTaskReminder(widget.task!.id!);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Task deleted successfully!')),
          );
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${e.toString()}')),
          );
        }
      }
    }
  }
}

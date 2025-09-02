import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasknest/models/habit_model.dart';
import 'package:tasknest/models/category_model.dart';
import 'package:tasknest/services/database_service.dart';
import 'package:tasknest/services/notification_service.dart';
import 'package:tasknest/utils/constants.dart';
import 'package:tasknest/utils/helpers.dart';
import 'package:tasknest/widgets/custom_appbar.dart';

class AddEditHabitScreen extends StatefulWidget {
  final Habit? habit;
  final VoidCallback onSave;

  const AddEditHabitScreen({
    super.key,
    this.habit,
    required this.onSave,
  });

  @override
  State<AddEditHabitScreen> createState() => _AddEditHabitScreenState();
}

class _AddEditHabitScreenState extends State<AddEditHabitScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late int _targetFrequency;
  late String _category;
  late String _colorCode;
  late bool _hasReminder;
  late TimeOfDay _reminderTime;

  @override
  void initState() {
    super.initState();
    final habit = widget.habit;
    _titleController = TextEditingController(text: habit?.title ?? '');
    _descriptionController =
        TextEditingController(text: habit?.description ?? '');
    _targetFrequency = habit?.targetFrequency ?? 3;
    _category = habit?.category ?? Categories.defaultCategories.first.name;
    _colorCode = habit?.colorCode ?? AppConstants.colorOptions.first;
    _hasReminder = habit?.hasReminder ?? false;
    _reminderTime =
        const TimeOfDay(hour: 9, minute: 0); // Default reminder time
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final databaseService = Provider.of<DatabaseService>(context);
    final isEditing = widget.habit != null;

    return Scaffold(
      appBar: CustomAppBar(
        title: isEditing ? 'Edit Habit' : 'Add New Habit',
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
              _buildFrequencySlider(),
              const SizedBox(height: 16),
              _buildCategoryDropdown(databaseService),
              const SizedBox(height: 16),
              _buildColorPicker(),
              const SizedBox(height: 16),
              _buildReminderSwitch(),
              if (_hasReminder) ...[
                const SizedBox(height: 16),
                _buildReminderTimePicker(),
              ],
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
        labelText: 'Habit Title',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.title),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a habit title';
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

  Widget _buildFrequencySlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Target Frequency: $_targetFrequency times per week',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Slider(
          value: _targetFrequency.toDouble(),
          min: 1,
          max: 7,
          divisions: 6,
          label: _targetFrequency.toString(),
          onChanged: (value) {
            setState(() {
              _targetFrequency = value.toInt();
            });
          },
        ),
        const Text(
          'How many times you want to complete this habit each week',
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildCategoryDropdown(DatabaseService databaseService) {
    return FutureBuilder<List<Category>>(
      future: databaseService.getAllCategories(),
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
            setState(() {
              _category = newValue!;
              // Set color to match category
              final selectedCategory = categories.firstWhere(
                (cat) => cat.name == newValue,
                orElse: () => Categories.defaultCategories.first,
              );
              _colorCode = selectedCategory.colorCode;
            });
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

  Widget _buildReminderSwitch() {
    return SwitchListTile(
      title: const Text('Daily Reminder'),
      subtitle: const Text('Get reminded to complete your habit'),
      value: _hasReminder,
      onChanged: (value) {
        setState(() {
          _hasReminder = value;
        });
      },
    );
  }

  Widget _buildReminderTimePicker() {
    return InkWell(
      onTap: () => _selectTime(context),
      child: InputDecorator(
        decoration: const InputDecoration(
          labelText: 'Reminder Time',
          border: OutlineInputBorder(),
          prefixIcon: Icon(Icons.access_time),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(_reminderTime.format(context)),
            const Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }

  Widget _buildSaveButton(DatabaseService databaseService, bool isEditing) {
    return ElevatedButton(
      onPressed: () => _saveHabit(databaseService, isEditing),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Text(isEditing ? 'Update Habit' : 'Create Habit'),
    );
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _reminderTime,
    );
    if (picked != null && picked != _reminderTime) {
      setState(() {
        _reminderTime = picked;
      });
    }
  }

  Future<void> _saveHabit(
      DatabaseService databaseService, bool isEditing) async {
    if (_formKey.currentState!.validate()) {
      final habit = Habit(
        id: widget.habit?.id,
        title: _titleController.text,
        description: _descriptionController.text,
        targetFrequency: _targetFrequency,
        category: _category,
        colorCode: _colorCode,
        hasReminder: _hasReminder,
        startDate: widget.habit?.startDate ?? DateTime.now(),
        completionDays: widget.habit?.completionDays ?? List.filled(7, false),
        currentStreak: widget.habit?.currentStreak ?? 0,
        completedCount: widget.habit?.completedCount ?? 0,
        lastCompleted: widget.habit?.lastCompleted,
        reminderId: widget.habit?.reminderId ?? -1,
      );

      if (isEditing) {
        await databaseService.updateHabit(habit);
      } else {
        await databaseService.insertHabit(habit);
      }

      // Schedule daily notification if reminder is enabled
      if (_hasReminder) {
        final notificationService = NotificationService();
        final now = DateTime.now();
        var scheduledTime = DateTime(
          now.year,
          now.month,
          now.day,
          _reminderTime.hour,
          _reminderTime.minute,
        );

        // If the time has already passed today, schedule for tomorrow
        if (scheduledTime.isBefore(now)) {
          scheduledTime = scheduledTime.add(const Duration(days: 1));
        }

        await notificationService.scheduleNotification(
          id: habit.id ?? DateTime.now().millisecondsSinceEpoch,
          title: 'Habit Reminder: ${habit.title}',
          body: 'Don\'t forget to complete your habit today!',
          scheduledTime: scheduledTime,
        );
      }

      widget.onSave();
      Navigator.pop(context);
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

    if (shouldExit == true) {
      Navigator.pop(context);
    }
  }
}

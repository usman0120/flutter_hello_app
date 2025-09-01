// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasknest/models/habit_model.dart';
import 'package:tasknest/services/database_service.dart';
import 'package:tasknest/services/notification_service.dart';
import 'package:tasknest/utils/constants.dart';
import 'package:tasknest/utils/helpers.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class AddHabitScreen extends StatefulWidget {
  final Habit? habit;

  const AddHabitScreen({super.key, this.habit});

  @override
  State<AddHabitScreen> createState() => _AddHabitScreenState();
}

class _AddHabitScreenState extends State<AddHabitScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final NotificationService _notificationService = NotificationService();

  int _targetFrequency = 7;
  String _category = AppConstants.habitCategories.first;
  String _colorCode = '#6C63FF';
  bool _hasReminder = false;
  TimeOfDay? _reminderTime;
  List<bool> _weeklyCompletion = List.filled(7, false);

  @override
  void initState() {
    super.initState();
    if (widget.habit != null) {
      _populateForm(widget.habit!);
    }
  }

  void _populateForm(Habit habit) {
    _titleController.text = habit.title;
    _descriptionController.text = habit.description;
    _targetFrequency = habit.targetFrequency;
    _category = habit.category;
    _colorCode = habit.colorCode;
    _hasReminder = habit.hasReminder;
    _reminderTime = habit.reminderTime;
    _weeklyCompletion = List.from(habit.weeklyCompletion);
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
        title: Text(widget.habit == null ? 'Add Habit' : 'Edit Habit'),
        actions: [
          if (widget.habit != null)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: _deleteHabit,
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
              _buildTargetFrequencyField(),
              const SizedBox(height: 16),
              _buildCategoryField(),
              const SizedBox(height: 16),
              _buildColorPicker(),
              const SizedBox(height: 16),
              _buildReminderToggle(),
              if (_hasReminder) ...[
                const SizedBox(height: 16),
                _buildReminderTimeField(),
              ],
              const SizedBox(height: 16),
              _buildWeeklySchedule(),
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
        labelText: 'Habit Title *',
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
        labelText: 'Description',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.description),
      ),
      maxLines: 3,
    );
  }

  Widget _buildTargetFrequencyField() {
    return DropdownButtonFormField<int>(
      initialValue: _targetFrequency,
      decoration: const InputDecoration(
        labelText: 'Target Frequency',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.repeat),
      ),
      items: [1, 3, 5, 7]
          .map((frequency) => DropdownMenuItem(
                value: frequency,
                child: Text('$frequency times per week'),
              ))
          .toList(),
      onChanged: (value) => setState(() => _targetFrequency = value!),
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
      items: AppConstants.habitCategories
          .map((category) => DropdownMenuItem(
                value: category,
                child: Text(category),
              ))
          .toList(),
      onChanged: (value) => setState(() => _category = value!),
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
      title: const Text('Set Daily Reminder'),
      value: _hasReminder,
      onChanged: (value) {
        setState(() {
          _hasReminder = value;
          if (value && _reminderTime == null) {
            _reminderTime = const TimeOfDay(hour: 9, minute: 0);
          }
        });
      },
    );
  }

  Widget _buildReminderTimeField() {
    return ListTile(
      leading: const Icon(Icons.notifications),
      title: const Text('Reminder Time'),
      subtitle: Text(_reminderTime != null
          ? Helpers.formatTimeOfDay(_reminderTime!)
          : 'Select reminder time'),
      trailing: const Icon(Icons.arrow_drop_down),
      onTap: () async {
        final TimeOfDay? pickedTime = await showTimePicker(
          context: context,
          initialTime: _reminderTime ?? const TimeOfDay(hour: 9, minute: 0),
        );
        if (pickedTime != null) {
          setState(() {
            _reminderTime = pickedTime;
          });
        }
      },
    );
  }

  Widget _buildWeeklySchedule() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Weekly Schedule',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          'Select the days you want to practice this habit:',
          style: TextStyle(color: Colors.grey[600]),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: 7,
          itemBuilder: (context, index) {
            final dayName = Helpers.getDayName(index);
            return GestureDetector(
              onTap: () {
                setState(() {
                  _weeklyCompletion[index] = !_weeklyCompletion[index];
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  color: _weeklyCompletion[index]
                      ? Theme.of(context).primaryColor
                      : Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      dayName,
                      style: TextStyle(
                        color: _weeklyCompletion[index]
                            ? Colors.white
                            : Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Icon(
                      _weeklyCompletion[index]
                          ? Icons.check_circle
                          : Icons.circle,
                      color:
                          _weeklyCompletion[index] ? Colors.white : Colors.grey,
                      size: 16,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: _submitForm,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      child: Text(widget.habit == null ? 'Create Habit' : 'Update Habit'),
    );
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final databaseService =
          Provider.of<DatabaseService>(context, listen: false);
      final now = DateTime.now();

      final habit = Habit(
        id: widget.habit?.id,
        title: _titleController.text,
        description: _descriptionController.text,
        targetFrequency: _targetFrequency,
        weeklyCompletion: _weeklyCompletion,
        category: _category,
        colorCode: _colorCode,
        hasReminder: _hasReminder,
        reminderTime: _hasReminder ? _reminderTime : null,
        startDate: widget.habit?.startDate ?? now,
        updatedAt: now,
        currentStreak: widget.habit?.currentStreak ?? 0,
        longestStreak: widget.habit?.longestStreak ?? 0,
        completedCount: widget.habit?.completedCount ?? 0,
      );

      try {
        if (widget.habit == null) {
          final id = await databaseService.insertHabit(habit);
          habit.id = id;
          if (_hasReminder) {
            await _notificationService.scheduleRepeatingHabitReminder(habit);
          }
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Habit created successfully!')),
          );
        } else {
          await databaseService.updateHabit(habit);
          if (_hasReminder) {
            await _notificationService.scheduleRepeatingHabitReminder(habit);
          } else {
            await _notificationService.cancelHabitReminder(habit.id!);
          }
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Habit updated successfully!')),
          );
        }

        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }

  Future<void> _deleteHabit() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Habit'),
        content: const Text('Are you sure you want to delete this habit?'),
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
        await databaseService.deleteHabit(widget.habit!.id!);
        await _notificationService.cancelHabitReminder(widget.habit!.id!);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Habit deleted successfully!')),
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }
}

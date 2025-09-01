import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasknest/models/habit_model.dart';
import 'package:tasknest/services/database_service.dart';
import 'package:tasknest/services/notification_service.dart';
import 'package:tasknest/utils/helpers.dart';

class HabitTile extends StatefulWidget {
  final Habit habit;

  const HabitTile({super.key, required this.habit});

  @override
  State<HabitTile> createState() => _HabitTileState();
}

class _HabitTileState extends State<HabitTile> {
  late Habit _habit;

  @override
  void initState() {
    super.initState();
    _habit = widget.habit;
  }

  @override
  Widget build(BuildContext context) {
    final isCompletedToday = _habit.isCompletedToday;
    final completionPercentage = _habit.weeklyCompletionPercentage;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => _showHabitDetails(context),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row
              Row(
                children: [
                  // Completion checkbox
                  Checkbox(
                    value: isCompletedToday,
                    onChanged: (value) =>
                        _toggleHabitCompletion(value ?? false),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Title and streak
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _habit.title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: isCompletedToday
                                ? Colors.grey
                                : Theme.of(context).colorScheme.onSurface,
                            decoration: isCompletedToday
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text(
                              '${_habit.currentStreak} day streak',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              Helpers.getStreakEmoji(_habit.currentStreak),
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Longest streak badge
                  if (_habit.longestStreak > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star,
                              size: 12, color: Colors.orange),
                          const SizedBox(width: 2),
                          Text(
                            '${_habit.longestStreak}',
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 12),

              // Progress bar
              LinearProgressIndicator(
                value: completionPercentage,
                backgroundColor: Colors.grey.shade200,
                color: Helpers.parseColor(_habit.colorCode),
                minHeight: 6,
                borderRadius: BorderRadius.circular(3),
              ),

              const SizedBox(height: 8),

              // Progress text and weekly completion
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${(_habit.completedCount)}/${_habit.targetFrequency} this week',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  Text(
                    '${(completionPercentage * 100).toInt()}% complete',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Weekly completion grid
              _buildWeeklyCompletionGrid(),

              const SizedBox(height: 8),

              // Reminder and category
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Category chip
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      gradient: Helpers.getCategoryGradient(_habit.category),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      _habit.category,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                  // Reminder indicator
                  if (_habit.hasReminder && _habit.reminderTime != null)
                    Row(
                      children: [
                        Icon(
                          Icons.notifications,
                          size: 14,
                          color: Theme.of(context).primaryColor,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          Helpers.formatTimeOfDay(_habit.reminderTime!),
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWeeklyCompletionGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
      ),
      itemCount: 7,
      itemBuilder: (context, index) {
        final isCompleted = _habit.weeklyCompletion[index];
        final isToday = index == DateTime.now().weekday - 1;

        return Container(
          decoration: BoxDecoration(
            color: isCompleted
                ? Helpers.parseColor(_habit.colorCode)
                : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(4),
            border: isToday ? Border.all(color: Colors.blue, width: 2) : null,
          ),
          child: Center(
            child: Text(
              Helpers.getDayName(index).substring(0, 1),
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: isCompleted ? Colors.white : Colors.grey,
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _toggleHabitCompletion(bool isCompleted) async {
    final databaseService =
        Provider.of<DatabaseService>(context, listen: false);

    try {
      final updatedHabit = _habit..markCompleted(isCompleted);
      await databaseService.updateHabit(updatedHabit);

      if (mounted) {
        setState(() {
          _habit = updatedHabit;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isCompleted
                  ? 'Habit completed for today!'
                  : 'Habit marked as incomplete',
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error updating habit'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showHabitDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return HabitDetailsBottomSheet(habit: _habit);
      },
    );
  }
}

class HabitDetailsBottomSheet extends StatefulWidget {
  final Habit habit;

  const HabitDetailsBottomSheet({super.key, required this.habit});

  @override
  State<HabitDetailsBottomSheet> createState() =>
      _HabitDetailsBottomSheetState();
}

class _HabitDetailsBottomSheetState extends State<HabitDetailsBottomSheet> {
  late Habit _habit;

  @override
  void initState() {
    super.initState();
    _habit = widget.habit;
  }

  @override
  Widget build(BuildContext context) {
    final completionRate = (_habit.completedCount /
            (_habit.targetFrequency *
                (_habit.startDate.difference(DateTime.now()).inDays / 7).abs()))
        .clamp(0.0, 1.0);

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
                'Habit Details',
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
            _habit.title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),

          // Description
          if (_habit.description.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _habit.description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),

          // Stats Grid
          GridView.count(
            shrinkWrap: true,
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 3,
            children: [
              _buildStatItem('Current Streak', '${_habit.currentStreak} days',
                  Icons.local_fire_department, Colors.orange),
              _buildStatItem('Longest Streak', '${_habit.longestStreak} days',
                  Icons.star, Colors.amber),
              _buildStatItem('Total Completions', '${_habit.completedCount}',
                  Icons.check_circle, Colors.green),
              _buildStatItem(
                  'Success Rate',
                  '${(completionRate * 100).toInt()}%',
                  Icons.trending_up,
                  Colors.blue),
            ],
          ),

          const SizedBox(height: 20),

          // Weekly Progress
          const Text(
            'This Week\'s Progress:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 12),

          // Weekly completion bars
          _buildWeeklyProgressBars(),

          const SizedBox(height: 20),

          // Additional Info
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildInfoItem('Category', _habit.category, Icons.category),
              _buildInfoItem(
                  'Frequency', '${_habit.targetFrequency}/week', Icons.repeat),
              if (_habit.hasReminder && _habit.reminderTime != null)
                _buildInfoItem(
                    'Reminder',
                    Helpers.formatTimeOfDay(_habit.reminderTime!),
                    Icons.notifications),
            ],
          ),

          const SizedBox(height: 24),

          // Action Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: () => _editHabit(),
                child: const Text('Edit Habit'),
              ),
              ElevatedButton(
                onPressed: () => _deleteHabit(),
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

  Widget _buildStatItem(
      String label, String value, IconData icon, Color color) {
    return Row(
      children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(width: 8),
        Column(
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
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildWeeklyProgressBars() {
    return Column(
      children: List.generate(7, (index) {
        final isCompleted = _habit.weeklyCompletion[index];
        final dayName = Helpers.getDayName(index);
        final isToday = index == DateTime.now().weekday - 1;

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              SizedBox(
                width: 40,
                child: Text(
                  dayName,
                  style: TextStyle(
                    fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                    color: isToday ? Colors.blue : Colors.grey,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: LinearProgressIndicator(
                  value: isCompleted ? 1.0 : 0.0,
                  backgroundColor: Colors.grey.shade200,
                  color: isCompleted
                      ? Helpers.parseColor(_habit.colorCode)
                      : Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                isCompleted ? Icons.check : Icons.close,
                size: 16,
                color: isCompleted ? Colors.green : Colors.grey,
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildInfoItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 16, color: Colors.grey),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 10, color: Colors.grey),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  void _editHabit() {
    Navigator.pop(context);
    // Navigate to edit habit screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Edit habit functionality coming soon')),
    );
  }

  void _deleteHabit() async {
    final databaseService =
        Provider.of<DatabaseService>(context, listen: false);
    final notificationService = NotificationService();

    try {
      await databaseService.deleteHabit(_habit.id!);
      if (_habit.hasReminder) {
        await notificationService.cancelHabitReminder(_habit.id!);
      }
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Habit deleted successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error deleting habit'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}

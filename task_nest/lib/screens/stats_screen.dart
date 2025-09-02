// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:tasknest/models/habit_model.dart';
import 'package:tasknest/services/database_service.dart';
import 'package:tasknest/utils/helpers.dart';
import 'package:tasknest/widgets/custom_appbar.dart';
import 'package:tasknest/widgets/progress_ring.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final databaseService = Provider.of<DatabaseService>(context);

    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Statistics',
        showBackButton: true,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _loadStatistics(databaseService),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          final stats = snapshot.data ?? {};
          final completedTasks = stats['completedTasks'] as int;
          final totalTasks = stats['totalTasks'] as int;
          final habits = stats['habits'] as List<Habit>;
          final tasksByDay = stats['tasksByDay'] as Map<String, int>;

          return RefreshIndicator(
            onRefresh: () async {
              setState(() {});
            },
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildOverviewSection(completedTasks, totalTasks, habits),
                const SizedBox(height: 24),
                _buildWeeklyChart(tasksByDay),
                const SizedBox(height: 24),
                _buildHabitsSection(habits),
                const SizedBox(height: 24),
                _buildProductivityInsights(completedTasks, totalTasks, habits),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildOverviewSection(
      int completedTasks, int totalTasks, List<Habit> habits) {
    final completionRate = totalTasks > 0 ? completedTasks / totalTasks : 0.0;
    final averageHabitCompletion = habits.isNotEmpty
        ? habits.map((h) => h.completionRate).reduce((a, b) => a + b) /
            habits.length
        : 0.0;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              'Overview',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatCircle(
                  value: completedTasks,
                  label: 'Completed',
                  color: Colors.green,
                ),
                _buildStatCircle(
                  value: totalTasks,
                  label: 'Total Tasks',
                  color: Colors.blue,
                ),
                _buildStatCircle(
                  value: habits.length,
                  label: 'Habits',
                  color: Colors.orange,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildProgressStat(
                  progress: completionRate,
                  label: 'Task Completion',
                  value: '${(completionRate * 100).toStringAsFixed(1)}%',
                ),
                _buildProgressStat(
                  progress: averageHabitCompletion,
                  label: 'Habit Consistency',
                  value:
                      '${(averageHabitCompletion * 100).toStringAsFixed(1)}%',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeeklyChart(Map<String, int> tasksByDay) {
    final weekDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final data = weekDays.map((day) => tasksByDay[day] ?? 0).toList();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Weekly Performance',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: data.isEmpty
                      ? 10
                      : data.reduce((a, b) => a > b ? a : b).toDouble() + 2,
                  barTouchData: BarTouchData(
                    enabled: false,
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(weekDays[value.toInt()]),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                      ),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  gridData: FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                  barGroups: data.asMap().entries.map((entry) {
                    final index = entry.key;
                    final value = entry.value;
                    return BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: value.toDouble(),
                          color: Theme.of(context).colorScheme.primary,
                          width: 16,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHabitsSection(List<Habit> habits) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Habit Streaks',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            if (habits.isEmpty)
              _buildEmptyHabitsState()
            else
              Column(
                children: habits.map((habit) {
                  return ListTile(
                    leading: ProgressRing(
                      progress: habit.completionRate,
                      radius: 20,
                      progressColor: Helpers.hexToColor(habit.colorCode),
                    ),
                    title: Text(habit.title),
                    subtitle: Text('${habit.currentStreak} day streak'),
                    trailing: Chip(
                      label: Text('${(habit.completionRate * 100).toInt()}%'),
                    ),
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductivityInsights(
      int completedTasks, int totalTasks, List<Habit> habits) {
    final completionRate = totalTasks > 0 ? completedTasks / totalTasks : 0.0;
    String insight = '';

    if (completionRate >= 0.8) {
      insight =
          '🔥 Amazing! You\'re completing most of your tasks. Keep up the great work!';
    } else if (completionRate >= 0.6) {
      insight = '👍 Good job! You\'re making solid progress on your tasks.';
    } else if (completionRate >= 0.4) {
      insight =
          '💪 You\'re getting there! Try to focus on completing a few more tasks each day.';
    } else {
      insight =
          '🌱 Every journey starts with a single step. Try setting smaller, achievable goals.';
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Productivity Insights',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            Text(
              insight,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            if (habits.isNotEmpty) ...[
              const Divider(),
              const SizedBox(height: 8),
              Text(
                'Habit Suggestions:',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              ..._generateHabitSuggestions(habits)
                  .take(3)
                  .map((suggestion) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.lightbulb_outline, size: 16),
                            const SizedBox(width: 8),
                            Expanded(child: Text(suggestion)),
                          ],
                        ),
                      )),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatCircle(
      {required int value, required String label, required Color color}) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: color,
          radius: 30,
          child: Text(
            value.toString(),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _buildProgressStat(
      {required double progress,
      required String label,
      required String value}) {
    return Column(
      children: [
        ProgressRing(
          progress: progress,
          radius: 25,
          progressColor: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }

  Widget _buildEmptyHabitsState() {
    return Center(
      child: Column(
        children: [
          Icon(
            Icons.repeat,
            size: 48,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
          ),
          const SizedBox(height: 8),
          Text(
            'No habits yet!\nStart building habits to track your consistency.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                ),
          ),
        ],
      ),
    );
  }

  Future<Map<String, dynamic>> _loadStatistics(
      DatabaseService databaseService) async {
    final completedTasks = await databaseService.getCompletedTasksCount();
    final totalTasks = await databaseService.getTotalTasksCount();
    final habits = await databaseService.getAllHabits();
    final tasksByDay = await databaseService.getTasksByDay();

    return {
      'completedTasks': completedTasks,
      'totalTasks': totalTasks,
      'habits': habits,
      'tasksByDay': tasksByDay,
    };
  }

  List<String> _generateHabitSuggestions(List<Habit> habits) {
    final suggestions = <String>[];

    for (final habit in habits) {
      if (habit.completionRate < 0.5) {
        suggestions.add('Try to be more consistent with "${habit.title}". '
            'Consider setting a daily reminder or reducing the frequency.');
      }

      if (habit.currentStreak >= 7) {
        suggestions.add('Great job maintaining your "${habit.title}" streak! '
            'You\'ve built a solid habit foundation.');
      }

      if (habit.category == 'Health' && habit.completionRate > 0.7) {
        suggestions.add('Your health habits are strong! '
            'Consider adding complementary habits like meditation or stretching.');
      }
    }

    if (suggestions.isEmpty) {
      suggestions.add('Your habits are well maintained! '
          'Consider adding new habits to continue your personal growth journey.');
    }

    return suggestions;
  }
}

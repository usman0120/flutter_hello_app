import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:tasknest/models/task_model.dart';
import 'package:tasknest/models/habit_model.dart';
import 'package:tasknest/services/database_service.dart';
import 'package:tasknest/utils/constants.dart';
import 'package:tasknest/utils/helpers.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  int _selectedTimeRange = 0; // 0: Weekly, 1: Monthly, 2: Yearly

  @override
  Widget build(BuildContext context) {
    final databaseService = Provider.of<DatabaseService>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Statistics'), centerTitle: true),
      body: FutureBuilder(
        future: Future.wait([
          databaseService.getAllTasks(),
          databaseService.getAllHabits(),
        ]),
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final tasks = snapshot.data![0] as List<Task>;
          final habits = snapshot.data![1] as List<Habit>;

          return RefreshIndicator(
            onRefresh: () async {
              setState(() {});
            },
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Time Range Selector
                  _buildTimeRangeSelector(),
                  const SizedBox(height: 24),

                  // Completion Rate
                  _buildCompletionRateCard(tasks),
                  const SizedBox(height: 24),

                  // Task Distribution
                  _buildTaskDistributionChart(tasks),
                  const SizedBox(height: 24),

                  // Weekly Summary
                  _buildWeeklySummary(tasks),
                  const SizedBox(height: 24),

                  // Habit Streaks
                  _buildHabitStreaks(habits),
                  const SizedBox(height: 24),

                  // Best Day Analysis
                  _buildBestDayAnalysis(tasks),
                  const SizedBox(height: 24),

                  // Productivity Insights
                  _buildProductivityInsights(tasks, habits),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTimeRangeSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildTimeRangeButton('Weekly', 0),
        _buildTimeRangeButton('Monthly', 1),
        _buildTimeRangeButton('Yearly', 2),
      ],
    );
  }

  Widget _buildTimeRangeButton(String label, int index) {
    return ElevatedButton(
      onPressed: () => setState(() => _selectedTimeRange = index),
      style: ElevatedButton.styleFrom(
        backgroundColor: _selectedTimeRange == index
            ? Theme.of(context).primaryColor
            : Colors.grey[300],
        foregroundColor:
            _selectedTimeRange == index ? Colors.white : Colors.black,
      ),
      child: Text(label),
    );
  }

  Widget _buildCompletionRateCard(List<Task> tasks) {
    final totalTasks = tasks.length;
    final completedTasks = tasks.where((task) => task.isCompleted).length;
    final completionRate = totalTasks > 0 ? completedTasks / totalTasks : 0.0;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              'Overall Completion Rate',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 120,
                  height: 120,
                  child: CircularProgressIndicator(
                    value: completionRate,
                    strokeWidth: 12,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                Text(
                  '${(completionRate * 100).toStringAsFixed(1)}%',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem('Total', totalTasks.toString(), Icons.task),
                _buildStatItem(
                  'Completed',
                  completedTasks.toString(),
                  Icons.check_circle,
                ),
                _buildStatItem(
                  'Pending',
                  (totalTasks - completedTasks).toString(),
                  Icons.pending,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Theme.of(context).primaryColor),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  Widget _buildTaskDistributionChart(List<Task> tasks) {
    final categoryCounts = <String, int>{};
    for (final task in tasks) {
      categoryCounts[task.category] = (categoryCounts[task.category] ?? 0) + 1;
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Task Distribution by Category',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sections: categoryCounts.entries.map((entry) {
                    final color =
                        AppConstants.categoryColors[entry.key] ?? Colors.grey;
                    return PieChartSectionData(
                      value: entry.value.toDouble(),
                      color: color,
                      title: '${entry.value}',
                      radius: 40,
                      titleStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    );
                  }).toList(),
                  centerSpaceRadius: 40,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: categoryCounts.entries.map((entry) {
                final color =
                    AppConstants.categoryColors[entry.key] ?? Colors.grey;
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(width: 12, height: 12, color: color),
                    const SizedBox(width: 4),
                    Text(
                      '${entry.key} (${entry.value})',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeeklySummary(List<Task> tasks) {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final weekTasks = tasks
        .where(
          (task) =>
              task.dueDate.isAfter(weekStart) &&
              task.dueDate.isBefore(now.add(const Duration(days: 1))),
        )
        .toList();

    final completedThisWeek =
        weekTasks.where((task) => task.isCompleted).length;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'This Week\'s Summary',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  'Created',
                  weekTasks.length.toString(),
                  Icons.add,
                ),
                _buildStatItem(
                  'Completed',
                  completedThisWeek.toString(),
                  Icons.check,
                ),
                _buildStatItem(
                  'Rate',
                  '${weekTasks.isNotEmpty ? ((completedThisWeek / weekTasks.length) * 100).toStringAsFixed(0) : '0'}%',
                  Icons.trending_up,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHabitStreaks(List<Habit> habits) {
    final activeHabits =
        habits.where((habit) => habit.currentStreak > 0).toList();
    final totalStreak = habits.fold(
      0,
      (sum, habit) => sum + habit.currentStreak,
    );
    final longestStreak = habits.isNotEmpty
        ? habits.map((h) => h.longestStreak).reduce((a, b) => a > b ? a : b)
        : 0;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Habit Streaks',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  'Active',
                  activeHabits.length.toString(),
                  Icons.auto_awesome,
                ),
                _buildStatItem(
                  'Total Streak',
                  totalStreak.toString(),
                  Icons.local_fire_department,
                ),
                _buildStatItem('Longest', longestStreak.toString(), Icons.star),
              ],
            ),
            const SizedBox(height: 16),
            if (activeHabits.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Top Habits:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ...activeHabits.take(3).map(
                        (habit) => ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Helpers.parseColor(
                              habit.colorCode,
                            ),
                            child: Text(
                              Helpers.getStreakEmoji(habit.currentStreak),
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                          title: Text(habit.title),
                          subtitle: Text('${habit.currentStreak} day streak'),
                          trailing: Text(
                            Helpers.getStreakEmoji(habit.currentStreak),
                          ),
                        ),
                      ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildBestDayAnalysis(List<Task> tasks) {
    final dayCounts = List.filled(7, 0); // 0 = Monday, 6 = Sunday

    for (final task in tasks.where((t) => t.isCompleted)) {
      final dayIndex = task.dueDate.weekday - 1;
      dayCounts[dayIndex]++;
    }

    final bestDayIndex = dayCounts.indexWhere(
      (count) => count == dayCounts.reduce((a, b) => a > b ? a : b),
    );
    final bestDayName = Helpers.getDayName(bestDayIndex);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Best Day Analysis',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 150,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY:
                      dayCounts.reduce((a, b) => a > b ? a : b).toDouble() + 1,
                  barGroups: dayCounts.asMap().entries.map((entry) {
                    return BarChartGroupData(
                      x: entry.key,
                      barRods: [
                        BarChartRodData(
                          toY: entry.value.toDouble(),
                          color: entry.key == bestDayIndex
                              ? Theme.of(context).primaryColor
                              : Colors.grey[300],
                          width: 16,
                        ),
                      ],
                    );
                  }).toList(),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              Helpers.getDayName(value.toInt()).substring(0, 1),
                              style: const TextStyle(fontSize: 10),
                            ),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                'Your most productive day is $bestDayName',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductivityInsights(List<Task> tasks, List<Habit> habits) {
    final completedTasks = tasks.where((task) => task.isCompleted).length;
    final totalHabitCompletions = habits.fold(
      0,
      (sum, habit) => sum + habit.completedCount,
    );
    const averageCompletionRate = 0.65; // Industry average

    final userCompletionRate =
        tasks.isNotEmpty ? completedTasks / tasks.length : 0.0;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Productivity Insights',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildInsightItem(
              Icons.emoji_events,
              'You\'ve completed $completedTasks tasks and $totalHabitCompletions habit repetitions!',
            ),
            const SizedBox(height: 12),
            _buildInsightItem(
              Icons.trending_up,
              userCompletionRate > averageCompletionRate
                  ? 'You\'re ${((userCompletionRate - averageCompletionRate) * 100).toStringAsFixed(0)}% more productive than average!'
                  : 'Keep going! You\'re almost at the average completion rate.',
            ),
            const SizedBox(height: 12),
            _buildInsightItem(
              Icons.lightbulb_outline,
              'Tip: ${AppConstants.appTips[DateTime.now().millisecond % AppConstants.appTips.length]}',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInsightItem(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Theme.of(context).primaryColor, size: 20),
        const SizedBox(width: 12),
        Expanded(child: Text(text, style: const TextStyle(fontSize: 14))),
      ],
    );
  }
}

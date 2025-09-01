import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasknest/models/task_model.dart';
import 'package:tasknest/models/habit_model.dart';
import 'package:tasknest/services/database_service.dart';
import 'package:tasknest/services/notification_service.dart';
import 'package:tasknest/widgets/task_card.dart';
import 'package:tasknest/widgets/habit_tile.dart';
import 'package:tasknest/widgets/progress_ring.dart';
import 'package:tasknest/utils/helpers.dart';
import 'package:tasknest/screens/add_task_screen.dart';
import 'package:tasknest/screens/add_habit_screen.dart';
import 'package:tasknest/screens/task_list_screen.dart';
import 'package:tasknest/screens/habit_list_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final NotificationService _notificationService = NotificationService();
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
  }

  Future<void> _initializeNotifications() async {
    await _notificationService.init();
    await _notificationService.requestPermissions();
  }

  @override
  Widget build(BuildContext context) {
    final databaseService = Provider.of<DatabaseService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'TaskNest',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () {
              Navigator.pushNamed(context, '/calendar');
            },
          ),
          IconButton(
            icon: const Icon(Icons.bar_chart),
            onPressed: () {
              Navigator.pushNamed(context, '/stats');
            },
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _buildDashboardTab(databaseService),
          _buildTasksTab(databaseService),
          _buildHabitsTab(databaseService),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.task),
            label: 'Tasks',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.auto_awesome),
            label: 'Habits',
          ),
        ],
      ),
      floatingActionButton: _currentIndex == 1
          ? FloatingActionButton(
              onPressed: () => _navigateToAddTask(context),
              child: const Icon(Icons.add),
            )
          : _currentIndex == 2
              ? FloatingActionButton(
                  onPressed: () => _navigateToAddHabit(context),
                  child: const Icon(Icons.add),
                )
              : null,
    );
  }

  Widget _buildDashboardTab(DatabaseService databaseService) {
    return FutureBuilder(
      future: Future.wait([
        databaseService.getTodaysTasks(),
        databaseService.getPendingTasks(),
        databaseService.getAllHabits(),
      ]),
      builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final todayTasks = snapshot.data![0] as List<Task>;
        final pendingTasks = snapshot.data![1] as List<Task>;
        final habits = snapshot.data![2] as List<Habit>;

        final completedToday =
            todayTasks.where((task) => task.isCompleted).length;
        final totalToday = todayTasks.length;
        final completionPercentage =
            totalToday > 0 ? completedToday / totalToday : 0.0;

        return RefreshIndicator(
          onRefresh: () async {
            setState(() {});
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Welcome Header
                _buildWelcomeHeader(),
                const SizedBox(height: 24),

                // Today's Progress
                _buildProgressSection(
                    completionPercentage, completedToday, totalToday),
                const SizedBox(height: 24),

                // Today's Tasks
                _buildTodayTasksSection(todayTasks),
                const SizedBox(height: 24),

                // Habits Streak
                _buildHabitsSection(habits),
                const SizedBox(height: 24),

                // Quick Stats
                _buildQuickStatsSection(pendingTasks, habits),
                const SizedBox(height: 24),

                // Motivational Quote
                _buildMotivationalQuote(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildWelcomeHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Good ${_getTimeOfDayGreeting()},',
          style: const TextStyle(
            fontSize: 18,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Let\'s make today productive!',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressSection(double percentage, int completed, int total) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              'Today\'s Progress',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(height: 16),
            ProgressRing(
              progress: percentage,
              size: 100,
              strokeWidth: 10,
              child: Center(
                child: Text(
                  '${(percentage * 100).toInt()}%',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '$completed of $total tasks completed',
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTodayTasksSection(List<Task> tasks) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Today\'s Tasks',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
            TextButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TaskListScreen(
                    title: 'Today\'s Tasks',
                    tasksFuture:
                        Provider.of<DatabaseService>(context).getTodaysTasks(),
                  ),
                ),
              ),
              child: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (tasks.isEmpty)
          _buildEmptyState('No tasks for today!', Icons.event_available)
        else
          Column(
            children:
                tasks.take(3).map((task) => TaskCard(task: task)).toList(),
          ),
      ],
    );
  }

  Widget _buildHabitsSection(List<Habit> habits) {
    final activeHabits =
        habits.where((habit) => habit.currentStreak > 0).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Habit Streaks',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
            TextButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HabitListScreen(
                    title: 'All Habits',
                    habitsFuture:
                        Provider.of<DatabaseService>(context).getAllHabits(),
                  ),
                ),
              ),
              child: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (habits.isEmpty)
          _buildEmptyState('No habits yet!', Icons.auto_awesome)
        else if (activeHabits.isEmpty)
          _buildEmptyState('Start building habits!', Icons.rocket_launch)
        else
          Column(
            children: activeHabits
                .take(3)
                .map((habit) => HabitTile(habit: habit))
                .toList(),
          ),
      ],
    );
  }

  Widget _buildQuickStatsSection(List<Task> pendingTasks, List<Habit> habits) {
    final overdueTasks =
        pendingTasks.where((task) => Helpers.isOverdue(task.dueDate)).length;
    final totalStreak =
        habits.fold(0, (sum, habit) => sum + habit.currentStreak);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatItem(Icons.pending_actions, 'Pending',
                pendingTasks.length.toString()),
            _buildStatItem(Icons.warning, 'Overdue', overdueTasks.toString()),
            _buildStatItem(Icons.local_fire_department, 'Total Streak',
                totalStreak.toString()),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, size: 24, color: Theme.of(context).primaryColor),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildMotivationalQuote() {
    final quotes = [
      "The secret of getting ahead is getting started.",
      "Don't count the days, make the days count.",
      "Productivity is never an accident. It is always the result of a commitment to excellence.",
      "Small daily improvements are the key to staggering long-term results.",
      "Your future is created by what you do today, not tomorrow."
    ];
    final randomQuote = quotes[DateTime.now().millisecond % quotes.length];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Icon(Icons.lightbulb_outline, size: 32, color: Colors.amber),
            const SizedBox(height: 12),
            Text(
              randomQuote,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(String message, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Icon(icon, size: 48, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTasksTab(DatabaseService databaseService) {
    return FutureBuilder<List<Task>>(
      future: databaseService.getPendingTasks(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final tasks = snapshot.data!;

        return RefreshIndicator(
          onRefresh: () async {
            setState(() {});
          },
          child: tasks.isEmpty
              ? _buildEmptyState(
                  'No tasks yet!\nTap + to create your first task.', Icons.task)
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: tasks.length,
                  itemBuilder: (context, index) => TaskCard(task: tasks[index]),
                ),
        );
      },
    );
  }

  Widget _buildHabitsTab(DatabaseService databaseService) {
    return FutureBuilder<List<Habit>>(
      future: databaseService.getAllHabits(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final habits = snapshot.data!;

        return RefreshIndicator(
          onRefresh: () async {
            setState(() {});
          },
          child: habits.isEmpty
              ? _buildEmptyState(
                  'No habits yet!\nTap + to create your first habit.',
                  Icons.auto_awesome)
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: habits.length,
                  itemBuilder: (context, index) =>
                      HabitTile(habit: habits[index]),
                ),
        );
      },
    );
  }

  String _getTimeOfDayGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'morning';
    if (hour < 17) return 'afternoon';
    return 'evening';
  }

  void _navigateToAddTask(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddTaskScreen()),
    ).then((_) => setState(() {}));
  }

  void _navigateToAddHabit(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddHabitScreen()),
    ).then((_) => setState(() {}));
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasknest/models/task_model.dart';
import 'package:tasknest/models/habit_model.dart';
import 'package:tasknest/models/category_model.dart';
import 'package:tasknest/services/database_service.dart';
import 'package:tasknest/utils/constants.dart';
import 'package:tasknest/utils/helpers.dart';
import 'package:tasknest/widgets/task_card.dart';
import 'package:tasknest/widgets/habit_tile.dart';
import 'package:tasknest/widgets/category_chip.dart';
import 'package:tasknest/widgets/custom_appbar.dart';
import 'package:tasknest/screens/add_edit_task_screen.dart';
import 'package:tasknest/screens/add_edit_habit_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedCategory = 'All';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final databaseService = Provider.of<DatabaseService>(context);

    return Scaffold(
      appBar: CustomAppBar(
        title: AppConstants.appName,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: TaskSearchDelegate(databaseService: databaseService),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () {
              Navigator.pushNamed(context, RouteNames.calendar);
            },
          ),
        ],
        showBackButton: false,
      ),
      body: Column(
        children: [
          _buildCategoryFilter(databaseService),
          _buildTabBar(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildTasksTab(databaseService),
                _buildHabitsTab(databaseService),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_tabController.index == 0) {
            _showAddTaskDialog(context);
          } else {
            _showAddHabitDialog(context);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildCategoryFilter(DatabaseService databaseService) {
    return FutureBuilder<List<Category>>(
      future: databaseService.getAllCategories(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const SizedBox.shrink();
        }

        final categories = snapshot.data ?? [];
        final allCategories = [
          Category(
              name: 'All',
              colorCode: '0xFF9E9E9E',
              icon: '📋',
              taskCount: 0,
              habitCount: 0),
          ...categories,
        ];

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.all(12),
          child: Row(
            children: allCategories.map((category) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: CategoryChip(
                  category: category,
                  isSelected: _selectedCategory == category.name,
                  onTap: () {
                    setState(() {
                      _selectedCategory = category.name;
                    });
                  },
                  showCounts: true,
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  Widget _buildTabBar() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Theme.of(context).colorScheme.primary,
        ),
        labelColor: Theme.of(context).colorScheme.onPrimary,
        unselectedLabelColor: Theme.of(context).colorScheme.onSurface,
        tabs: const [
          Tab(text: 'Tasks', icon: Icon(Icons.task)),
          Tab(text: 'Habits', icon: Icon(Icons.repeat)),
        ],
        onTap: (index) {
          setState(() {});
        },
      ),
    );
  }

  Widget _buildTasksTab(DatabaseService databaseService) {
    return FutureBuilder<List<Task>>(
      future: databaseService.getAllTasks(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }

        final tasks = snapshot.data ?? [];
        final filteredTasks = _selectedCategory == 'All'
            ? tasks
            : tasks
                .where((task) => task.category == _selectedCategory)
                .toList();

        final upcomingTasks =
            filteredTasks.where((task) => !task.isCompleted).toList();
        final completedTasks =
            filteredTasks.where((task) => task.isCompleted).toList();

        return RefreshIndicator(
          onRefresh: () async {
            setState(() {});
          },
          child: ListView(
            children: [
              if (upcomingTasks.isNotEmpty) ...[
                _buildSectionHeader('Upcoming Tasks (${upcomingTasks.length})'),
                ...upcomingTasks.map((task) => TaskCard(
                      task: task,
                      onTap: () => _showEditTaskDialog(context, task),
                      onComplete: () =>
                          _toggleTaskCompletion(databaseService, task),
                      onEdit: () => _showEditTaskDialog(context, task),
                      onDelete: () => _deleteTask(databaseService, task),
                    )),
              ],
              if (completedTasks.isNotEmpty) ...[
                _buildSectionHeader(
                    'Completed Tasks (${completedTasks.length})'),
                ...completedTasks.map((task) => TaskCard(
                      task: task,
                      onTap: () => _showEditTaskDialog(context, task),
                      onComplete: () =>
                          _toggleTaskCompletion(databaseService, task),
                      onEdit: () => _showEditTaskDialog(context, task),
                      onDelete: () => _deleteTask(databaseService, task),
                    )),
              ],
              if (filteredTasks.isEmpty)
                _buildEmptyState(
                  icon: Icons.task,
                  message: _selectedCategory == 'All'
                      ? 'No tasks yet!\nTap + to add your first task.'
                      : 'No tasks in this category.\nTry adding some tasks!',
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHabitsTab(DatabaseService databaseService) {
    return FutureBuilder<List<Habit>>(
      future: databaseService.getAllHabits(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }

        final habits = snapshot.data ?? [];
        final filteredHabits = _selectedCategory == 'All'
            ? habits
            : habits
                .where((habit) => habit.category == _selectedCategory)
                .toList();

        return RefreshIndicator(
          onRefresh: () async {
            setState(() {});
          },
          child: ListView(
            children: [
              if (filteredHabits.isNotEmpty) ...[
                _buildSectionHeader('Your Habits (${filteredHabits.length})'),
                ...filteredHabits.map((habit) => HabitTile(
                      habit: habit,
                      onTap: () => _showEditHabitDialog(context, habit),
                      onComplete: () =>
                          _completeHabitToday(databaseService, habit),
                      onEdit: () => _showEditHabitDialog(context, habit),
                      onDelete: () => _deleteHabit(databaseService, habit),
                    )),
              ],
              if (filteredHabits.isEmpty)
                _buildEmptyState(
                  icon: Icons.repeat,
                  message: _selectedCategory == 'All'
                      ? 'No habits yet!\nTap + to add your first habit.'
                      : 'No habits in this category.\nTry adding some habits!',
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
      ),
    );
  }

  Widget _buildEmptyState({required IconData icon, required String message}) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon,
                size: 64,
                color:
                    Theme.of(context).colorScheme.onSurface.withOpacity(0.3)),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.5),
                  ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddTaskDialog(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditTaskScreen(
          onSave: () => setState(() {}),
        ),
      ),
    );
  }

  void _showEditTaskDialog(BuildContext context, Task task) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditTaskScreen(
          task: task,
          onSave: () => setState(() {}),
        ),
      ),
    );
  }

  void _showAddHabitDialog(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditHabitScreen(
          onSave: () => setState(() {}),
        ),
      ),
    );
  }

  void _showEditHabitDialog(BuildContext context, Habit habit) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditHabitScreen(
          habit: habit,
          onSave: () => setState(() {}),
        ),
      ),
    );
  }

  Future<void> _toggleTaskCompletion(
      DatabaseService databaseService, Task task) async {
    final updatedTask = task.copyWith(
      isCompleted: !task.isCompleted,
      completedAt: !task.isCompleted ? DateTime.now() : null,
    );
    await databaseService.updateTask(updatedTask);
    setState(() {});
  }

  Future<void> _completeHabitToday(
      DatabaseService databaseService, Habit habit) async {
    final now = DateTime.now();
    final today = now.weekday - 1; // 0-indexed (Monday = 0)

    if (!habit.completionDays[today]) {
      final updatedCompletionDays = List<bool>.from(habit.completionDays);
      updatedCompletionDays[today] = true;

      final updatedHabit = habit.copyWith(
        completionDays: updatedCompletionDays,
        completedCount: habit.completedCount + 1,
        lastCompleted: now,
        currentStreak: _calculateNewStreak(habit, today),
      );

      await databaseService.updateHabit(updatedHabit);
      setState(() {});

      Helpers.showSnackBar(context, 'Habit completed today! 🔥');
    } else {
      Helpers.showSnackBar(context, 'Habit already completed today!',
          isError: true);
    }
  }

  int _calculateNewStreak(Habit habit, int today) {
    // Simple streak calculation - you might want to implement a more robust solution
    return habit.currentStreak + 1;
  }

  Future<void> _deleteTask(DatabaseService databaseService, Task task) async {
    await Helpers.showConfirmationDialog(
      context,
      title: 'Delete Task',
      content: 'Are you sure you want to delete "${task.title}"?',
      onConfirm: () async {
        await databaseService.deleteTask(task.id!);
        setState(() {});
        Helpers.showSnackBar(context, 'Task deleted successfully');
      },
    );
  }

  Future<void> _deleteHabit(
      DatabaseService databaseService, Habit habit) async {
    await Helpers.showConfirmationDialog(
      context,
      title: 'Delete Habit',
      content: 'Are you sure you want to delete "${habit.title}"?',
      onConfirm: () async {
        await databaseService.deleteHabit(habit.id!);
        setState(() {});
        Helpers.showSnackBar(context, 'Habit deleted successfully');
      },
    );
  }
}

class TaskSearchDelegate extends SearchDelegate {
  final DatabaseService databaseService;

  TaskSearchDelegate({required this.databaseService});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults();
  }

  Widget _buildSearchResults() {
    return FutureBuilder<List<Task>>(
      future: databaseService.getAllTasks(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }

        final tasks = snapshot.data ?? [];
        final results = tasks
            .where((task) =>
                task.title.toLowerCase().contains(query.toLowerCase()) ||
                task.description.toLowerCase().contains(query.toLowerCase()) ||
                task.category.toLowerCase().contains(query.toLowerCase()) ||
                task.tags.any(
                    (tag) => tag.toLowerCase().contains(query.toLowerCase())))
            .toList();

        return ListView.builder(
          itemCount: results.length,
          itemBuilder: (context, index) {
            final task = results[index];
            return TaskCard(
              task: task,
              onTap: () {
                close(context, null);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddEditTaskScreen(
                      task: task,
                      onSave: () {},
                    ),
                  ),
                );
              },
              onComplete: () {},
              onEdit: () {},
              onDelete: () {},
            );
          },
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasknest/models/habit_model.dart';
import 'package:tasknest/services/database_service.dart';
import 'package:tasknest/utils/constants.dart';
import 'package:tasknest/widgets/habit_tile.dart';
import 'package:tasknest/screens/add_habit_screen.dart';

class HabitListScreen extends StatefulWidget {
  final String title;
  final Future<List<Habit>> habitsFuture;
  final String? filterCategory;

  const HabitListScreen({
    super.key,
    required this.title,
    required this.habitsFuture,
    this.filterCategory,
  });

  @override
  State<HabitListScreen> createState() => _HabitListScreenState();
}

class _HabitListScreenState extends State<HabitListScreen> {
  late Future<List<Habit>> _habitsFuture;
  List<Habit> _habits = [];
  List<Habit> _filteredHabits = [];
  String _searchQuery = '';
  String _selectedCategory = 'All';
  String _selectedSort = 'Streak';

  @override
  void initState() {
    super.initState();
    _habitsFuture = widget.habitsFuture;
    if (widget.filterCategory != null) {
      _selectedCategory = widget.filterCategory!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: _showSearchDialog,
          ),
        ],
      ),
      body: FutureBuilder<List<Habit>>(
        future: _habitsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          _habits = snapshot.data!;
          _filteredHabits = _applyFilters(_habits);

          if (_filteredHabits.isEmpty) {
            return _buildEmptyState();
          }

          return RefreshIndicator(
            onRefresh: _refreshHabits,
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _filteredHabits.length,
              itemBuilder: (context, index) =>
                  HabitTile(habit: _filteredHabits[index]),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddHabit,
        child: const Icon(Icons.add),
      ),
    );
  }

  List<Habit> _applyFilters(List<Habit> habits) {
    List<Habit> filtered = List.from(habits);

    // Apply category filter
    if (_selectedCategory != 'All') {
      filtered = filtered
          .where((habit) => habit.category == _selectedCategory)
          .toList();
    }

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filtered = filtered
          .where((habit) =>
              habit.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              habit.description
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()))
          .toList();
    }

    // Apply sorting
    filtered = _sortHabits(filtered);

    return filtered;
  }

  List<Habit> _sortHabits(List<Habit> habits) {
    switch (_selectedSort) {
      case 'Streak':
        habits.sort((a, b) => b.currentStreak.compareTo(a.currentStreak));
        break;
      case 'Title':
        habits.sort((a, b) => a.title.compareTo(b.title));
        break;
      case 'Category':
        habits.sort((a, b) => a.category.compareTo(b.category));
        break;
      case 'Completion Rate':
        habits.sort((a, b) => b.weeklyCompletionPercentage
            .compareTo(a.weeklyCompletionPercentage));
        break;
    }
    return habits;
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.auto_awesome,
            size: 64,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 16),
          Text(
            _getEmptyStateMessage(),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _navigateToAddHabit,
            child: const Text('Create Your First Habit'),
          ),
        ],
      ),
    );
  }

  String _getEmptyStateMessage() {
    if (_selectedCategory != 'All') {
      return 'No habits in $_selectedCategory category!\nCreate a habit in this category to get started.';
    } else if (_searchQuery.isNotEmpty) {
      return 'No habits found for "$_searchQuery"\nTry a different search term.';
    }
    return 'No habits yet!\nStart building good habits today.';
  }

  Future<void> _refreshHabits() async {
    setState(() {
      _habitsFuture =
          Provider.of<DatabaseService>(context, listen: false).getAllHabits();
    });
  }

  void _navigateToAddHabit() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddHabitScreen()),
    ).then((_) => _refreshHabits());
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Filter & Sort Habits'),
              content: SizedBox(
                width: double.maxFinite,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Category Filter
                    _buildFilterDropdown(
                      label: 'Category',
                      value: _selectedCategory,
                      items: ['All', ...AppConstants.habitCategories],
                      onChanged: (value) =>
                          setState(() => _selectedCategory = value!),
                    ),

                    // Sort Option
                    _buildFilterDropdown(
                      label: 'Sort by',
                      value: _selectedSort,
                      items: ['Streak', 'Title', 'Category', 'Completion Rate'],
                      onChanged: (value) =>
                          setState(() => _selectedSort = value!),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    setState(() {});
                  },
                  child: const Text('Apply'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildFilterDropdown({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          DropdownButtonFormField<String>(
            initialValue: value,
            items: items.map((item) {
              return DropdownMenuItem(
                value: item,
                child: Text(item),
              );
            }).toList(),
            onChanged: onChanged,
            isExpanded: true,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
          ),
        ],
      ),
    );
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Search Habits'),
          content: TextField(
            decoration: const InputDecoration(
              hintText: 'Search by title or description...',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  _searchQuery = '';
                });
                Navigator.pop(context);
              },
              child: const Text('Clear'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}

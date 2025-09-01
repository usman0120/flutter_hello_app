import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasknest/models/task_model.dart';
import 'package:tasknest/services/database_service.dart';
import 'package:tasknest/utils/constants.dart';
import 'package:tasknest/widgets/task_card.dart';
import 'package:tasknest/screens/add_task_screen.dart';

class TaskListScreen extends StatefulWidget {
  final String title;
  final Future<List<Task>> tasksFuture;
  final String? filterCategory;
  final bool? filterCompleted;

  const TaskListScreen({
    super.key,
    required this.title,
    required this.tasksFuture,
    this.filterCategory,
    this.filterCompleted,
  });

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  late Future<List<Task>> _tasksFuture;
  List<Task> _tasks = [];
  List<Task> _filteredTasks = [];
  String _searchQuery = '';
  String _selectedCategory = 'All';
  String _selectedPriority = 'All';
  String _selectedSort = 'Due Date';

  @override
  void initState() {
    super.initState();
    _tasksFuture = widget.tasksFuture;
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
      body: FutureBuilder<List<Task>>(
        future: _tasksFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          _tasks = snapshot.data!;
          _filteredTasks = _applyFilters(_tasks);

          if (_filteredTasks.isEmpty) {
            return _buildEmptyState();
          }

          return RefreshIndicator(
            onRefresh: _refreshTasks,
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _filteredTasks.length,
              itemBuilder: (context, index) =>
                  TaskCard(task: _filteredTasks[index]),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddTask,
        child: const Icon(Icons.add),
      ),
    );
  }

  List<Task> _applyFilters(List<Task> tasks) {
    List<Task> filtered = List.from(tasks);

    // Apply category filter
    if (_selectedCategory != 'All') {
      filtered =
          filtered.where((task) => task.category == _selectedCategory).toList();
    }

    // Apply priority filter
    if (_selectedPriority != 'All') {
      filtered =
          filtered.where((task) => task.priority == _selectedPriority).toList();
    }

    // Apply completed filter if specified
    if (widget.filterCompleted != null) {
      filtered = filtered
          .where((task) => task.isCompleted == widget.filterCompleted)
          .toList();
    }

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filtered = filtered
          .where((task) =>
              task.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              task.description
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()) ||
              task.tags.any((tag) =>
                  tag.toLowerCase().contains(_searchQuery.toLowerCase())))
          .toList();
    }

    // Apply sorting
    filtered = _sortTasks(filtered);

    return filtered;
  }

  List<Task> _sortTasks(List<Task> tasks) {
    switch (_selectedSort) {
      case 'Due Date':
        tasks.sort((a, b) => a.dueDate.compareTo(b.dueDate));
        break;
      case 'Priority':
        final priorityOrder = {'High': 0, 'Medium': 1, 'Low': 2};
        tasks.sort((a, b) =>
            priorityOrder[a.priority]!.compareTo(priorityOrder[b.priority]!));
        break;
      case 'Title':
        tasks.sort((a, b) => a.title.compareTo(b.title));
        break;
      case 'Category':
        tasks.sort((a, b) => a.category.compareTo(b.category));
        break;
    }
    return tasks;
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.task,
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
          if (widget.filterCompleted == null)
            ElevatedButton(
              onPressed: _navigateToAddTask,
              child: const Text('Create Your First Task'),
            ),
        ],
      ),
    );
  }

  String _getEmptyStateMessage() {
    if (widget.filterCompleted == true) {
      return 'No completed tasks yet!\nComplete some tasks to see them here.';
    } else if (_selectedCategory != 'All') {
      return 'No tasks in $_selectedCategory category!\nCreate a task in this category to get started.';
    } else if (_searchQuery.isNotEmpty) {
      return 'No tasks found for "$_searchQuery"\nTry a different search term.';
    } else if (_selectedPriority != 'All') {
      return 'No ${_selectedPriority.toLowerCase()} priority tasks!\nCreate a task with this priority level.';
    }
    return 'No tasks yet!\nCreate your first task to get started.';
  }

  Future<void> _refreshTasks() async {
    setState(() {
      _tasksFuture =
          Provider.of<DatabaseService>(context, listen: false).getAllTasks();
    });
  }

  void _navigateToAddTask() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddTaskScreen()),
    ).then((_) => _refreshTasks());
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Filter & Sort Tasks'),
              content: SizedBox(
                width: double.maxFinite,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Category Filter
                    _buildFilterDropdown(
                      label: 'Category',
                      value: _selectedCategory,
                      items: ['All', ...AppConstants.taskCategories],
                      onChanged: (value) =>
                          setState(() => _selectedCategory = value!),
                    ),

                    // Priority Filter
                    _buildFilterDropdown(
                      label: 'Priority',
                      value: _selectedPriority,
                      items: ['All', ...AppConstants.priorities],
                      onChanged: (value) =>
                          setState(() => _selectedPriority = value!),
                    ),

                    // Sort Option
                    _buildFilterDropdown(
                      label: 'Sort by',
                      value: _selectedSort,
                      items: ['Due Date', 'Priority', 'Title', 'Category'],
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
          title: const Text('Search Tasks'),
          content: TextField(
            decoration: const InputDecoration(
              hintText: 'Search by title, description, or tags...',
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

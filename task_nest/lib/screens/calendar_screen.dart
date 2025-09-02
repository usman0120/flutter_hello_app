import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tasknest/models/task_model.dart';
import 'package:tasknest/screens/add_edit_task_screen.dart';
import 'package:tasknest/services/database_service.dart';
import 'package:tasknest/utils/helpers.dart';
import 'package:tasknest/widgets/custom_appbar.dart';
import 'package:tasknest/widgets/task_card.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late DateTime _focusedDay;
  late DateTime _selectedDay;
  late CalendarFormat _calendarFormat;
  late Map<DateTime, List<Task>> _tasksByDate;

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
    _selectedDay = DateTime.now();
    _calendarFormat = CalendarFormat.month;
    _tasksByDate = {};
  }

  @override
  Widget build(BuildContext context) {
    final databaseService = Provider.of<DatabaseService>(context);

    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Calendar',
        showBackButton: true,
      ),
      body: FutureBuilder<List<Task>>(
        future: databaseService.getAllTasks(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          final tasks = snapshot.data ?? [];
          _updateTasksByDate(tasks);

          return Column(
            children: [
              _buildCalendar(tasks),
              const SizedBox(height: 16),
              _buildTaskListForSelectedDay(databaseService),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCalendar(List<Task> tasks) {
    return Card(
      margin: const EdgeInsets.all(12),
      child: TableCalendar(
        firstDay: DateTime.utc(2020, 1, 1),
        lastDay: DateTime.utc(2030, 12, 31),
        focusedDay: _focusedDay,
        selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
          });
        },
        onPageChanged: (focusedDay) {
          _focusedDay = focusedDay;
        },
        calendarFormat: _calendarFormat,
        onFormatChanged: (format) {
          setState(() {
            _calendarFormat = format;
          });
        },
        eventLoader: (day) => _tasksByDate[day] ?? [],
        calendarStyle: CalendarStyle(
          selectedDecoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            shape: BoxShape.circle,
          ),
          todayDecoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
            shape: BoxShape.circle,
          ),
          markerDecoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            shape: BoxShape.circle,
          ),
          markerSize: 6,
        ),
        headerStyle: const HeaderStyle(
          formatButtonVisible: true,
          titleCentered: true,
          formatButtonShowsNext: false,
        ),
        availableCalendarFormats: const {
          CalendarFormat.month: 'Month',
          CalendarFormat.twoWeeks: '2 Weeks',
          CalendarFormat.week: 'Week',
        },
      ),
    );
  }

  Widget _buildTaskListForSelectedDay(DatabaseService databaseService) {
    final tasks = _tasksByDate[_selectedDay] ?? [];
    final formattedDate = Helpers.formatDate(_selectedDay);

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Tasks on $formattedDate (${tasks.length})',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: tasks.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      final task = tasks[index];
                      return TaskCard(
                        task: task,
                        onTap: () =>
                            _showEditTaskDialog(context, task, databaseService),
                        onComplete: () =>
                            _toggleTaskCompletion(databaseService, task),
                        onEdit: () =>
                            _showEditTaskDialog(context, task, databaseService),
                        onDelete: () => _deleteTask(databaseService, task),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.event_note,
            size: 64,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'No tasks scheduled for ${Helpers.formatDate(_selectedDay)}',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                ),
          ),
        ],
      ),
    );
  }

  void _updateTasksByDate(List<Task> tasks) {
    _tasksByDate.clear();
    for (final task in tasks) {
      final taskDate =
          DateTime(task.dueDate.year, task.dueDate.month, task.dueDate.day);
      if (_tasksByDate.containsKey(taskDate)) {
        _tasksByDate[taskDate]!.add(task);
      } else {
        _tasksByDate[taskDate] = [task];
      }
    }
  }

  void _showEditTaskDialog(
      BuildContext context, Task task, DatabaseService databaseService) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditTaskScreen(
          task: task,
          onSave: () {
            setState(() {});
          },
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
}

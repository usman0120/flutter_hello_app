// import 'package:flutter/material.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         // This is the theme of your application.
//         //
//         // TRY THIS: Try running your application with "flutter run". You'll see
//         // the application has a purple toolbar. Then, without quitting the app,
//         // try changing the seedColor in the colorScheme below to Colors.green
//         // and then invoke "hot reload" (save your changes or press the "hot
//         // reload" button in a Flutter-supported IDE, or press "r" if you used
//         // the command line to start the app).
//         //
//         // Notice that the counter didn't reset back to zero; the application
//         // state is not lost during the reload. To reset the state, use hot
//         // restart instead.
//         //
//         // This works for code too, not just values: Most code changes can be
//         // tested with just a hot reload.
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//       ),
//       home: const MyHomePage(title: 'Flutter Demo Home Page'),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});

//   // This widget is the home page of your application. It is stateful, meaning
//   // that it has a State object (defined below) that contains fields that affect
//   // how it looks.

//   // This class is the configuration for the state. It holds the values (in this
//   // case the title) provided by the parent (in this case the App widget) and
//   // used by the build method of the State. Fields in a Widget subclass are
//   // always marked "final".

//   final String title;

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   int _counter = 0;

//   void _incrementCounter() {
//     setState(() {
//       // This call to setState tells the Flutter framework that something has
//       // changed in this State, which causes it to rerun the build method below
//       // so that the display can reflect the updated values. If we changed
//       // _counter without calling setState(), then the build method would not be
//       // called again, and so nothing would appear to happen.
//       _counter++;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     // This method is rerun every time setState is called, for instance as done
//     // by the _incrementCounter method above.
//     //
//     // The Flutter framework has been optimized to make rerunning build methods
//     // fast, so that you can just rebuild anything that needs updating rather
//     // than having to individually change instances of widgets.
//     return Scaffold(
//       appBar: AppBar(
//         // TRY THIS: Try changing the color here to a specific color (to
//         // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
//         // change color while the other colors stay the same.
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//         // Here we take the value from the MyHomePage object that was created by
//         // the App.build method, and use it to set our appbar title.
//         title: Text(widget.title),
//       ),
//       body: Center(
//         // Center is a layout widget. It takes a single child and positions it
//         // in the middle of the parent.
//         child: Column(
//           // Column is also a layout widget. It takes a list of children and
//           // arranges them vertically. By default, it sizes itself to fit its
//           // children horizontally, and tries to be as tall as its parent.
//           //
//           // Column has various properties to control how it sizes itself and
//           // how it positions its children. Here we use mainAxisAlignment to
//           // center the children vertically; the main axis here is the vertical
//           // axis because Columns are vertical (the cross axis would be
//           // horizontal).
//           //
//           // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
//           // action in the IDE, or press "p" in the console), to see the
//           // wireframe for each widget.
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             const Text('You have pushed the button this many times:'),
//             Text(
//               '$_counter',
//               style: Theme.of(context).textTheme.headlineMedium,
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _incrementCounter,
//         tooltip: 'Increment',
//         child: const Icon(Icons.add),
//       ), // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }
// }

<<<<<<< HEAD





=======
// ignore_for_file: deprecated_member_use
>>>>>>> 19e7e30 (upadates on tasknest)

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Productive Pro',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6C63FF),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        fontFamily: 'Inter',
      ),
      darkTheme: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6C63FF),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      themeMode: ThemeMode.system,
      home: const TodoHomePage(title: 'Productive Pro'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class TodoItem {
  String id;
  String title;
  String description;
  bool isCompleted;
  DateTime createdDate;
  DateTime? dueDate;
  Priority priority;
  String category;
  List<String> tags;
  DateTime? reminderDate;
  bool isStarred;

  TodoItem({
    required this.id,
    required this.title,
    required this.description,
    this.isCompleted = false,
    required this.createdDate,
    this.dueDate,
    this.priority = Priority.medium,
    this.category = 'Personal',
    this.tags = const [],
    this.reminderDate,
    this.isStarred = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isCompleted': isCompleted,
      'createdDate': createdDate.toIso8601String(),
      'dueDate': dueDate?.toIso8601String(),
      'priority': priority.index,
      'category': category,
      'tags': tags,
      'reminderDate': reminderDate?.toIso8601String(),
      'isStarred': isStarred,
    };
  }

  factory TodoItem.fromMap(Map<String, dynamic> map) {
    return TodoItem(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      isCompleted: map['isCompleted'],
      createdDate: DateTime.parse(map['createdDate']),
      dueDate: map['dueDate'] != null ? DateTime.parse(map['dueDate']) : null,
      priority: Priority.values[map['priority']],
      category: map['category'],
      tags: List<String>.from(map['tags'] ?? []),
      reminderDate: map['reminderDate'] != null ? DateTime.parse(map['reminderDate']) : null,
      isStarred: map['isStarred'] ?? false,
    );
  }

  bool get isOverdue => dueDate != null && !isCompleted && dueDate!.isBefore(DateTime.now());
  bool get hasReminder => reminderDate != null;
}

enum Priority { low, medium, high }

class TodoHomePage extends StatefulWidget {
  const TodoHomePage({super.key, required this.title});

  final String title;

  @override
  State<TodoHomePage> createState() => _TodoHomePageState();
}

class _TodoHomePageState extends State<TodoHomePage> with SingleTickerProviderStateMixin {
  List<TodoItem> _todoItems = [];
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _tagController = TextEditingController();
  DateTime? _selectedDueDate;
  DateTime? _selectedReminderDate;
  Priority _selectedPriority = Priority.medium;
  bool _isLoading = true;
  late TabController _tabController;
  String _searchQuery = '';
  bool _showCompleted = true;

  final List<String> categories = [
    'Personal',
    'Work',
    'Shopping',
    'Health',
    'Education',
    'Finance',
    'Home',
    'Other'
  ];

  final List<String> popularTags = [
    'urgent',
    'important',
    'meeting',
    'shopping',
    'bill',
    'exercise',
    'study'
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadTodoItems();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
    _tagController.dispose();
    super.dispose();
  }

  Future<void> _loadTodoItems() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? todoItemsString = prefs.getString('todoItems');
      
      if (todoItemsString != null) {
        final List<dynamic> jsonList = json.decode(todoItemsString);
        setState(() {
          _todoItems = jsonList.map((json) => TodoItem.fromMap(json)).toList();
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showErrorSnackbar('Failed to load tasks: $e');
    }
  }

  Future<void> _saveTodoItems() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<Map<String, dynamic>> jsonList =
          _todoItems.map((item) => item.toMap()).toList();
      await prefs.setString('todoItems', json.encode(jsonList));
    } catch (e) {
      _showErrorSnackbar('Failed to save tasks: $e');
    }
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showSuccessSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _addTodoItem() {
    _clearForm();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
<<<<<<< HEAD
        return _buildTaskForm(context, null);
      },
    );
  }

  void _clearForm() {
    _titleController.clear();
    _descriptionController.clear();
    _categoryController.clear();
    _tagController.clear();
    _selectedDueDate = null;
    _selectedReminderDate = null;
    _selectedPriority = Priority.medium;
  }

  Widget _buildTaskForm(BuildContext context, TodoItem? existingItem) {
    final bool isEditing = existingItem != null;
    
    if (isEditing) {
      _titleController.text = existingItem.title;
      _descriptionController.text = existingItem.description;
      _categoryController.text = existingItem.category;
      _tagController.text = existingItem.tags.join(', ');
      _selectedDueDate = existingItem.dueDate;
      _selectedReminderDate = existingItem.reminderDate;
      _selectedPriority = existingItem.priority;
    }

    return SingleChildScrollView(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isEditing ? 'Edit Task' : 'Add New Task',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title *',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.title),
              ),
              maxLines: 1,
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.description),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 15),
            DropdownButtonFormField<Priority>(
              value: _selectedPriority,
              items: Priority.values.map((Priority priority) {
                return DropdownMenuItem<Priority>(
                  value: priority,
                  child: Row(
                    children: [
                      Icon(
                        Icons.flag,
                        color: _getPriorityColor(priority),
                      ),
                      const SizedBox(width: 8),
                      Text(
=======
        return SingleChildScrollView(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Add New Task',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description (optional)',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 15),
                DropdownButtonFormField<Priority>(
                  initialValue: _selectedPriority,
                  items: Priority.values.map((Priority priority) {
                    return DropdownMenuItem<Priority>(
                      value: priority,
                      child: Text(
>>>>>>> 19e7e30 (upadates on tasknest)
                        priority.toString().split('.').last.toUpperCase(),
                        style: TextStyle(
                          color: _getPriorityColor(priority),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (Priority? newValue) {
                setState(() {
                  _selectedPriority = newValue!;
                });
              },
              decoration: const InputDecoration(
                labelText: 'Priority',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.priority_high),
              ),
            ),
            const SizedBox(height: 15),
            DropdownButtonFormField<String>(
              value: _categoryController.text.isEmpty
                  ? categories[0]
                  : _categoryController.text,
              items: categories.map((String category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _categoryController.text = newValue!;
                });
              },
              decoration: const InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.category),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _tagController,
              decoration: InputDecoration(
                labelText: 'Tags (comma separated)',
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.tag),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.arrow_drop_down),
                  onPressed: _showTagSuggestions,
                ),
              ),
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  child: TextButton.icon(
                    onPressed: () async {
                      final DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: _selectedDueDate ?? DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100),
                      );
                      if (pickedDate != null) {
                        setState(() {
                          _selectedDueDate = pickedDate;
                        });
                      }
                    },
                    icon: const Icon(Icons.calendar_today),
                    label: Text(
                      _selectedDueDate == null
                          ? 'Set Due Date'
                          : 'Due: ${DateFormat('MMM dd, yyyy').format(_selectedDueDate!)}',
                    ),
                  ),
                ),
<<<<<<< HEAD
                if (_selectedDueDate != null)
                  IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      setState(() {
                        _selectedDueDate = null;
                      });
                    },
                  ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextButton.icon(
                    onPressed: () async {
                      final DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: _selectedReminderDate ?? DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100),
                      );
                      if (pickedDate != null) {
                        setState(() {
                          _selectedReminderDate = pickedDate;
                        });
                      }
                    },
                    icon: const Icon(Icons.notifications),
                    label: Text(
                      _selectedReminderDate == null
                          ? 'Set Reminder'
                          : 'Remind: ${DateFormat('MMM dd, yyyy').format(_selectedReminderDate!)}',
                    ),
=======
                const SizedBox(height: 15),
                DropdownButtonFormField<String>(
                  initialValue: _categoryController.text.isEmpty
                      ? categories[0]
                      : _categoryController.text,
                  items: categories.map((String category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _categoryController.text = newValue!;
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(),
>>>>>>> 19e7e30 (upadates on tasknest)
                  ),
                ),
                if (_selectedReminderDate != null)
                  IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      setState(() {
                        _selectedReminderDate = null;
                      });
                    },
                  ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _clearForm();
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[300],
                    foregroundColor: Colors.black,
                  ),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_titleController.text.trim().isEmpty) {
                      _showErrorSnackbar('Please enter a title for your task');
                      return;
                    }
                    
                    final List<String> tags = _tagController.text
                        .split(',')
                        .map((tag) => tag.trim())
                        .where((tag) => tag.isNotEmpty)
                        .toList();

                    final newItem = TodoItem(
                      id: isEditing ? existingItem.id : DateTime.now().millisecondsSinceEpoch.toString(),
                      title: _titleController.text.trim(),
                      description: _descriptionController.text.trim(),
                      createdDate: isEditing ? existingItem.createdDate : DateTime.now(),
                      dueDate: _selectedDueDate,
                      priority: _selectedPriority,
                      category: _categoryController.text.isEmpty
                          ? categories[0]
                          : _categoryController.text,
                      tags: tags,
                      reminderDate: _selectedReminderDate,
                      isStarred: isEditing ? existingItem.isStarred : false,
                    );
                    
                    if (isEditing) {
                      final index = _todoItems.indexWhere((item) => item.id == existingItem.id);
                      if (index != -1) {
                        setState(() {
                          _todoItems[index] = newItem;
                          _saveTodoItems();
                        });
                        _showSuccessSnackbar('Task updated successfully!');
                      }
                    } else {
                      setState(() {
                        _todoItems.add(newItem);
                        _saveTodoItems();
                      });
                      _showSuccessSnackbar('Task added successfully!');
                    }
                    
                    _clearForm();
                    Navigator.pop(context);
                  },
                  child: Text(isEditing ? 'Update Task' : 'Add Task'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showTagSuggestions() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Popular Tags',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                children: popularTags.map((tag) {
                  return FilterChip(
                    label: Text(tag),
                    onSelected: (selected) {
                      setState(() {
                        final currentTags = _tagController.text.split(',').map((t) => t.trim()).toList();
                        if (selected && !currentTags.contains(tag)) {
                          currentTags.add(tag);
                          _tagController.text = currentTags.join(', ');
                        }
                        Navigator.pop(context);
                      });
                    },
                  );
                }).toList(),
              ),
            ],
          ),
        );
      },
    );
  }

  void _toggleTodoCompletion(int index) {
    setState(() {
      _todoItems[index].isCompleted = !_todoItems[index].isCompleted;
      _saveTodoItems();
    });
    
    final message = _todoItems[index].isCompleted 
        ? 'Task completed! 🎉' 
        : 'Task marked as pending';
    _showSuccessSnackbar(message);
  }

  void _toggleStar(int index) {
    setState(() {
      _todoItems[index].isStarred = !_todoItems[index].isStarred;
      _saveTodoItems();
    });
    
    final message = _todoItems[index].isStarred 
        ? 'Task starred' 
        : 'Task unstarred';
    _showSuccessSnackbar(message);
  }

  void _editTodoItem(int index) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
<<<<<<< HEAD
        return _buildTaskForm(context, _todoItems[index]);
=======
        return SingleChildScrollView(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Edit Task',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description (optional)',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 15),
                DropdownButtonFormField<Priority>(
                  initialValue: _selectedPriority,
                  items: Priority.values.map((Priority priority) {
                    return DropdownMenuItem<Priority>(
                      value: priority,
                      child: Text(
                        priority.toString().split('.').last.toUpperCase(),
                        style: TextStyle(
                          color: _getPriorityColor(priority),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (Priority? newValue) {
                    setState(() {
                      _selectedPriority = newValue!;
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: 'Priority',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 15),
                DropdownButtonFormField<String>(
                  initialValue: _categoryController.text.isEmpty
                      ? categories[0]
                      : _categoryController.text,
                  items: categories.map((String category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _categoryController.text = newValue!;
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                      child: TextButton.icon(
                        onPressed: () async {
                          final DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: _selectedDueDate ?? DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2100),
                          );
                          if (pickedDate != null) {
                            setState(() {
                              _selectedDueDate = pickedDate;
                            });
                          }
                        },
                        icon: const Icon(Icons.calendar_today),
                        label: Text(
                          _selectedDueDate == null
                              ? 'Set Due Date'
                              : 'Due: ${_selectedDueDate!.toString().split(' ')[0]}',
                        ),
                      ),
                    ),
                    if (_selectedDueDate != null)
                      IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            _selectedDueDate = null;
                          });
                        },
                      ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (_titleController.text.isNotEmpty) {
                          setState(() {
                            _todoItems[index] = TodoItem(
                              id: item.id,
                              title: _titleController.text,
                              description: _descriptionController.text,
                              isCompleted: item.isCompleted,
                              createdDate: item.createdDate,
                              dueDate: _selectedDueDate,
                              priority: _selectedPriority,
                              category: _categoryController.text.isEmpty
                                  ? categories[0]
                                  : _categoryController.text,
                            );
                            _saveTodoItems();
                          });

                          _titleController.clear();
                          _descriptionController.clear();
                          _categoryController.clear();
                          _selectedDueDate = null;
                          _selectedPriority = Priority.medium;

                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Task updated successfully!'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        }
                      },
                      child: const Text('Update Task'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
>>>>>>> 19e7e30 (upadates on tasknest)
      },
    );
  }

  void _deleteTodoItem(int index) {
    final deletedItem = _todoItems[index];
    
    setState(() {
      _todoItems.removeAt(index);
      _saveTodoItems();
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Task deleted'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _todoItems.insert(index, deletedItem);
              _saveTodoItems();
            });
          },
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Color _getPriorityColor(Priority priority) {
    switch (priority) {
      case Priority.high:
        return Colors.red;
      case Priority.medium:
        return Colors.orange;
      case Priority.low:
        return Colors.green;
    }
  }

  IconData _getPriorityIcon(Priority priority) {
    switch (priority) {
      case Priority.high:
        return Icons.keyboard_double_arrow_up;
      case Priority.medium:
        return Icons.keyboard_arrow_up;
      case Priority.low:
        return Icons.keyboard_double_arrow_down;
    }
  }

  List<TodoItem> _getFilteredTasks() {
    List<TodoItem> filtered = _todoItems;

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((item) =>
          item.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.description.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.tags.any((tag) => tag.toLowerCase().contains(_searchQuery.toLowerCase())) ||
          item.category.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
    }

    // Apply tab filter
    switch (_tabController.index) {
      case 0: // All
        break;
      case 1: // Active
        filtered = filtered.where((item) => !item.isCompleted).toList();
        break;
      case 2: // Completed
        filtered = filtered.where((item) => item.isCompleted).toList();
        break;
    }

    // Sort: starred first, then by priority, then by due date
    filtered.sort((a, b) {
      if (a.isStarred != b.isStarred) {
        return a.isStarred ? -1 : 1;
      }
      if (a.priority.index != b.priority.index) {
        return b.priority.index.compareTo(a.priority.index);
      }
      if (a.dueDate != null && b.dueDate != null) {
        return a.dueDate!.compareTo(b.dueDate!);
      }
      if (a.dueDate != null) return -1;
      if (b.dueDate != null) return 1;
      return a.createdDate.compareTo(b.createdDate);
    });

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final filteredTasks = _getFilteredTasks();
    final pendingCount = _todoItems.where((item) => !item.isCompleted).length;
    final completedCount = _todoItems.length - pendingCount;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: TodoSearchDelegate(_todoItems, _editTodoItem, _toggleTodoCompletion, _deleteTodoItem),
              );
            },
          ),
          if (_todoItems.isNotEmpty)
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'clear_completed') {
                  _clearCompletedTasks();
                } else if (value == 'export') {
                  _exportTasks();
                } else if (value == 'toggle_completed') {
                  setState(() {
                    _showCompleted = !_showCompleted;
                  });
                }
              },
              itemBuilder: (BuildContext context) {
                return [
                  PopupMenuItem(
                    value: 'toggle_completed',
                    child: Row(
                      children: [
                        Icon(_showCompleted ? Icons.visibility_off : Icons.visibility),
                        const SizedBox(width: 8),
                        Text(_showCompleted ? 'Hide Completed' : 'Show Completed'),
                      ],
                    ),
                  ),
                  if (completedCount > 0)
                    PopupMenuItem(
                      value: 'clear_completed',
                      child: Row(
                        children: [
                          const Icon(Icons.delete_sweep),
                          const SizedBox(width: 8),
                          Text('Clear Completed ($completedCount)'),
                        ],
                      ),
                    ),
                  const PopupMenuItem(
                    value: 'export',
                    child: Row(
                      children: [
                        Icon(Icons.import_export),
                        SizedBox(width: 8),
                        Text('Export Tasks'),
                      ],
                    ),
                  ),
                ];
              },
            ),
        ],
        bottom: _todoItems.isNotEmpty
            ? TabBar(
                controller: _tabController,
                onTap: (index) {
                  setState(() {});
                },
                tabs: const [
                  Tab(text: 'All'),
                  Tab(text: 'Active'),
                  Tab(text: 'Completed'),
                ],
              )
            : null,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _todoItems.isEmpty
              ? _buildEmptyState()
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${filteredTasks.length} task${filteredTasks.length != 1 ? 's' : ''}',
                            style: TextStyle(
                              fontSize: 16,
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Chip(
                            label: Text('$pendingCount pending'),
                            backgroundColor: pendingCount > 0 
                                ? Colors.orange.withAlpha(51) // Replaced withOpacity(0.2)
                                : Colors.green.withAlpha(51), // Replaced withOpacity(0.2)
                            side: BorderSide.none,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: filteredTasks.length,
                        itemBuilder: (context, index) {
                          final item = filteredTasks[index];
                          return _buildTodoItem(item, index);
                        },
                      ),
                    ),
                  ],
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTodoItem,
        tooltip: 'Add New Task',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.checklist_rounded,
            size: 80,
            color: Theme.of(context).colorScheme.primary.withAlpha(128), // Replaced withOpacity(0.5)
          ),
          const SizedBox(height: 20),
          Text(
            'No tasks yet!',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Add a new task to get started\nand organize your day better.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: _addTodoItem,
            icon: const Icon(Icons.add),
            label: const Text('Create Your First Task'),
          ),
        ],
      ),
    );
  }

  Widget _buildTodoItem(TodoItem item, int index) {
    final actualIndex = _todoItems.indexWhere((element) => element.id == item.id);
    
    return Slidable(
      key: Key(item.id),
      startActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) => _toggleStar(actualIndex),
            backgroundColor: Colors.amber,
            foregroundColor: Colors.white,
            icon: item.isStarred ? Icons.star_outline : Icons.star,
            label: item.isStarred ? 'Unstar' : 'Star',
          ),
          SlidableAction(
            onPressed: (context) => _editTodoItem(actualIndex),
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            icon: Icons.edit,
            label: 'Edit',
          ),
        ],
      ),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) => _toggleTodoCompletion(actualIndex),
            backgroundColor: item.isCompleted ? Colors.orange : Colors.green,
            foregroundColor: Colors.white,
            icon: item.isCompleted ? Icons.refresh : Icons.check,
            label: item.isCompleted ? 'Reopen' : 'Complete',
          ),
          SlidableAction(
            onPressed: (context) => _deleteTodoItem(actualIndex),
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),
      child: Card(
<<<<<<< HEAD
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        color: item.isCompleted
            ? Theme.of(context).colorScheme.surfaceContainerHighest
=======
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        color: isCompleted
            ? Theme.of(
                context,
              ).colorScheme.surfaceContainerHighest.withOpacity(0.5)
>>>>>>> 19e7e30 (upadates on tasknest)
            : null,
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: item.isOverdue 
                ? Colors.red.withAlpha(77) // Replaced withOpacity(0.3)
                : Colors.transparent,
            width: item.isOverdue ? 1.5 : 0,
          ),
        ),
        child: ListTile(
          leading: Checkbox(
            value: item.isCompleted,
            onChanged: (bool? value) {
              _toggleTodoCompletion(actualIndex);
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          title: Row(
            children: [
              if (item.isStarred)
                const Icon(Icons.star, color: Colors.amber, size: 16),
              if (item.isStarred) const SizedBox(width: 4),
              Expanded(
                child: Text(
                  item.title,
                  style: TextStyle(
                    decoration: item.isCompleted ? TextDecoration.lineThrough : null,
                    fontWeight: FontWeight.w600,
                    color: item.isCompleted 
                        ? Theme.of(context).colorScheme.onSurface.withAlpha(128) // Replaced withOpacity(0.5)
                        : Theme.of(context).colorScheme.onSurface,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (item.description.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    item.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      decoration: item.isCompleted ? TextDecoration.lineThrough : null,
                      color: Theme.of(context).colorScheme.onSurface.withAlpha(179), // Replaced withOpacity(0.7)
                    ),
                  ),
                ),
              const SizedBox(height: 6),
              Wrap(
                spacing: 6,
                runSpacing: 4,
                children: [
                  Chip(
                    label: Text(
                      item.priority.toString().split('.').last.toUpperCase(),
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: _getPriorityColor(item.priority),
                      ),
                    ),
                    backgroundColor: _getPriorityColor(item.priority).withAlpha(26), // Replaced withOpacity(0.1)
                    side: BorderSide.none,
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    visualDensity: VisualDensity.compact,
                  ),
                  Chip(
                    label: Text(
                      item.category,
                      style: const TextStyle(fontSize: 11),
                    ),
                    backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest, // Replaced surfaceVariant
                    side: BorderSide.none,
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    visualDensity: VisualDensity.compact,
                  ),
                  if (item.dueDate != null)
                    Chip(
                      label: Text(
                        DateFormat('MMM dd').format(item.dueDate!),
                        style: TextStyle(
                          fontSize: 11,
                          color: item.isOverdue ? Colors.red : null,
                        ),
                      ),
                      avatar: Icon(
                        Icons.calendar_today,
                        size: 14,
                        color: item.isOverdue ? Colors.red : null,
                      ),
                      backgroundColor: item.isOverdue 
                          ? Colors.red.withAlpha(26) // Replaced withOpacity(0.1)
                          : Theme.of(context).colorScheme.surfaceContainerHighest, // Replaced surfaceVariant
                      side: BorderSide.none,
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      visualDensity: VisualDensity.compact,
                    ),
                  if (item.hasReminder)
                    Chip(
                      label: const Text(
                        'Reminder',
                        style: TextStyle(fontSize: 11),
                      ),
                      avatar: const Icon(Icons.notifications, size: 14),
                      backgroundColor: Colors.blue.withAlpha(26), // Replaced withOpacity(0.1)
                      side: BorderSide.none,
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      visualDensity: VisualDensity.compact,
                    ),
                  ...item.tags.map((tag) => Chip(
                    label: Text(
                      tag,
                      style: const TextStyle(fontSize: 11),
                    ),
                    backgroundColor: Colors.purple.withAlpha(26), // Replaced withOpacity(0.1)
                    side: BorderSide.none,
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    visualDensity: VisualDensity.compact,
                  )), // Removed unnecessary toList()
                ],
              ),
            ],
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Icon(
                _getPriorityIcon(item.priority),
                color: _getPriorityColor(item.priority),
                size: 16,
              ),
              Text(
                DateFormat('MMM dd').format(item.createdDate),
                style: TextStyle(
                  fontSize: 10,
                  color: Theme.of(context).colorScheme.onSurface.withAlpha(128), // Replaced withOpacity(0.5)
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _clearCompletedTasks() {
    final completedCount = _todoItems.where((item) => item.isCompleted).length;
    
    if (completedCount == 0) {
      _showErrorSnackbar('No completed tasks to clear');
      return;
    }
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Clear Completed Tasks'),
          content: Text('Are you sure you want to delete $completedCount completed task${completedCount != 1 ? 's' : ''}?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _todoItems.removeWhere((item) => item.isCompleted);
                  _saveTodoItems();
                });
                Navigator.pop(context);
                _showSuccessSnackbar('Cleared $completedCount completed task${completedCount != 1 ? 's' : ''}');
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void _exportTasks() {
    // Simple export functionality - in a real app, you might export to CSV or share
    final pending = _todoItems.where((item) => !item.isCompleted).length;
    final completed = _todoItems.length - pending;
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Export Summary'),
          content: Text('You have $pending pending tasks and $completed completed tasks.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}

class TodoSearchDelegate extends SearchDelegate {
  final List<TodoItem> todoItems;
  final Function(int) onEdit;
  final Function(int) onToggle;
  final Function(int) onDelete;

  TodoSearchDelegate(this.todoItems, this.onEdit, this.onToggle, this.onDelete);

  @override
  List<Widget>? buildActions(BuildContext context) {
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
  Widget? buildLeading(BuildContext context) {
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
    final results = todoItems.where((item) =>
        item.title.toLowerCase().contains(query.toLowerCase()) ||
        item.description.toLowerCase().contains(query.toLowerCase()) ||
        item.tags.any((tag) => tag.toLowerCase().contains(query.toLowerCase())) ||
        item.category.toLowerCase().contains(query.toLowerCase())).toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final item = results[index];
        final actualIndex = todoItems.indexWhere((element) => element.id == item.id);
        
        return ListTile(
          leading: Checkbox(
            value: item.isCompleted,
            onChanged: (value) => onToggle(actualIndex),
          ),
          title: Text(item.title),
          subtitle: Text(item.description.isNotEmpty ? item.description : 'No description'),
          trailing: IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => onEdit(actualIndex),
          ),
          onTap: () => onEdit(actualIndex),
        );
      },
    );
  }
}
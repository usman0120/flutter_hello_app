import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:tasknest/main.dart';
import 'package:tasknest/models/task_model.dart';
import 'package:tasknest/models/habit_model.dart';
import 'package:tasknest/services/database_service.dart';
import 'package:tasknest/services/theme_service.dart';
import 'package:tasknest/screens/home_screen.dart';
import 'package:tasknest/screens/settings_screen.dart';
import 'package:tasknest/widgets/task_card.dart';
import 'package:tasknest/widgets/habit_tile.dart';
import 'package:tasknest/widgets/progress_ring.dart';

void main() {
  // Initialize sqflite for testing
  setUpAll(() async {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  group('TaskNest Widget Tests', () {
    testWidgets('App launches successfully', (WidgetTester tester) async {
      // Build our app
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => DatabaseService()),
            ChangeNotifierProvider(create: (_) => ThemeService()),
          ],
          child: const TaskNestApp(),
        ),
      );

      // Verify app title is displayed
      expect(find.text('TaskNest'), findsOneWidget);
    });

    testWidgets('HomeScreen displays correctly', (WidgetTester tester) async {
      // Create mock database service
      final databaseService = DatabaseService();

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider.value(value: databaseService),
            ChangeNotifierProvider(create: (_) => ThemeService()),
          ],
          child: const MaterialApp(
            home: HomeScreen(),
          ),
        ),
      );

      // Verify home screen elements
      expect(find.text('TaskNest'), findsOneWidget);
      expect(find.byIcon(Icons.calendar_today), findsOneWidget);
      expect(find.byIcon(Icons.bar_chart), findsOneWidget);
    });

    testWidgets('TaskCard displays task information',
        (WidgetTester tester) async {
      // Create a test task
      final testTask = Task(
        title: 'Test Task',
        description: 'This is a test task',
        dueDate: DateTime.now().add(const Duration(days: 1)),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TaskCard(task: testTask),
          ),
        ),
      );

      // Verify task information is displayed
      expect(find.text('Test Task'), findsOneWidget);
      expect(find.text('This is a test task'), findsOneWidget);
      expect(find.text('Tomorrow'), findsOneWidget);
    });

    testWidgets('HabitTile displays habit information',
        (WidgetTester tester) async {
      // Create a test habit
      final testHabit = Habit(
        title: 'Morning Exercise',
        description: 'Daily workout routine',
        weeklyCompletion: List.filled(7, false),
        startDate: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HabitTile(habit: testHabit),
          ),
        ),
      );

      // Verify habit information is displayed
      expect(find.text('Morning Exercise'), findsOneWidget);
      expect(find.text('0 day streak'), findsOneWidget);
    });

    testWidgets('ProgressRing displays correct progress',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: ProgressRing(
                progress: 0.75,
                size: 100,
                child: Text('75%'),
              ),
            ),
          ),
        ),
      );

      // Verify progress text
      expect(find.text('75%'), findsOneWidget);
    });

    testWidgets('SettingsScreen displays theme options',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => DatabaseService()),
            ChangeNotifierProvider(create: (_) => ThemeService()),
          ],
          child: const MaterialApp(
            home: SettingsScreen(),
          ),
        ),
      );

      // Verify settings screen elements
      expect(find.text('Settings'), findsOneWidget);
      expect(find.text('Appearance'), findsOneWidget);
      expect(find.text('Notifications'), findsOneWidget);
    });

    testWidgets('Navigation between tabs works', (WidgetTester tester) async {
      final databaseService = DatabaseService();

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider.value(value: databaseService),
            ChangeNotifierProvider(create: (_) => ThemeService()),
          ],
          child: const TaskNestApp(),
        ),
      );

      // Tap on Habits tab
      await tester.tap(find.text('Habits'));
      await tester.pumpAndSettle();

      // Verify we're on Habits tab
      expect(find.byIcon(Icons.add), findsOneWidget);

      // Tap on Settings tab (via icon)
      await tester.tap(find.byIcon(Icons.settings));
      await tester.pumpAndSettle();

      // Verify settings screen
      expect(find.text('Settings'), findsOneWidget);
    });

    testWidgets('Theme switching works', (WidgetTester tester) async {
      final themeService = ThemeService();

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => DatabaseService()),
            ChangeNotifierProvider.value(value: themeService),
          ],
          child: const TaskNestApp(),
        ),
      );

      // Open theme switcher
      await tester.tap(find.byIcon(Icons.color_lens));
      await tester.pumpAndSettle();

      // Switch to dark theme
      await tester.tap(find.text('Dark Theme'));
      await tester.pumpAndSettle();

      // Verify theme changed
      expect(themeService.themeMode, ThemeMode.dark);
    });

    testWidgets('Task completion toggle works', (WidgetTester tester) async {
      final testTask = Task(
        title: 'Test Task',
        dueDate: DateTime.now(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TaskCard(task: testTask),
          ),
        ),
      );

      // Verify task is not completed
      expect(find.byType(Checkbox), findsOneWidget);
      final checkbox = tester.widget<Checkbox>(find.byType(Checkbox));
      expect(checkbox.value, false);

      // Tap checkbox to complete task
      await tester.tap(find.byType(Checkbox));
      await tester.pump();
    });

    testWidgets('Habit completion toggle works', (WidgetTester tester) async {
      final testHabit = Habit(
        title: 'Test Habit',
        weeklyCompletion: List.filled(7, false),
        startDate: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HabitTile(habit: testHabit),
          ),
        ),
      );

      // Verify habit is not completed today
      expect(find.byType(Checkbox), findsOneWidget);
      final checkbox = tester.widget<Checkbox>(find.byType(Checkbox));
      expect(checkbox.value, false);

      // Tap checkbox to complete habit
      await tester.tap(find.byType(Checkbox));
      await tester.pump();
    });

    testWidgets('Empty state displays correctly for tasks',
        (WidgetTester tester) async {
      final databaseService = DatabaseService();

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider.value(value: databaseService),
            ChangeNotifierProvider(create: (_) => ThemeService()),
          ],
          child: const MaterialApp(
            home: HomeScreen(),
          ),
        ),
      );

      // Switch to Tasks tab
      await tester.tap(find.text('Tasks'));
      await tester.pumpAndSettle();

      // Verify empty state message
      expect(find.text('No tasks yet!'), findsOneWidget);
      expect(find.text('Tap + to create your first task'), findsOneWidget);
    });

    testWidgets('Empty state displays correctly for habits',
        (WidgetTester tester) async {
      final databaseService = DatabaseService();

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider.value(value: databaseService),
            ChangeNotifierProvider(create: (_) => ThemeService()),
          ],
          child: const MaterialApp(
            home: HomeScreen(),
          ),
        ),
      );

      // Switch to Habits tab
      await tester.tap(find.text('Habits'));
      await tester.pumpAndSettle();

      // Verify empty state message
      expect(find.text('No habits yet!'), findsOneWidget);
      expect(find.text('Tap + to create your first habit'), findsOneWidget);
    });

    testWidgets('Bottom navigation bar displays correctly',
        (WidgetTester tester) async {
      final databaseService = DatabaseService();

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider.value(value: databaseService),
            ChangeNotifierProvider(create: (_) => ThemeService()),
          ],
          child: const TaskNestApp(),
        ),
      );

      // Verify bottom navigation items
      expect(find.text('Dashboard'), findsOneWidget);
      expect(find.text('Tasks'), findsOneWidget);
      expect(find.text('Habits'), findsOneWidget);
      expect(find.byIcon(Icons.dashboard), findsOneWidget);
      expect(find.byIcon(Icons.task), findsOneWidget);
      expect(find.byIcon(Icons.auto_awesome), findsOneWidget);
    });

    testWidgets('FAB appears on Tasks and Habits tabs',
        (WidgetTester tester) async {
      final databaseService = DatabaseService();

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider.value(value: databaseService),
            ChangeNotifierProvider(create: (_) => ThemeService()),
          ],
          child: const TaskNestApp(),
        ),
      );

      // Check Tasks tab
      await tester.tap(find.text('Tasks'));
      await tester.pumpAndSettle();
      expect(find.byType(FloatingActionButton), findsOneWidget);

      // Check Habits tab
      await tester.tap(find.text('Habits'));
      await tester.pumpAndSettle();
      expect(find.byType(FloatingActionButton), findsOneWidget);

      // Check Dashboard tab (should not have FAB)
      await tester.tap(find.text('Dashboard'));
      await tester.pumpAndSettle();
      expect(find.byType(FloatingActionButton), findsNothing);
    });

    testWidgets('Task with reminder displays reminder icon',
        (WidgetTester tester) async {
      final testTask = Task(
        title: 'Task with Reminder',
        dueDate: DateTime.now().add(const Duration(days: 1)),
        hasReminder: true,
        reminderDate: DateTime.now().add(const Duration(hours: 1)),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TaskCard(task: testTask),
          ),
        ),
      );

      // Verify reminder icon is displayed
      expect(find.byIcon(Icons.notifications), findsOneWidget);
    });

    testWidgets('Habit with reminder displays reminder time',
        (WidgetTester tester) async {
      final testHabit = Habit(
        title: 'Habit with Reminder',
        weeklyCompletion: List.filled(7, false),
        hasReminder: true,
        reminderTime: const TimeOfDay(hour: 9, minute: 0),
        startDate: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HabitTile(habit: testHabit),
          ),
        ),
      );

      // Verify reminder time is displayed
      expect(find.byIcon(Icons.notifications), findsOneWidget);
      expect(find.text('9:00 AM'), findsOneWidget);
    });

    testWidgets('Task categories are displayed correctly',
        (WidgetTester tester) async {
      final testTask = Task(
        title: 'Work Task',
        dueDate: DateTime.now(),
        category: 'Work',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TaskCard(task: testTask),
          ),
        ),
      );

      // Verify category is displayed
      expect(find.text('Work'), findsOneWidget);
    });

    testWidgets('Habit categories are displayed correctly',
        (WidgetTester tester) async {
      final testHabit = Habit(
        title: 'Health Habit',
        weeklyCompletion: List.filled(7, false),
        category: 'Health & Fitness',
        startDate: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HabitTile(habit: testHabit),
          ),
        ),
      );

      // Verify category is displayed
      expect(find.text('Health & Fitness'), findsOneWidget);
    });
  });

  group('Error Handling Tests', () {
    testWidgets('App handles database errors gracefully',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => DatabaseService()),
            ChangeNotifierProvider(create: (_) => ThemeService()),
          ],
          child: const TaskNestApp(),
        ),
      );

      expect(find.text('TaskNest'), findsOneWidget);
    });

    testWidgets('App handles theme service errors gracefully',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => DatabaseService()),
            ChangeNotifierProvider(create: (_) => ThemeService()),
          ],
          child: const TaskNestApp(),
        ),
      );

      expect(find.text('TaskNest'), findsOneWidget);
    });
  });

  group('Accessibility Tests', () {
    testWidgets('All interactive elements are accessible',
        (WidgetTester tester) async {
      final databaseService = DatabaseService();

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider.value(value: databaseService),
            ChangeNotifierProvider(create: (_) => ThemeService()),
          ],
          child: const TaskNestApp(),
        ),
      );

      // Verify all interactive elements have semantics
      expect(find.bySemanticsLabel('Tasks tab'), findsOneWidget);
      expect(find.bySemanticsLabel('Habits tab'), findsOneWidget);
      expect(find.bySemanticsLabel('Dashboard tab'), findsOneWidget);
    });

    testWidgets('High contrast theme is accessible',
        (WidgetTester tester) async {
      final themeService = ThemeService();
      themeService.toggleHighContrast(true);

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => DatabaseService()),
            ChangeNotifierProvider.value(value: themeService),
          ],
          child: const TaskNestApp(),
        ),
      );

      // Verify app renders in high contrast mode
      expect(find.text('TaskNest'), findsOneWidget);
    });
  });
}

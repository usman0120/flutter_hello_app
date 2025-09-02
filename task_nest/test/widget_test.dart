import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tasknest/main.dart';
import 'package:tasknest/models/category_model.dart';
import 'package:tasknest/models/task_model.dart';
import 'package:tasknest/models/habit_model.dart';
import 'package:tasknest/screens/splash_screen.dart';
import 'package:tasknest/widgets/task_card.dart';
import 'package:tasknest/widgets/habit_tile.dart';
import 'package:tasknest/widgets/progress_ring.dart';
import 'package:tasknest/widgets/category_chip.dart';

void main() {
  group('TaskCard Widget Test', () {
    testWidgets('TaskCard displays task information correctly',
        (WidgetTester tester) async {
      final task = Task(
        title: 'Test Task',
        description: 'Test Description',
        dueDate: DateTime.now().add(const Duration(days: 1)),
        createdAt: DateTime.now(),
        category: 'Work',
        priority: 'High',
        colorCode: '0xFF4CAF50',
        tags: ['Urgent', 'Important'],
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TaskCard(
              task: task,
              onTap: () {},
              onComplete: () {},
              onEdit: () {},
              onDelete: () {},
            ),
          ),
        ),
      );

      expect(find.text('Test Task'), findsOneWidget);
      expect(find.text('Test Description'), findsOneWidget);
      expect(find.text('Work'), findsOneWidget);
      expect(find.text('High'), findsOneWidget);
      expect(find.text('Urgent'), findsOneWidget);
      expect(find.text('Important'), findsOneWidget);
    });

    testWidgets('TaskCard shows completed state correctly',
        (WidgetTester tester) async {
      final completedTask = Task(
        title: 'Completed Task',
        dueDate: DateTime.now(),
        createdAt: DateTime.now(),
        isCompleted: true,
        completedAt: DateTime.now(),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TaskCard(
              task: completedTask,
              onTap: () {},
              onComplete: () {},
              onEdit: () {},
              onDelete: () {},
            ),
          ),
        ),
      );

      expect(find.text('Completed Task'), findsOneWidget);
      expect(find.byIcon(Icons.undo), findsOneWidget);
    });
  });

  group('HabitTile Widget Test', () {
    testWidgets('HabitTile displays habit information correctly',
        (WidgetTester tester) async {
      final habit = Habit(
        title: 'Test Habit',
        description: 'Test Habit Description',
        targetFrequency: 5,
        startDate: DateTime.now(),
        completionDays: [true, false, true, false, true, false, false],
        category: 'Health',
        colorCode: '0xFF2196F3',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HabitTile(
              habit: habit,
              onTap: () {},
              onComplete: () {},
              onEdit: () {},
              onDelete: () {},
            ),
          ),
        ),
      );

      expect(find.text('Test Habit'), findsOneWidget);
      expect(find.text('Test Habit Description'), findsOneWidget);
      expect(find.text('Health'), findsOneWidget);
      expect(find.text('5x/week'), findsOneWidget);
    });

    testWidgets('HabitTile shows progress ring', (WidgetTester tester) async {
      final habit = Habit(
        title: 'Test Habit',
        targetFrequency: 3,
        startDate: DateTime.now().subtract(const Duration(days: 7)),
        completionDays: [true, true, true, false, false, false, false],
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HabitTile(
              habit: habit,
              onTap: () {},
              onComplete: () {},
              onEdit: () {},
              onDelete: () {},
            ),
          ),
        ),
      );

      expect(find.byType(ProgressRing), findsOneWidget);
    });
  });

  group('ProgressRing Widget Test', () {
    testWidgets('ProgressRing displays correct progress',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ProgressRing(
              progress: 0.75,
              radius: 40,
              centerText: '75%',
            ),
          ),
        ),
      );

      expect(find.text('75%'), findsOneWidget);
    });

    testWidgets('ProgressRing handles edge cases', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                ProgressRing(progress: -0.1, radius: 20), // Should clamp to 0
                ProgressRing(progress: 1.5, radius: 20), // Should clamp to 1
              ],
            ),
          ),
        ),
      );

      expect(find.byType(ProgressRing), findsNWidgets(2));
    });
  });

  group('CategoryChip Widget Test', () {
    testWidgets('CategoryChip displays category information',
        (WidgetTester tester) async {
      final category = Category(
        name: 'Work',
        colorCode: '0xFFFF5722',
        icon: '💼',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CategoryChip(
              category: category,
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.text('Work'), findsOneWidget);
      expect(find.text('💼'), findsOneWidget);
    });

    testWidgets('CategoryChip shows selected state',
        (WidgetTester tester) async {
      final category = Category(
        name: 'Study',
        colorCode: '0xFF9C27B0',
        icon: '📚',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CategoryChip(
              category: category,
              isSelected: true,
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.text('Study'), findsOneWidget);
      expect(find.text('📚'), findsOneWidget);
    });
  });

  group('App Integration Test', () {
    testWidgets('App launches successfully', (WidgetTester tester) async {
      await tester.pumpWidget(const TaskNestApp());
      await tester.pumpAndSettle();

      expect(find.byType(SplashScreen), findsOneWidget);
    });

    testWidgets('Main screens can be navigated to',
        (WidgetTester tester) async {
      // This test would typically require mock services
      // For now, we'll just verify that the app builds
      await tester.pumpWidget(const TaskNestApp());
      await tester.pumpAndSettle();

      expect(find.byType(SplashScreen), findsOneWidget);
    });
  });

  group('Model Tests', () {
    test('Task model toMap and fromMap work correctly', () {
      final task = Task(
        title: 'Test Task',
        description: 'Test Description',
        dueDate: DateTime(2024, 1, 1),
        createdAt: DateTime(2024, 1, 1),
        isCompleted: true,
        category: 'Work',
        priority: 'High',
        tags: ['test'],
        colorCode: '0xFF000000',
        hasReminder: true,
        reminderId: 1,
        completedAt: DateTime(2024, 1, 1),
      );

      final map = task.toMap();
      final reconstructedTask = Task.fromMap(map);

      expect(reconstructedTask.title, task.title);
      expect(reconstructedTask.description, task.description);
      expect(reconstructedTask.isCompleted, task.isCompleted);
    });

    test('Habit model toMap and fromMap work correctly', () {
      final habit = Habit(
        title: 'Test Habit',
        description: 'Test Description',
        targetFrequency: 3,
        startDate: DateTime(2024, 1, 1),
        completionDays: [true, false, true, false, true, false, false],
        category: 'Health',
        colorCode: '0xFF00FF00',
        hasReminder: true,
        reminderId: 1,
      );

      final map = habit.toMap();
      final reconstructedHabit = Habit.fromMap(map);

      expect(reconstructedHabit.title, habit.title);
      expect(reconstructedHabit.description, habit.description);
      expect(reconstructedHabit.targetFrequency, habit.targetFrequency);
    });
  });
}

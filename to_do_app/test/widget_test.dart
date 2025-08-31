// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:to_do_app/main.dart';

void main() {
  testWidgets('App launches and shows title', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that our app title is displayed
    expect(find.text('Productive Pro'), findsOneWidget);
  });

  testWidgets('Empty state is displayed when no tasks', (
    WidgetTester tester,
  ) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that empty state is displayed
    expect(find.text('No tasks yet!'), findsOneWidget);
    expect(find.text('Add a new task to get started'), findsOneWidget);
    expect(find.byIcon(Icons.checklist_rounded), findsOneWidget);
  });

  testWidgets('Add task button is present', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the add task button is present
    expect(find.byType(FloatingActionButton), findsOneWidget);
    expect(find.byIcon(Icons.add), findsOneWidget);
  });

  testWidgets('Tapping add button shows task form', (
    WidgetTester tester,
  ) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Tap the '+' icon
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    // Verify that the task form is displayed
    expect(find.text('Add New Task'), findsOneWidget);
    expect(find.text('Title *'), findsOneWidget);
    expect(find.text('Description'), findsOneWidget);
    expect(find.text('Priority'), findsOneWidget);
    expect(find.text('Category'), findsOneWidget);
  });

  testWidgets('Search button is present when tasks exist', (
    WidgetTester tester,
  ) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that search icon is present (it should be there even with no tasks)
    expect(find.byIcon(Icons.search), findsOneWidget);
  });
}

import 'package:flutter/material.dart';

class Habit {
  int? id;
  String title;
  String description;
  int targetFrequency; // Times per week
  int currentStreak;
  int longestStreak;
  int completedCount;
  List<bool> weeklyCompletion; // Track completion for each day of the week
  String category;
  String colorCode;
  bool hasReminder;
  TimeOfDay? reminderTime;
  DateTime startDate;
  DateTime updatedAt;

  Habit({
    this.id,
    required this.title,
    this.description = '',
    this.targetFrequency = 7,
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.completedCount = 0,
    required this.weeklyCompletion,
    this.category = 'Personal',
    this.colorCode = '#6C63FF',
    this.hasReminder = false,
    this.reminderTime,
    required this.startDate,
    required this.updatedAt,
  });

  // Get completion percentage for the current week
  double get weeklyCompletionPercentage {
    final completed = weeklyCompletion.where((completed) => completed).length;
    return completed / targetFrequency;
  }

  // Check if habit is completed today
  bool get isCompletedToday {
    final now = DateTime.now();
    final todayIndex = now.weekday - 1; // Monday = 0, Sunday = 6
    return weeklyCompletion[todayIndex];
  }

  // Mark habit as completed for today
  void markCompleted(bool completed) {
    final now = DateTime.now();
    final todayIndex = now.weekday - 1;
    weeklyCompletion[todayIndex] = completed;

    if (completed) {
      completedCount++;
      // Update streak logic
      final yesterdayIndex = (now.weekday - 2) % 7;
      if (weeklyCompletion[yesterdayIndex] || currentStreak == 0) {
        currentStreak++;
      } else {
        currentStreak = 1;
      }

      if (currentStreak > longestStreak) {
        longestStreak = currentStreak;
      }
    } else {
      completedCount--;
      // Reset streak if unmarking today's completion
      currentStreak = 0;
      // Recalculate streak from previous days
      for (int i = 1; i <= 6; i++) {
        final prevIndex = (todayIndex - i) % 7;
        if (weeklyCompletion[prevIndex]) {
          currentStreak++;
        } else {
          break;
        }
      }
    }

    updatedAt = DateTime.now();
  }

  // Convert Habit to Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'targetFrequency': targetFrequency,
      'currentStreak': currentStreak,
      'longestStreak': longestStreak,
      'completedCount': completedCount,
      'weeklyCompletion':
          weeklyCompletion.map((c) => c ? 1 : 0).toList().join(','),
      'category': category,
      'colorCode': colorCode,
      'hasReminder': hasReminder ? 1 : 0,
      'reminderTime': reminderTime != null
          ? '${reminderTime!.hour}:${reminderTime!.minute}'
          : null,
      'startDate': startDate.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // Create Habit from Map
  factory Habit.fromMap(Map<String, dynamic> map) {
    final completionString = map['weeklyCompletion'].toString();
    final completionList =
        completionString.split(',').map((e) => e == '1').toList();

    // Ensure we have exactly 7 days
    List<bool> weeklyCompletion = List.filled(7, false);
    for (int i = 0; i < completionList.length && i < 7; i++) {
      weeklyCompletion[i] = completionList[i];
    }

    TimeOfDay? reminderTime;
    if (map['reminderTime'] != null) {
      final timeParts = map['reminderTime'].toString().split(':');
      reminderTime = TimeOfDay(
        hour: int.parse(timeParts[0]),
        minute: int.parse(timeParts[1]),
      );
    }

    return Habit(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      targetFrequency: map['targetFrequency'],
      currentStreak: map['currentStreak'],
      longestStreak: map['longestStreak'],
      completedCount: map['completedCount'],
      weeklyCompletion: weeklyCompletion,
      category: map['category'],
      colorCode: map['colorCode'],
      hasReminder: map['hasReminder'] == 1,
      reminderTime: reminderTime,
      startDate: DateTime.parse(map['startDate']),
      updatedAt: DateTime.parse(map['updatedAt']),
    );
  }

  // Copy with method for updates
  Habit copyWith({
    int? id,
    String? title,
    String? description,
    int? targetFrequency,
    int? currentStreak,
    int? longestStreak,
    int? completedCount,
    List<bool>? weeklyCompletion,
    String? category,
    String? colorCode,
    bool? hasReminder,
    TimeOfDay? reminderTime,
    DateTime? startDate,
    DateTime? updatedAt,
  }) {
    return Habit(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      targetFrequency: targetFrequency ?? this.targetFrequency,
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      completedCount: completedCount ?? this.completedCount,
      weeklyCompletion: weeklyCompletion ?? this.weeklyCompletion,
      category: category ?? this.category,
      colorCode: colorCode ?? this.colorCode,
      hasReminder: hasReminder ?? this.hasReminder,
      reminderTime: reminderTime ?? this.reminderTime,
      startDate: startDate ?? this.startDate,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }
}

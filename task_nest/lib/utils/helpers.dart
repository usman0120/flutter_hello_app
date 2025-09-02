import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tasknest/models/task_model.dart';
import 'package:tasknest/models/habit_model.dart';
import 'package:tasknest/utils/constants.dart';

class Helpers {
  // Date formatting
  static String formatDate(DateTime date, {String format = 'MMM dd, yyyy'}) {
    return DateFormat(format).format(date);
  }

  static String formatTime(DateTime time, {String format = 'hh:mm a'}) {
    return DateFormat(format).format(time);
  }

  static String getRelativeDate(DateTime date) {
    final now = DateTime.now();
    final difference = date.difference(now);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Tomorrow';
    } else if (difference.inDays == -1) {
      return 'Yesterday';
    } else if (difference.inDays > 1 && difference.inDays < 7) {
      return 'In ${difference.inDays} days';
    } else if (difference.inDays < -1 && difference.inDays > -7) {
      return '${difference.inDays.abs()} days ago';
    } else {
      return formatDate(date);
    }
  }

  // Color conversion
  static Color hexToColor(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) {
      buffer.write('ff');
    }
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  static String colorToHex(Color color) {
    // ignore: deprecated_member_use
    return '0x${color.value.toRadixString(16).padLeft(8, '0')}';
  }

  // Text utilities
  static String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  static String truncateText(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }

  // Task utilities
  static bool isTaskDueSoon(Task task) {
    final now = DateTime.now();
    final dueDate = task.dueDate;
    final difference = dueDate.difference(now);
    return !task.isCompleted &&
        difference.inHours <= 24 &&
        difference.inHours >= 0;
  }

  static bool isTaskOverdue(Task task) {
    return !task.isCompleted && task.dueDate.isBefore(DateTime.now());
  }

  // Habit utilities
  static int calculateHabitStreak(Habit habit) {
    // Simple streak calculation based on consecutive completed days
    // This is a simplified version - you might want to implement a more robust solution
    return habit.currentStreak;
  }

  static double calculateHabitCompletionRate(Habit habit) {
    if (habit.completedCount == 0) return 0.0;
    final daysSinceStart = DateTime.now().difference(habit.startDate).inDays;
    if (daysSinceStart == 0) return 0.0;
    return (habit.completedCount /
            (habit.targetFrequency * (daysSinceStart / 7)))
        .clamp(0.0, 1.0);
  }

  // Validation
  static bool isValidEmail(String email) {
    final emailRegex =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegex.hasMatch(email);
  }

  // UI helpers
  static void showSnackBar(BuildContext context, String message,
      {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  static Future<void> showConfirmationDialog(
    BuildContext context, {
    required String title,
    required String content,
    required Function onConfirm,
  }) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Confirm'),
              onPressed: () {
                onConfirm();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Random generators (for demo data if needed)
  static String getRandomColor() {
    return AppConstants.colorOptions[
        DateTime.now().millisecond % AppConstants.colorOptions.length];
  }

  static String getRandomIcon() {
    return AppConstants.categoryIcons[
        DateTime.now().millisecond % AppConstants.categoryIcons.length];
  }
}

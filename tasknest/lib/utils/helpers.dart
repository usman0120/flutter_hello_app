import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tasknest/models/task_model.dart';
import 'package:tasknest/utils/constants.dart';

class Helpers {
  // Format date to readable string
  static String formatDate(DateTime date, {bool includeTime = false}) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final tomorrow = today.add(const Duration(days: 1));

    final dateOnly = DateTime(date.year, date.month, date.day);

    if (dateOnly == today) {
      return includeTime ? 'Today, ${formatTime(date)}' : 'Today';
    } else if (dateOnly == yesterday) {
      return includeTime ? 'Yesterday, ${formatTime(date)}' : 'Yesterday';
    } else if (dateOnly == tomorrow) {
      return includeTime ? 'Tomorrow, ${formatTime(date)}' : 'Tomorrow';
    } else if (dateOnly.isAfter(today) &&
        dateOnly.isBefore(today.add(const Duration(days: 7)))) {
      return includeTime
          ? '${DateFormat.E().format(date)}, ${formatTime(date)}'
          : DateFormat.E().format(date);
    } else {
      return includeTime
          ? DateFormat.yMMMd().add_jm().format(date)
          : DateFormat.yMMMd().format(date);
    }
  }

  // Format time only
  static String formatTime(DateTime date) {
    return DateFormat.jm().format(date);
  }

  // Format time from TimeOfDay
  static String formatTimeOfDay(TimeOfDay time) {
    final now = DateTime.now();
    final date = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return DateFormat.jm().format(date);
  }

  // Check if date is today
  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  // Check if date is tomorrow
  static bool isTomorrow(DateTime date) {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return date.year == tomorrow.year &&
        date.month == tomorrow.month &&
        date.day == tomorrow.day;
  }

  // Check if date is overdue
  static bool isOverdue(DateTime date) {
    return date.isBefore(DateTime.now());
  }

  // Get priority color
  static Color getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      case 'low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  // Get priority icon
  static IconData getPriorityIcon(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return Icons.error_outline;
      case 'medium':
        return Icons.warning_amber;
      case 'low':
        return Icons.info_outline;
      default:
        return Icons.circle;
    }
  }

  // Calculate task completion percentage
  static double calculateCompletionPercentage(List<Task> tasks) {
    if (tasks.isEmpty) return 0.0;
    final completed = tasks.where((task) => task.isCompleted).length;
    return completed / tasks.length;
  }

  // Calculate streak emoji
  static String getStreakEmoji(int streak) {
    if (streak >= 7) return '🔥';
    if (streak >= 5) return '⭐';
    if (streak >= 3) return '🌟';
    if (streak >= 1) return '👍';
    return '💤';
  }

  // Get day name from index (0 = Monday, 6 = Sunday)
  static String getDayName(int index) {
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[index];
  }

  // Get abbreviated month name
  static String getMonthName(int month) {
    return DateFormat.MMM().format(DateTime(2023, month));
  }

  // Generate gradient based on category
  static LinearGradient getCategoryGradient(String category) {
    final color =
        AppConstants.categoryColors[category] ?? const Color(0xFF6C63FF);
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        // ignore: deprecated_member_use
        color.withOpacity(0.7),
        // ignore: deprecated_member_use
        color.withOpacity(0.9),
      ],
    );
  }

  // Get contrast color for text on background
  static Color getContrastColor(Color backgroundColor) {
    final luminance = backgroundColor.computeLuminance();
    return luminance > 0.5 ? Colors.black : Colors.white;
  }

  // Parse color from hex string
  static Color parseColor(String hexColor) {
    try {
      hexColor = hexColor.replaceAll('#', '');
      if (hexColor.length == 6) {
        hexColor = 'FF$hexColor';
      }
      return Color(int.parse(hexColor, radix: 16));
    } catch (e) {
      return const Color(0xFF6C63FF);
    }
  }

  // Format duration for display
  static String formatDuration(Duration duration) {
    if (duration.inDays > 0) {
      return '${duration.inDays}d ${duration.inHours.remainder(24)}h';
    } else if (duration.inHours > 0) {
      return '${duration.inHours}h ${duration.inMinutes.remainder(60)}m';
    } else if (duration.inMinutes > 0) {
      return '${duration.inMinutes}m';
    } else {
      return 'Just now';
    }
  }

  // Get time difference from now
  static String getTimeDifference(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()}y ago';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()}mo ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  // Validate email format
  static bool isValidEmail(String email) {
    final emailRegex =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegex.hasMatch(email);
  }

  // Validate password strength
  static String? validatePassword(String password) {
    if (password.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    if (!password.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one uppercase letter';
    }
    if (!password.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least one number';
    }
    return null;
  }

  // Capitalize first letter of each word
  static String capitalize(String text) {
    if (text.isEmpty) return text;
    return text.split(' ').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }

  // Truncate text with ellipsis
  static String truncateText(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }

  // Generate random pastel color
  static Color generateRandomPastelColor() {
    final random = DateTime.now().millisecond;
    final hue = random % 360;
    return HSLColor.fromAHSL(1.0, hue.toDouble(), 0.7, 0.8).toColor();
  }

  // Get initial from name
  static String getInitials(String name) {
    if (name.isEmpty) return '';
    final parts = name.split(' ');
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }

  // Format file size
  static String formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  // Check if string contains only numbers
  static bool isNumeric(String str) {
    return double.tryParse(str) != null;
  }

  // Get weekday index from DateTime (Monday = 0, Sunday = 6)
  static int getWeekdayIndex(DateTime date) {
    return date.weekday - 1;
  }

  // Get week range for a given date
  static String getWeekRange(DateTime date) {
    final startOfWeek = date.subtract(Duration(days: date.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));

    if (startOfWeek.month == endOfWeek.month) {
      return '${startOfWeek.day} - ${endOfWeek.day} ${getMonthName(endOfWeek.month)}';
    } else {
      return '${startOfWeek.day} ${getMonthName(startOfWeek.month)} - ${endOfWeek.day} ${getMonthName(endOfWeek.month)}';
    }
  }
}

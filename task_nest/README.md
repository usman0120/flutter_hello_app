# TaskNest - Personal Task & Habit Tracker

A beautiful and feature-rich Flutter application for managing your tasks and building productive habits.

## Features

- ✅ Task Management (Create, Read, Update, Delete)
- 🔄 Habit Tracking with Streaks
- 📅 Calendar Integration
- 📊 Progress Statistics & Analytics
- 🔔 Smart Notifications & Reminders
- 🎨 Multiple Themes (Light, Dark, High Contrast)
- 💾 Offline Functionality
- 📱 Responsive Design

## Getting Started

### Prerequisites

- Flutter SDK (latest version)
- Dart SDK
- Android Studio or VS Code

### Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd tasknest
Install dependencies:

bash
flutter pub get
Run the app:

bash
flutter run
Project Structure
text
tasknest/
├── lib/
│   ├── main.dart
│   ├── models/
│   ├── services/
│   ├── screens/
│   ├── widgets/
│   └── utils/
├── assets/
│   ├── icons/
│   ├── stickers/
│   └── animations/
├── test/
└── pubspec.yaml
Testing
Run the test suite:

bash
flutter test
Building
Android
bash
flutter build apk
iOS
bash
flutter build ios
Contributing
Fork the project

Create your feature branch

Commit your changes

Push to the branch

Create a Pull Request

License
This project is licensed under the MIT License - see the LICENSE file for details.

Support
For support and questions, please contact: support@tasknest.com

text

## Additional Important Files:

Let me create some additional utility files that might be needed:

## lib/utils/date_utils.dart
```dart
import 'package:intl/intl.dart';

class DateUtils {
  static String formatDate(DateTime date, {String pattern = 'MMM dd, yyyy'}) {
    return DateFormat(pattern).format(date);
  }

  static String formatTime(DateTime time, {String pattern = 'hh:mm a'}) {
    return DateFormat(pattern).format(time);
  }

  static DateTime getStartOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  static DateTime getEndOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day, 23, 59, 59, 999);
  }

  static bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  static List<DateTime> getDaysInWeek(DateTime date) {
    final firstDayOfWeek = date.subtract(Duration(days: date.weekday - 1));
    return List.generate(7, (index) => firstDayOfWeek.add(Duration(days: index)));
  }

  static int getWeekNumber(DateTime date) {
    final firstDayOfYear = DateTime(date.year, 1, 1);
    final daysDifference = date.difference(firstDayOfYear).inDays;
    return ((daysDifference + firstDayOfYear.weekday - 1) / 7).floor() + 1;
  }

  static DateTime addDays(DateTime date, int days) {
    return date.add(Duration(days: days));
  }

  static DateTime subtractDays(DateTime date, int days) {
    return date.subtract(Duration(days: days));
  }

  static bool isToday(DateTime date) {
    return isSameDay(date, DateTime.now());
  }

  static bool isTomorrow(DateTime date) {
    return isSameDay(date, DateTime.now().add(const Duration(days: 1)));
  }

  static bool isYesterday(DateTime date) {
    return isSameDay(date, DateTime.now().subtract(const Duration(days: 1)));
  }

  static String getRelativeDate(DateTime date) {
    if (isToday(date)) return 'Today';
    if (isTomorrow(date)) return 'Tomorrow';
    if (isYesterday(date)) return 'Yesterday';
    
    final difference = DateTime.now().difference(date);
    if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    }
    
    return formatDate(date);
  }
}
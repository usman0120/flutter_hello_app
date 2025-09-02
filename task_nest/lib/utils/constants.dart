class AppConstants {
  // App info
  static const String appName = 'TaskNest';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'Your personal task and habit tracker';

  // API URLs (for future use)
  static const String aiSuggestionApi = 'https://api.example.com/suggestions';

  // Local storage keys
  static const String firstLaunchKey = 'first_launch';
  static const String themeModeKey = 'theme_mode';
  static const String fontSizeKey = 'font_size';
  static const String fontFamilyKey = 'font_family';
  static const String notificationsEnabledKey = 'notifications_enabled';

  // Notification channels
  static const String notificationChannelId = 'tasknest_channel';
  static const String notificationChannelName = 'TaskNest Reminders';
  static const String notificationChannelDesc =
      'Channel for TaskNest reminders';

  // Default values
  static const List<String> priorityLevels = ['Low', 'Medium', 'High'];
  static const List<String> defaultTags = [
    'Urgent',
    'Important',
    'Personal',
    'Work',
    'Study',
    'Health',
    'Finance',
    'Social'
  ];

  // Colors
  static const List<String> colorOptions = [
    '0xFF4CAF50', // Green
    '0xFF2196F3', // Blue
    '0xFFFF5722', // Orange
    '0xFF9C27B0', // Purple
    '0xFFFFC107', // Amber
    '0xFFE91E63', // Pink
    '0xFF795548', // Brown
    '0xFF607D8B', // Blue Grey
  ];

  // Icons
  static const List<String> categoryIcons = [
    '💼',
    '📚',
    '🏥',
    '👤',
    '💰',
    '👥',
    '🏠',
    '📦'
  ];

  // URLs
  static const String privacyPolicyUrl = 'https://example.com/privacy';
  static const String termsOfServiceUrl = 'https://example.com/terms';
  static const String contactEmail = 'support@tasknest.com';

  // Animation durations
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration pageTransitionDuration = Duration(milliseconds: 500);
}

class RouteNames {
  static const String home = '/';
  static const String calendar = '/calendar';
  static const String stats = '/stats';
  static const String settings = '/settings';
  static const String about = '/about';
  static const String privacy = '/privacy';
  static const String terms = '/terms';
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasknest/services/database_service.dart';
import 'package:tasknest/services/notification_service.dart';
import 'package:tasknest/services/theme_service.dart';
import 'package:tasknest/screens/home_screen.dart';
import 'package:tasknest/screens/calendar_screen.dart';
import 'package:tasknest/screens/stats_screen.dart';
import 'package:tasknest/screens/settings_screen.dart';
import 'package:tasknest/screens/about_screen.dart';
import 'package:tasknest/screens/contact_screen.dart';
import 'package:tasknest/screens/privacy_screen.dart';
import 'package:tasknest/screens/terms_screen.dart';
import 'package:tasknest/utils/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize services
  final databaseService = DatabaseService();
  await databaseService.init();

  final notificationService = NotificationService();
  await notificationService.init();

  final themeService = ThemeService();
  await themeService.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => databaseService),
        ChangeNotifierProvider(create: (_) => themeService),
        Provider<NotificationService>.value(value: notificationService),
      ],
      child: const TaskNestApp(),
    ),
  );
}

class TaskNestApp extends StatelessWidget {
  const TaskNestApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeService = Provider.of<ThemeService>(context);

    return MaterialApp(
      title: 'TaskNest',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      highContrastTheme: AppTheme.highContrastTheme,
      highContrastDarkTheme: AppTheme.highContrastDarkTheme,
      themeMode: themeService.themeMode,
      home: const HomeScreen(),
      routes: {
        '/home': (context) => const HomeScreen(),
        '/calendar': (context) => const CalendarScreen(),
        '/stats': (context) => const StatsScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/about': (context) => const AboutScreen(),
        '/contact': (context) => const ContactScreen(),
        '/privacy': (context) => const PrivacyScreen(),
        '/terms': (context) => const TermsScreen(),
      },
      // Enhanced error handling for unknown routes
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => Scaffold(
            appBar: AppBar(title: const Text('Page Not Found')),
            body: Center(
              child: Text(
                'The page "${settings.name}" was not found.',
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
        );
      },
    );
  }
}

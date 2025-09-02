import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasknest/services/database_service.dart';
import 'package:tasknest/services/notification_service.dart';
import 'package:tasknest/services/theme_service.dart';
import 'package:tasknest/screens/home_screen.dart';
import 'package:tasknest/screens/splash_screen.dart';
import 'package:tasknest/screens/calendar_screen.dart';
import 'package:tasknest/screens/stats_screen.dart';
import 'package:tasknest/screens/settings_screen.dart';
import 'package:tasknest/screens/about_screen.dart';
import 'package:tasknest/screens/privacy_screen.dart';
import 'package:tasknest/screens/terms_screen.dart';
import 'package:tasknest/utils/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const TaskNestApp());
}

class TaskNestApp extends StatefulWidget {
  const TaskNestApp({super.key});

  @override
  State<TaskNestApp> createState() => _TaskNestAppState();
}

class _TaskNestAppState extends State<TaskNestApp> {
  late DatabaseService _databaseService;
  final NotificationService _notificationService = NotificationService();
  final ThemeService _themeService = ThemeService();
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _databaseService = DatabaseService();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    await _databaseService.initialize();
    await _notificationService.init();
    await _themeService.init();

    setState(() {
      _isInitialized = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return MaterialApp(
        home: SplashScreen(onInitializationComplete: () {
          setState(() {
            _isInitialized = true;
          });
        }),
      );
    }

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<DatabaseService>(
          create: (_) => _databaseService,
        ),
        ChangeNotifierProvider<ThemeService>(
          create: (_) => _themeService,
        ),
      ],
      child: Consumer<ThemeService>(
        builder: (context, themeService, child) {
          return MaterialApp(
            title: 'TaskNest',
            debugShowCheckedModeBanner: false,
            theme: AppThemes.lightTheme,
            darkTheme: AppThemes.darkTheme,
            themeMode: themeService.themeMode,
            home: const HomeScreen(),
            routes: {
              '/home': (context) => const HomeScreen(),
              '/calendar': (context) => const CalendarScreen(),
              '/stats': (context) => const StatsScreen(),
              '/settings': (context) => const SettingsScreen(),
              '/about': (context) => const AboutScreen(),
              '/privacy': (context) => const PrivacyScreen(),
              '/terms': (context) => const TermsScreen(),
            },
          );
        },
      ),
    );
  }
}

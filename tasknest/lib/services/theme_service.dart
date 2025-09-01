import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeService with ChangeNotifier {
  static const String _themeModeKey = 'theme_mode';
  static const String _fontFamilyKey = 'font_family';
  static const String _accentColorKey = 'accent_color';
  static const String _darkModeKey = 'dark_mode';
  static const String _highContrastKey = 'high_contrast';

  ThemeMode _themeMode = ThemeMode.system;
  String _fontFamily = 'Roboto';
  Color _accentColor = const Color(0xFF6C63FF);
  bool _isDarkMode = false;
  bool _isHighContrast = false;

  // Getters
  ThemeMode get themeMode => _themeMode;
  String get fontFamily => _fontFamily;
  Color get accentColor => _accentColor;
  bool get isDarkMode => _isDarkMode;
  bool get isHighContrast => _isHighContrast;

// Available font families (using built-in Flutter fonts)
  static const List<String> availableFonts = [
    'Roboto', // Default Material font
    'Arial', // Common system font
    'Helvetica', // Common system font
    'Times New Roman', // Common system font
    'Courier New', // Monospace font
    'Georgia', // Serif font
    'Verdana', // Sans-serif font
  ];
  // Available accent colors
  static const List<Color> availableColors = [
    Color(0xFF6C63FF), // Purple
    Color(0xFFFF6584), // Pink
    Color(0xFF36D1DC), // Blue
    Color(0xFFFFB347), // Orange
    Color(0xFF4CAF50), // Green
    Color(0xFF9C27B0), // Deep Purple
    Color(0xFFF44336), // Red
    Color(0xFF2196F3), // Blue
    Color(0xFFFFC107), // Amber
    Color(0xFF607D8B), // Blue Grey
  ];

  // Initialize theme service
  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();

    // Load theme mode
    final themeModeIndex = prefs.getInt(_themeModeKey) ?? 0;
    _themeMode =
        ThemeMode.values[themeModeIndex.clamp(0, ThemeMode.values.length - 1)];

    // Load font family
    _fontFamily = prefs.getString(_fontFamilyKey) ?? 'Roboto';

    // Load accent color
    final colorValue = prefs.getInt(_accentColorKey) ?? 0xFF6C63FF;
    _accentColor = Color(colorValue);

    // Load dark mode preference
    _isDarkMode = prefs.getBool(_darkModeKey) ?? false;

    // Load high contrast preference
    _isHighContrast = prefs.getBool(_highContrastKey) ?? false;

    notifyListeners();
  }

  // Set theme mode
  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_themeModeKey, mode.index);
    notifyListeners();
  }

  // Set font family
  Future<void> setFontFamily(String fontFamily) async {
    if (availableFonts.contains(fontFamily)) {
      _fontFamily = fontFamily;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_fontFamilyKey, fontFamily);
      notifyListeners();
    }
  }

  // Set accent color
  Future<void> setAccentColor(Color color) async {
    _accentColor = color;
    final prefs = await SharedPreferences.getInstance();
    // ignore: deprecated_member_use
    await prefs.setInt(_accentColorKey, color.value);
    notifyListeners();
  }

  // Toggle dark mode
  Future<void> toggleDarkMode(bool value) async {
    _isDarkMode = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_darkModeKey, value);
    notifyListeners();
  }

  // Toggle high contrast mode
  Future<void> toggleHighContrast(bool value) async {
    _isHighContrast = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_highContrastKey, value);
    notifyListeners();
  }

  // Reset to default settings
  Future<void> resetToDefaults() async {
    _themeMode = ThemeMode.system;
    _fontFamily = 'Roboto';
    _accentColor = const Color(0xFF6C63FF);
    _isDarkMode = false;
    _isHighContrast = false;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_themeModeKey);
    await prefs.remove(_fontFamilyKey);
    await prefs.remove(_accentColorKey);
    await prefs.remove(_darkModeKey);
    await prefs.remove(_highContrastKey);

    notifyListeners();
  }

  // Get current theme based on settings
  ThemeData getCurrentTheme(BuildContext context) {
    final baseTheme = Theme.of(context);
    final brightness = _isDarkMode ? Brightness.dark : Brightness.light;

    if (_isHighContrast) {
      return brightness == Brightness.dark
          ? _createHighContrastDarkTheme()
          : _createHighContrastLightTheme();
    }

    return baseTheme.copyWith(
      textTheme: baseTheme.textTheme.apply(
        fontFamily: _fontFamily,
      ),
      primaryColor: _accentColor,
      colorScheme: baseTheme.colorScheme.copyWith(
        primary: _accentColor,
        // ignore: deprecated_member_use
        secondary: _accentColor.withOpacity(0.8),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: _accentColor,
        foregroundColor: Colors.white,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: _accentColor,
        foregroundColor: Colors.white,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.all(_accentColor),
        // ignore: deprecated_member_use
        trackColor: WidgetStateProperty.all(_accentColor.withOpacity(0.5)),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.all(_accentColor),
      ),
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.all(_accentColor),
      ),
    );
  }

  // Create high contrast light theme
  ThemeData _createHighContrastLightTheme() {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: Colors.black,
      colorScheme: const ColorScheme.light(
        primary: Colors.black,
        secondary: Colors.red,
        surface: Colors.white,
      ),
      scaffoldBackgroundColor: Colors.white,
      textTheme: const TextTheme(
        displayLarge: TextStyle(
            fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black),
        displayMedium: TextStyle(
            fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
        bodyLarge: TextStyle(
            fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),
        bodyMedium: TextStyle(
            fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
      ),
      cardTheme: const CardThemeData(
        color: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.black, width: 2),
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black, width: 2),
        ),
      ),
    );
  }

  // Create high contrast dark theme
  ThemeData _createHighContrastDarkTheme() {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: Colors.white,
      colorScheme: const ColorScheme.dark(
        primary: Colors.white,
        secondary: Colors.red,
        surface: Colors.black,
      ),
      scaffoldBackgroundColor: Colors.black,
      textTheme: const TextTheme(
        displayLarge: TextStyle(
            fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
        displayMedium: TextStyle(
            fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        bodyLarge: TextStyle(
            fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
        bodyMedium: TextStyle(
            fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
      ),
      cardTheme: const CardThemeData(
        color: Colors.black,
        elevation: 4,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.white, width: 2),
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: Colors.black,
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white, width: 2),
        ),
      ),
    );
  }
}

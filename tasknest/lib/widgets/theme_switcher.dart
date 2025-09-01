// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasknest/services/theme_service.dart';

class ThemeSwitcherDialog extends StatelessWidget {
  const ThemeSwitcherDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final themeService = Provider.of<ThemeService>(context);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Choose Theme',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildThemeOption(
              context,
              'Light Theme',
              ThemeMode.light,
              themeService.themeMode,
              Icons.light_mode,
              Colors.amber,
            ),
            _buildThemeOption(
              context,
              'Dark Theme',
              ThemeMode.dark,
              themeService.themeMode,
              Icons.dark_mode,
              Colors.blueGrey,
            ),
            _buildThemeOption(
              context,
              'System Default',
              ThemeMode.system,
              themeService.themeMode,
              Icons.settings,
              Colors.grey,
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            const Text(
              'High Contrast Themes',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 12),
            _buildHighContrastOption(
              context,
              'High Contrast Light',
              themeService.isHighContrast && !themeService.isDarkMode,
              Icons.contrast,
              Colors.black,
            ),
            _buildHighContrastOption(
              context,
              'High Contrast Dark',
              themeService.isHighContrast && themeService.isDarkMode,
              Icons.contrast,
              Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeOption(
    BuildContext context,
    String title,
    ThemeMode mode,
    ThemeMode currentMode,
    IconData icon,
    Color color,
  ) {
    final isSelected = currentMode == mode;
    final themeService = Provider.of<ThemeService>(context, listen: false);

    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: color),
      ),
      title: Text(title),
      trailing:
          isSelected ? const Icon(Icons.check, color: Colors.green) : null,
      onTap: () {
        themeService.setThemeMode(mode);
        Navigator.pop(context);
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      tileColor:
          isSelected ? Theme.of(context).primaryColor.withOpacity(0.1) : null,
    );
  }

  Widget _buildHighContrastOption(
    BuildContext context,
    String title,
    bool isSelected,
    IconData icon,
    Color color,
  ) {
    final themeService = Provider.of<ThemeService>(context, listen: false);

    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          shape: BoxShape.circle,
          border: Border.all(color: color),
        ),
        child: Icon(icon, color: color),
      ),
      title: Text(title),
      trailing:
          isSelected ? const Icon(Icons.check, color: Colors.green) : null,
      onTap: () {
        if (title == 'High Contrast Light') {
          themeService.toggleHighContrast(true);
          themeService.toggleDarkMode(false);
        } else {
          themeService.toggleHighContrast(true);
          themeService.toggleDarkMode(true);
        }
        Navigator.pop(context);
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      tileColor:
          isSelected ? Theme.of(context).primaryColor.withOpacity(0.1) : null,
    );
  }
}

// Theme preview card widget
class ThemePreviewCard extends StatelessWidget {
  final String title;
  final ThemeData theme;
  final bool isSelected;
  final VoidCallback onTap;

  const ThemePreviewCard({
    super.key,
    required this.title,
    required this.theme,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: isSelected ? 4 : 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isSelected
            ? BorderSide(color: theme.primaryColor, width: 2)
            : BorderSide.none,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Preview elements
              Row(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: theme.primaryColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      height: 8,
                      color: theme.colorScheme.background,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                height: 4,
                color: theme.dividerColor,
              ),
              const SizedBox(height: 8),
              Container(
                height: 4,
                width: 100,
                color: theme.primaryColor,
              ),
              const SizedBox(height: 8),
              Container(
                height: 4,
                width: 80,
                color: theme.colorScheme.secondary,
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: theme.textTheme.bodyMedium,
              ),
              if (isSelected)
                const Align(
                  alignment: Alignment.centerRight,
                  child: Icon(Icons.check_circle, color: Colors.green),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// Theme switcher in settings
class ThemeSwitcherList extends StatelessWidget {
  const ThemeSwitcherList({super.key});

  @override
  Widget build(BuildContext context) {
    final themeService = Provider.of<ThemeService>(context);

    return Column(
      children: [
        _buildThemeOptionTile(
          context,
          'Light Theme',
          ThemeMode.light,
          themeService.themeMode,
          Icons.light_mode,
        ),
        _buildThemeOptionTile(
          context,
          'Dark Theme',
          ThemeMode.dark,
          themeService.themeMode,
          Icons.dark_mode,
        ),
        _buildThemeOptionTile(
          context,
          'System Default',
          ThemeMode.system,
          themeService.themeMode,
          Icons.settings,
        ),
      ],
    );
  }

  Widget _buildThemeOptionTile(
    BuildContext context,
    String title,
    ThemeMode mode,
    ThemeMode currentMode,
    IconData icon,
  ) {
    final isSelected = currentMode == mode;
    final themeService = Provider.of<ThemeService>(context, listen: false);

    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing:
          isSelected ? const Icon(Icons.check, color: Colors.green) : null,
      onTap: () => themeService.setThemeMode(mode),
    );
  }
}

// Quick theme switcher button for app bar
class ThemeSwitcherButton extends StatelessWidget {
  const ThemeSwitcherButton({super.key});

  @override
  Widget build(BuildContext context) {
    final themeService = Provider.of<ThemeService>(context);

    return IconButton(
      icon: Icon(
        themeService.themeMode == ThemeMode.dark
            ? Icons.light_mode
            : Icons.dark_mode,
      ),
      onPressed: () {
        final newMode = themeService.themeMode == ThemeMode.dark
            ? ThemeMode.light
            : ThemeMode.dark;
        themeService.setThemeMode(newMode);
      },
      tooltip: 'Switch theme',
    );
  }
}

// Theme preview section for settings
class ThemePreviewSection extends StatelessWidget {
  const ThemePreviewSection({super.key});

  @override
  Widget build(BuildContext context) {
    final themeService = Provider.of<ThemeService>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Theme Preview',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _buildThemePreview(
              context,
              'Light',
              ThemeMode.light,
              themeService.themeMode,
            ),
            _buildThemePreview(
              context,
              'Dark',
              ThemeMode.dark,
              themeService.themeMode,
            ),
            _buildThemePreview(
              context,
              'High Contrast Light',
              ThemeMode.light,
              themeService.themeMode,
              isHighContrast: true,
            ),
            _buildThemePreview(
              context,
              'High Contrast Dark',
              ThemeMode.dark,
              themeService.themeMode,
              isHighContrast: true,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildThemePreview(
    BuildContext context,
    String title,
    ThemeMode mode,
    ThemeMode currentMode, {
    bool isHighContrast = false,
  }) {
    final themeService = Provider.of<ThemeService>(context, listen: false);
    final isSelected =
        currentMode == mode && themeService.isHighContrast == isHighContrast;

    return ThemePreviewCard(
      title: title,
      theme: _getPreviewTheme(mode, isHighContrast),
      isSelected: isSelected,
      onTap: () {
        themeService.setThemeMode(mode);
        themeService.toggleHighContrast(isHighContrast);
        if (isHighContrast) {
          themeService.toggleDarkMode(mode == ThemeMode.dark);
        }
      },
    );
  }

  ThemeData _getPreviewTheme(ThemeMode mode, bool isHighContrast) {
    if (isHighContrast) {
      return mode == ThemeMode.dark
          ? _createHighContrastDarkTheme()
          : _createHighContrastLightTheme();
    }

    return mode == ThemeMode.dark ? _createDarkTheme() : _createLightTheme();
  }

  ThemeData _createLightTheme() {
    return ThemeData.light().copyWith(
      primaryColor: Colors.blue,
      colorScheme: const ColorScheme.light(primary: Colors.blue),
    );
  }

  ThemeData _createDarkTheme() {
    return ThemeData.dark().copyWith(
      primaryColor: Colors.blueAccent,
      colorScheme: const ColorScheme.dark(primary: Colors.blueAccent),
    );
  }

  ThemeData _createHighContrastLightTheme() {
    return ThemeData.light().copyWith(
      primaryColor: Colors.black,
      colorScheme: const ColorScheme.light(
        primary: Colors.black,
        secondary: Colors.red,
        background: Colors.white,
      ),
    );
  }

  ThemeData _createHighContrastDarkTheme() {
    return ThemeData.dark().copyWith(
      primaryColor: Colors.white,
      colorScheme: const ColorScheme.dark(
        primary: Colors.white,
        secondary: Colors.red,
        background: Colors.black,
      ),
    );
  }
}

// Theme brightness indicator
class ThemeBrightnessIndicator extends StatelessWidget {
  const ThemeBrightnessIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: brightness == Brightness.dark
            ? Colors.white.withOpacity(0.1)
            : Colors.black.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            brightness == Brightness.dark ? Icons.dark_mode : Icons.light_mode,
            size: 14,
          ),
          const SizedBox(width: 4),
          Text(
            brightness == Brightness.dark ? 'Dark' : 'Light',
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}

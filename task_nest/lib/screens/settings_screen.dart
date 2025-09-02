import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasknest/services/theme_service.dart';
import 'package:tasknest/utils/constants.dart';
import 'package:tasknest/utils/helpers.dart';
import 'package:tasknest/widgets/custom_appbar.dart';
import 'package:tasknest/screens/about_screen.dart';
import 'package:tasknest/screens/privacy_screen.dart';
import 'package:tasknest/screens/terms_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final themeService = Provider.of<ThemeService>(context);

    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Settings',
        showBackButton: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionHeader('Appearance'),
          _buildThemeSelector(themeService),
          _buildFontSettings(themeService),
          const SizedBox(height: 24),
          _buildSectionHeader('Notifications'),
          _buildNotificationSettings(),
          const SizedBox(height: 24),
          _buildSectionHeader('Data'),
          _buildDataManagement(),
          const SizedBox(height: 24),
          _buildSectionHeader('About'),
          _buildAboutLinks(),
          const SizedBox(height: 32),
          _buildAppInfo(),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
      ),
    );
  }

  Widget _buildThemeSelector(ThemeService themeService) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Theme',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildThemeOption(
                  themeService,
                  'Light',
                  ThemeMode.light,
                  Icons.light_mode,
                ),
                _buildThemeOption(
                  themeService,
                  'Dark',
                  ThemeMode.dark,
                  Icons.dark_mode,
                ),
                _buildThemeOption(
                  themeService,
                  'System',
                  ThemeMode.system,
                  Icons.settings,
                ),
                _buildThemeOption(
                  themeService,
                  'High Contrast',
                  ThemeMode.light, // This would need custom handling
                  Icons.contrast,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeOption(
    ThemeService themeService,
    String label,
    ThemeMode mode,
    IconData icon,
  ) {
    final isSelected = themeService.themeMode == mode;

    return FilterChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16),
          const SizedBox(width: 4),
          Text(label),
        ],
      ),
      selected: isSelected,
      onSelected: (_) => themeService.setThemeMode(mode),
      backgroundColor: isSelected
          ? Theme.of(context).colorScheme.primary
          : Theme.of(context).colorScheme.surface,
      selectedColor: Theme.of(context).colorScheme.primary,
      checkmarkColor: Theme.of(context).colorScheme.onPrimary,
      labelStyle: TextStyle(
        color: isSelected
            ? Theme.of(context).colorScheme.onPrimary
            : Theme.of(context).colorScheme.onSurface,
      ),
    );
  }

  Widget _buildFontSettings(ThemeService themeService) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Font Settings',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Font Family',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                DropdownButton<String>(
                  value: themeService.fontFamily,
                  items: const [
                    DropdownMenuItem(value: 'Roboto', child: Text('Roboto')),
                    DropdownMenuItem(
                        value: 'OpenSans', child: Text('Open Sans')),
                    DropdownMenuItem(value: 'Lato', child: Text('Lato')),
                    DropdownMenuItem(
                        value: 'Montserrat', child: Text('Montserrat')),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      themeService.setFontFamily(value);
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Font Size',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                Slider(
                  value: themeService.fontSize,
                  min: 12,
                  max: 18,
                  divisions: 6,
                  label: themeService.fontSize.toStringAsFixed(0),
                  onChanged: (value) {
                    themeService.setFontSize(value);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationSettings() {
    return Card(
      child: SwitchListTile(
        title: const Text('Enable Notifications'),
        subtitle: const Text('Receive reminders for tasks and habits'),
        value: true,
        onChanged: (value) {
          Helpers.showSnackBar(context, 'Notification settings updated');
        },
      ),
    );
  }

  Widget _buildDataManagement() {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.backup),
            title: const Text('Export Data'),
            subtitle: const Text('Export your tasks and habits to a file'),
            onTap: () {
              Helpers.showSnackBar(context, 'Data export feature coming soon');
            },
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.restore),
            title: const Text('Import Data'),
            subtitle: const Text('Import tasks and habits from a file'),
            onTap: () {
              Helpers.showSnackBar(context, 'Data import feature coming soon');
            },
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.delete, color: Colors.red),
            title: const Text('Clear All Data',
                style: TextStyle(color: Colors.red)),
            subtitle: const Text('Permanently delete all tasks and habits'),
            onTap: () {
              _showClearDataConfirmation();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAboutLinks() {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('About TaskNest'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AboutScreen()),
              );
            },
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.privacy_tip),
            title: const Text('Privacy Policy'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PrivacyScreen()),
              );
            },
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.description),
            title: const Text('Terms & Conditions'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TermsScreen()),
              );
            },
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.help),
            title: const Text('Help & Support'),
            onTap: () {
              Helpers.showSnackBar(context, 'Help center coming soon');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAppInfo() {
    return Center(
      child: Column(
        children: [
          const FlutterLogo(size: 48),
          const SizedBox(height: 8),
          Text(
            AppConstants.appName,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          Text(
            'Version ${AppConstants.appVersion}',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 4),
          Text(
            AppConstants.appDescription,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color:
                      // ignore: deprecated_member_use
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                ),
          ),
        ],
      ),
    );
  }

  void _showClearDataConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Data?'),
        content: const Text(
          'This action will permanently delete all your tasks and habits. '
          'This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Helpers.showSnackBar(context, 'All data has been cleared');
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }
}

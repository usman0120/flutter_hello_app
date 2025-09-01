import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasknest/services/theme_service.dart';
import 'package:tasknest/utils/constants.dart';
import 'package:tasknest/screens/about_screen.dart';
import 'package:tasknest/screens/contact_screen.dart';
import 'package:tasknest/screens/privacy_screen.dart';
import 'package:tasknest/screens/terms_screen.dart';
import 'package:tasknest/widgets/theme_switcher.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeService = Provider.of<ThemeService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // App Settings Section
          _buildSectionHeader('Appearance'),
          _buildThemeSettings(context, themeService),
          const SizedBox(height: 16),

          // Notification Settings
          _buildSectionHeader('Notifications'),
          _buildNotificationSettings(),
          const SizedBox(height: 16),

          // Data Management
          _buildSectionHeader('Data & Storage'),
          _buildDataManagementSettings(context),
          const SizedBox(height: 16),

          // App Information
          _buildSectionHeader('About'),
          _buildAppInformation(context),
          const SizedBox(height: 16),

          // Legal
          _buildSectionHeader('Legal'),
          _buildLegalSettings(context),
          const SizedBox(height: 32),

          // App Version
          _buildAppVersion(),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ));
  }

  Widget _buildThemeSettings(BuildContext context, ThemeService themeService) {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.color_lens),
            title: const Text('Theme'),
            subtitle: const Text('Choose your preferred theme'),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => const ThemeSwitcherDialog(),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.format_size),
            title: const Text('Font Family'),
            subtitle: Text(themeService.fontFamily),
            onTap: () {
              _showFontFamilyDialog(context, themeService);
            },
          ),
          ListTile(
            leading: const Icon(Icons.palette),
            title: const Text('Accent Color'),
            subtitle: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: themeService.accentColor,
                shape: BoxShape.circle,
              ),
            ),
            onTap: () {
              _showAccentColorDialog(context, themeService);
            },
          ),
          SwitchListTile(
            title: const Text('Dark Mode'),
            subtitle: const Text('Enable dark theme'),
            value: themeService.isDarkMode,
            onChanged: (value) {
              themeService.toggleDarkMode(value);
            },
          ),
          SwitchListTile(
            title: const Text('High Contrast'),
            subtitle: const Text('Increase contrast for better visibility'),
            value: themeService.isHighContrast,
            onChanged: (value) {
              themeService.toggleHighContrast(value);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationSettings() {
    return Card(
      child: Column(
        children: [
          SwitchListTile(
            title: const Text('Task Reminders'),
            subtitle: const Text('Get notified about upcoming tasks'),
            value: true,
            onChanged: (value) {},
          ),
          SwitchListTile(
            title: const Text('Habit Reminders'),
            subtitle: const Text('Daily reminders for your habits'),
            value: true,
            onChanged: (value) {},
          ),
          SwitchListTile(
            title: const Text('Vibration'),
            subtitle: const Text('Enable vibration for notifications'),
            value: true,
            onChanged: (value) {},
          ),
          SwitchListTile(
            title: const Text('Sound'),
            subtitle: const Text('Enable sound for notifications'),
            value: true,
            onChanged: (value) {},
          ),
        ],
      ),
    );
  }

  Widget _buildDataManagementSettings(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.backup),
            title: const Text('Backup Data'),
            subtitle: const Text('Create a backup of your tasks and habits'),
            onTap: () {
              _showBackupDialog(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.restore),
            title: const Text('Restore Data'),
            subtitle: const Text('Restore from a previous backup'),
            onTap: () {
              _showRestoreDialog(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete),
            title: const Text('Clear Data'),
            subtitle: const Text('Delete all tasks and habits'),
            onTap: () {
              _showClearDataDialog(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.storage),
            title: const Text('Storage Usage'),
            subtitle: const Text('View app storage information'),
            onTap: () {
              _showStorageInfo(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAppInformation(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('About TaskNest'),
            subtitle: const Text('Learn more about our app'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AboutScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.contact_support),
            title: const Text('Contact Support'),
            subtitle: const Text('Get help and support'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ContactScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.star),
            title: const Text('Rate the App'),
            subtitle: const Text('Share your experience with us'),
            onTap: () {
              _rateApp(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.share),
            title: const Text('Share App'),
            subtitle: const Text('Share with friends and family'),
            onTap: () {
              _shareApp(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLegalSettings(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.privacy_tip),
            title: const Text('Privacy Policy'),
            subtitle: const Text('How we handle your data'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PrivacyScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.description),
            title: const Text('Terms of Service'),
            subtitle: const Text('App usage terms and conditions'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TermsScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.cookie),
            title: const Text('Cookie Policy'),
            subtitle: const Text('Information about cookies'),
            onTap: () {
              _showCookiePolicy(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAppVersion() {
    return const Center(
      child: Text(
        'Version ${AppConstants.appVersion}',
        style: TextStyle(
          color: Colors.grey,
          fontSize: 12,
        ),
      ),
    );
  }

  void _showFontFamilyDialog(BuildContext context, ThemeService themeService) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Choose Font Family'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: ThemeService.availableFonts.length,
              itemBuilder: (context, index) {
                final font = ThemeService.availableFonts[index];
                return ListTile(
                  title: Text(
                    font,
                    style: TextStyle(fontFamily: font),
                  ),
                  trailing: themeService.fontFamily == font
                      ? const Icon(Icons.check, color: Colors.green)
                      : null,
                  onTap: () {
                    themeService.setFontFamily(font);
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  void _showAccentColorDialog(BuildContext context, ThemeService themeService) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Choose Accent Color'),
          content: SizedBox(
            width: 300,
            child: GridView.builder(
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: ThemeService.availableColors.length,
              itemBuilder: (context, index) {
                final color = ThemeService.availableColors[index];
                return GestureDetector(
                  onTap: () {
                    themeService.setAccentColor(color);
                    Navigator.pop(context);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      // ignore: deprecated_member_use
                      border: themeService.accentColor.value == color.value
                          ? Border.all(color: Colors.white, width: 3)
                          : null,
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  void _showBackupDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Backup Data'),
          content: const Text('Your data will be backed up to cloud storage.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                // Implement backup functionality
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Backup completed successfully!')),
                );
              },
              child: const Text('Backup'),
            ),
          ],
        );
      },
    );
  }

  void _showRestoreDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Restore Data'),
          content: const Text('Restore your data from a previous backup.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                // Implement restore functionality
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Data restored successfully!')),
                );
              },
              child: const Text('Restore'),
            ),
          ],
        );
      },
    );
  }

  void _showClearDataDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Clear All Data'),
          content: const Text(
              'This action cannot be undone. All your tasks and habits will be permanently deleted.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Implement clear data functionality
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('All data has been cleared.')),
                );
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Delete All'),
            ),
          ],
        );
      },
    );
  }

  void _showStorageInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Storage Information'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Database: 2.5 MB'),
              Text('Cache: 1.2 MB'),
              Text('Total: 3.7 MB'),
              SizedBox(height: 16),
              Text('Last cleaned: 2 days ago'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
            TextButton(
              onPressed: () {
                // Implement clear cache functionality
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Cache cleared successfully!')),
                );
              },
              child: const Text('Clear Cache'),
            ),
          ],
        );
      },
    );
  }

  void _rateApp(BuildContext context) {
    // Implement app rating functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Redirecting to app store...')),
    );
  }

  void _shareApp(BuildContext context) {
    // Implement app sharing functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Sharing app...')),
    );
  }

  void _showCookiePolicy(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Cookie Policy'),
          content: const SingleChildScrollView(
            child: Text(
              'TaskNest uses cookies to improve your experience. '
              'We use essential cookies for app functionality and analytical cookies '
              'to understand how you use our app. By continuing to use TaskNest, '
              'you agree to our use of cookies.\n\n'
              'You can manage your cookie preferences in your device settings.',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}

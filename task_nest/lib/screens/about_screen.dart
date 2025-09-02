import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:tasknest/utils/constants.dart';
import 'package:tasknest/utils/helpers.dart';
import 'package:tasknest/widgets/custom_appbar.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'About TaskNest',
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildAppIcon(context),
            const SizedBox(height: 24),
            _buildAppInfo(),
            const SizedBox(height: 32),
            _buildFeatureList(),
            const SizedBox(height: 32),
            _buildContactInfo(context),
            const SizedBox(height: 32),
            _buildCredits(),
          ],
        ),
      ),
    );
  }

  Widget _buildAppIcon(BuildContext context) {
    final theme = Theme.of(context);
    final shadowColor = theme.brightness == Brightness.dark
        ? Colors.black.withAlpha(102) // 40% opacity in dark mode
        : Colors.black.withAlpha(51); // 20% opacity in light mode

    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.green.shade400,
            Colors.blue.shade400,
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const Icon(
        Icons.task_alt,
        size: 60,
        color: Colors.white,
      ),
    );
  }

  Widget _buildAppInfo() {
    return Column(
      children: [
        const Text(
          AppConstants.appName,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Version ${AppConstants.appVersion}',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          AppConstants.appDescription,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, height: 1.5),
        ),
      ],
    );
  }

  Widget _buildFeatureList() {
    final features = [
      '📝 Create and manage tasks with due dates and priorities',
      '🔄 Build habits with streak tracking and weekly goals',
      '🎨 Customizable categories with colors and icons',
      '🔔 Smart reminders and notifications',
      '📊 Detailed statistics and progress tracking',
      '🌙 Multiple themes (Light, Dark, High Contrast)',
      '📅 Calendar integration and daily view',
      '💾 Offline functionality with local storage',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Features',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ...features.map((feature) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      feature,
                      style: const TextStyle(fontSize: 16, height: 1.4),
                    ),
                  ),
                ],
              ),
            )),
      ],
    );
  }

  Widget _buildContactInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Contact & Support',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        _buildContactTile(
          icon: Icons.email,
          title: 'Email Support',
          subtitle: AppConstants.contactEmail,
          onTap: () => _launchEmail(context, subject: 'Support Inquiry'),
        ),
        _buildContactTile(
          icon: Icons.bug_report,
          title: 'Report a Bug',
          subtitle: 'Help us improve the app',
          onTap: () => _launchEmail(context, subject: 'Bug Report'),
        ),
        _buildContactTile(
          icon: Icons.lightbulb,
          title: 'Feature Request',
          subtitle: 'Suggest new features',
          onTap: () => _launchEmail(context, subject: 'Feature Request'),
        ),
      ],
    );
  }

  Widget _buildCredits() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Credits & Acknowledgments',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'TaskNest is built with Flutter and uses several open-source packages:',
          style: TextStyle(fontSize: 16, height: 1.5),
        ),
        const SizedBox(height: 12),
        _buildCreditItem('Flutter', 'Google LLC', 'https://flutter.dev'),
        _buildCreditItem(
            'sqflite', 'Tekartik', 'https://pub.dev/packages/sqflite'),
        _buildCreditItem(
            'provider', 'Remi Rousselet', 'https://pub.dev/packages/provider'),
        _buildCreditItem('table_calendar', 'Aleksander Woźniak',
            'https://pub.dev/packages/table_calendar'),
        _buildCreditItem(
            'fl_chart', 'Iman Khademi', 'https://pub.dev/packages/fl_chart'),
        _buildCreditItem('flutter_local_notifications', 'Michael Bui',
            'https://pub.dev/packages/flutter_local_notifications'),
        const SizedBox(height: 12),
        const Text(
          'Icons by Icons8 and Flaticon',
          style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
        ),
      ],
    );
  }

  Widget _buildContactTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, size: 24),
      title: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(vertical: 4),
      visualDensity: const VisualDensity(vertical: -2),
    );
  }

  Widget _buildCreditItem(String package, String author, String url) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: GestureDetector(
        onTap: () => _launchUrl(url),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(width: 8),
            const Text('• ', style: TextStyle(fontSize: 16)),
            Expanded(
              child: RichText(
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                    height: 1.4,
                  ),
                  children: [
                    TextSpan(
                      text: package,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    const TextSpan(text: ' by '),
                    TextSpan(
                      text: author,
                      style: TextStyle(color: Colors.grey.shade700),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchEmail(BuildContext context, {String subject = ''}) async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: AppConstants.contactEmail,
      queryParameters: {
        'subject': subject.isNotEmpty ? subject : 'TaskNest Support',
        'body': 'Hello TaskNest team,\n\nI would like to...',
      },
    );

    try {
      if (await canLaunchUrl(emailLaunchUri)) {
        await launchUrl(emailLaunchUri);
      } else {
        if (context.mounted) {
          Helpers.showSnackBar(
            context,
            'Could not launch email client. Please check your email app.',
            isError: true,
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        Helpers.showSnackBar(
          context,
          'Error launching email: ${e.toString()}',
          isError: true,
        );
      }
    }
  }

  Future<void> _launchUrl(String url) async {
    final Uri parsedUrl = Uri.parse(url);
    if (await canLaunchUrl(parsedUrl)) {
      await launchUrl(
        parsedUrl,
        mode: LaunchMode.externalApplication,
      );
    }
  }
}

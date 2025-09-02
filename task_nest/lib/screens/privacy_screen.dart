import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:tasknest/utils/constants.dart';
import 'package:tasknest/widgets/custom_appbar.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Privacy Policy',
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 24),
            _buildPrivacyContent(),
            const SizedBox(height: 32),
            _buildContactSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Privacy Policy',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Last updated: January 1, 2024',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildPrivacyContent() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PrivacySection(
          title: '1. Information We Collect',
          content:
              'TaskNest collects and stores the following information locally on your device:\n\n'
              '• Task details (title, description, due dates, categories)\n'
              '• Habit information and completion history\n'
              '• App preferences and settings\n'
              '• Notification preferences\n\n'
              'All data is stored locally on your device and is not transmitted to our servers.',
        ),
        SizedBox(height: 24),
        PrivacySection(
          title: '2. How We Use Your Information',
          content: 'We use the collected information to:\n\n'
              '• Provide and maintain the TaskNest service\n'
              '• Send you notifications and reminders\n'
              '• Personalize your experience with themes and settings\n'
              '• Generate statistics and insights about your productivity\n'
              '• Improve our app and develop new features',
        ),
        SizedBox(height: 24),
        PrivacySection(
          title: '3. Data Storage and Security',
          content:
              'Your data is stored locally on your device using SQLite database. '
              'We implement appropriate security measures to protect your personal information '
              'from unauthorized access, alteration, or disclosure.\n\n'
              'Since all data is stored locally, you have full control over your information. '
              'You can export or delete your data at any time through the app settings.',
        ),
        SizedBox(height: 24),
        PrivacySection(
          title: '4. Third-Party Services',
          content: 'TaskNest uses the following third-party services:\n\n'
              '• Google Play Services (for Android devices)\n'
              '• Apple App Store (for iOS devices)\n'
              '• Firebase (for crash reporting and analytics - optional)\n\n'
              'These services may collect information used to identify you. '
              'Please refer to their respective privacy policies.',
        ),
        SizedBox(height: 24),
        PrivacySection(
          title: '5. Your Data Rights',
          content: 'You have the right to:\n\n'
              '• Access all your personal data stored in the app\n'
              '• Export your data in a readable format\n'
              '• Delete all your data permanently\n'
              '• Opt-out of analytics and crash reporting\n'
              '• Control notification preferences\n\n'
              'All these options are available in the app settings.',
        ),
        SizedBox(height: 24),
        PrivacySection(
          title: '6. Children\'s Privacy',
          content:
              'TaskNest is not intended for use by children under the age of 13. '
              'We do not knowingly collect personal information from children under 13. '
              'If you are a parent or guardian and you are aware that your child has provided '
              'us with personal information, please contact us.',
        ),
        SizedBox(height: 24),
        PrivacySection(
          title: '7. Changes to This Policy',
          content: 'We may update our Privacy Policy from time to time. '
              'We will notify you of any changes by posting the new Privacy Policy on this page '
              'and updating the "Last updated" date.\n\n'
              'You are advised to review this Privacy Policy periodically for any changes. '
              'Changes to this Privacy Policy are effective when they are posted on this page.',
        ),
      ],
    );
  }

  Widget _buildContactSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Contact Us',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'If you have any questions about this Privacy Policy, please contact us:',
              style: TextStyle(height: 1.5),
            ),
            const SizedBox(height: 12),
            ListTile(
              leading: const Icon(Icons.email),
              title: const Text('Email'),
              subtitle: const Text(AppConstants.contactEmail),
              onTap: () => _launchEmail(),
            ),
            ListTile(
              leading: const Icon(Icons.language),
              title: const Text('Website'),
              subtitle: const Text('Visit our website for more information'),
              onTap: () => _launchUrl(AppConstants.privacyPolicyUrl),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchEmail() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: AppConstants.contactEmail,
      queryParameters: {
        'subject': 'Privacy Policy Inquiry',
        'body':
            'Hello TaskNest team,\n\nI have a question about your privacy policy:',
      },
    );

    if (await canLaunchUrl(emailLaunchUri)) {
      await launchUrl(emailLaunchUri);
    }
  }

  Future<void> _launchUrl(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    }
  }
}

class PrivacySection extends StatelessWidget {
  final String title;
  final String content;

  const PrivacySection({
    super.key,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: const TextStyle(
            fontSize: 16,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}

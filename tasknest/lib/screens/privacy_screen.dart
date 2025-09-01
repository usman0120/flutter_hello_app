import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:tasknest/utils/constants.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            _buildHeader(),
            const SizedBox(height: 24),

            // Last Updated
            _buildLastUpdated(),
            const SizedBox(height: 24),

            // Table of Contents
            _buildTableOfContents(),
            const SizedBox(height: 24),

            // Privacy Policy Content
            _buildPrivacyContent(),
            const SizedBox(height: 32),

            // Contact Information
            _buildContactSection(),
            const SizedBox(height: 32),

            // Agreement
            _buildAgreementSection(),
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
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Your privacy is important to us. This policy explains how we collect, use, and protect your personal information.',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildLastUpdated() {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(Icons.update, color: Colors.blue),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Last Updated',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    'January 15, 2024',
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTableOfContents() {
    final sections = [
      'Information We Collect',
      'How We Use Your Information',
      'Data Storage & Security',
      'Your Rights & Choices',
      'Third-Party Services',
      'Children\'s Privacy',
      'Changes to This Policy',
      'Contact Us'
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Table of Contents',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: sections.map((section) {
                return ActionChip(
                  label: Text(section),
                  onPressed: () => _scrollToSection(section),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrivacyContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildPolicySection(
          'Information We Collect',
          '''
We collect the following types of information to provide and improve our services:

• Personal Information: When you create an account, we collect your name and email address.
• Task Data: Information about your tasks, habits, reminders, and categories.
• Usage Data: How you interact with the app, including features used and time spent.
• Device Information: Device type, operating system, and app version for troubleshooting.
• Location Data: Optional location data for location-based reminders (only with your permission).
          ''',
        ),
        _buildPolicySection(
          'How We Use Your Information',
          '''
We use your information for the following purposes:

• Service Provision: To create and manage your tasks, habits, and reminders.
• Personalization: To customize your experience and provide relevant suggestions.
• Notifications: To send you reminders and important updates.
• Analytics: To improve our app and understand user behavior.
• Customer Support: To respond to your inquiries and provide support.
• Security: To protect your account and prevent unauthorized access.
          ''',
        ),
        _buildPolicySection(
          'Data Storage & Security',
          '''
We take your data security seriously:

• Encryption: All data is encrypted in transit and at rest.
• Secure Servers: Your data is stored on secure cloud servers with regular backups.
• Access Control: Strict access controls limit who can view your data.
• Data Retention: We retain your data only as long as necessary to provide our services.
• Deletion: You can request complete data deletion at any time.
          ''',
        ),
        _buildPolicySection(
          'Your Rights & Choices',
          '''
You have the following rights regarding your data:

• Access: You can access all your personal data through the app.
• Correction: You can update or correct your information at any time.
• Deletion: You can delete your account and all associated data.
• Export: You can export your data in standard formats.
• Opt-out: You can opt-out of non-essential communications.
• Cookies: You can manage cookie preferences in your device settings.
          ''',
        ),
        _buildPolicySection(
          'Third-Party Services',
          '''
We use the following third-party services:

• Google Analytics: For app usage analytics (anonymous data only).
• Firebase: For crash reporting and performance monitoring.
• Cloud Storage: For secure data storage and backup.
• Notification Services: For sending reminders and alerts.

All third-party services comply with strict data protection standards.
          ''',
        ),
        _buildPolicySection(
          'Children\'s Privacy',
          '''
Our app is not intended for children under 13:

• We do not knowingly collect data from children under 13.
• If we discover that a child under 13 has provided us with personal data, we immediately delete it.
• Parents can contact us to review or delete any data collected from their children.
          ''',
        ),
        _buildPolicySection(
          'Changes to This Policy',
          '''
We may update this policy from time to time:

• We will notify you of significant changes through the app or email.
• Continued use of the app after changes constitutes acceptance of the new policy.
• We encourage you to review this policy periodically.
          ''',
        ),
      ],
    );
  }

  Widget _buildPolicySection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          content.trim(),
          style: const TextStyle(
            fontSize: 14,
            height: 1.6,
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildContactSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
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
            const SizedBox(height: 16),
            _buildContactItem(
              Icons.email,
              'Email',
              AppConstants.supportEmail,
              () => _launchEmail(AppConstants.supportEmail),
            ),
            _buildContactItem(
              Icons.phone,
              'Phone',
              AppConstants.supportPhone,
              () => _launchPhone(AppConstants.supportPhone),
            ),
            _buildContactItem(
              Icons.language,
              'Website',
              'tasknest.com',
              () => _launchUrl(AppConstants.websiteUrl),
            ),
            const SizedBox(height: 16),
            const Text(
              'Support Hours: ${AppConstants.supportHours}',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactItem(
      IconData icon, String title, String value, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, size: 20),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(value),
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
    );
  }

  Widget _buildAgreementSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Your Agreement',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'By using TaskNest, you agree to the terms outlined in this Privacy Policy. '
          'If you do not agree with any part of this policy, please discontinue use of our app.',
          style: TextStyle(fontSize: 14, height: 1.6),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            const Icon(Icons.security, color: Colors.green, size: 20),
            const SizedBox(width: 8),
            Text(
              'GDPR Compliant • CCPA Ready • Privacy Shield Certified',
              style: TextStyle(
                fontSize: 12,
                color: Colors.green.shade700,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const Text(
          'This policy is compliant with major privacy regulations including GDPR, CCPA, '
          'and other international data protection laws.',
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }

  void _scrollToSection(String section) {
    // This would typically use ScrollController to scroll to specific sections
    // For simplicity, we'll show a snackbar
    ScaffoldMessenger.of(context as BuildContext).showSnackBar(
      SnackBar(content: Text('Scroll to: $section')),
    );
  }

  Future<void> _launchEmail(String email) async {
    final uri = Uri.parse('mailto:$email?subject=Privacy Policy Inquiry');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Future<void> _launchPhone(String phone) async {
    final uri = Uri.parse('tel:$phone');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}

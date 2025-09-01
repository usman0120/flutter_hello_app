import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:tasknest/utils/constants.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms & Conditions'),
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

            // Effective Date
            _buildEffectiveDate(),
            const SizedBox(height: 24),

            // Quick Navigation
            _buildQuickNavigation(context),
            const SizedBox(height: 24),

            // Terms Content
            _buildTermsContent(),
            const SizedBox(height: 32),

            // Acceptance Section
            _buildAcceptanceSection(),
            const SizedBox(height: 32),

            // Contact for Questions
            _buildContactSection(context),
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
          'Terms & Conditions',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Please read these terms carefully before using TaskNest. By using our app, you agree to be bound by these terms.',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildEffectiveDate() {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(Icons.calendar_today, color: Colors.blue),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Effective Date',
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

  Widget _buildQuickNavigation(BuildContext context) {
    final sections = [
      'Acceptance of Terms',
      'Account Registration',
      'User Responsibilities',
      'Intellectual Property',
      'Prohibited Activities',
      'Termination',
      'Limitation of Liability',
      'Governing Law'
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Quick Navigation',
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
                  onPressed: () => _scrollToSection(context, section),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTermsContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTermSection(
          '1. Acceptance of Terms',
          '''
By downloading, installing, or using TaskNest ("the App"), you agree to be bound by these Terms and Conditions. If you do not agree to these terms, please do not use the App.

These terms constitute a legal agreement between you and TaskNest. We reserve the right to modify these terms at any time, and such modifications will be effective immediately upon posting.
          ''',
        ),
        _buildTermSection(
          '2. Account Registration',
          '''
To use certain features of the App, you may need to register for an account. You agree to:

• Provide accurate, current, and complete information during registration
• Maintain and promptly update your account information
• Maintain the security of your password and accept all risks of unauthorized access
• Notify us immediately of any unauthorized use of your account

You must be at least 13 years old to use the App. If you are under 18, you must have parental consent.
          ''',
        ),
        _buildTermSection(
          '3. User Responsibilities',
          '''
As a user of TaskNest, you agree to:

• Use the App only for lawful purposes
• Not upload or share harmful or offensive content
• Not attempt to disrupt or interfere with the App's functionality
• Not use the App to violate any laws or regulations
• Respect the intellectual property rights of others

You are solely responsible for the content you create and store using the App.
          ''',
        ),
        _buildTermSection(
          '4. Intellectual Property',
          '''
The App and its original content, features, and functionality are owned by TaskNest and are protected by international copyright, trademark, and other intellectual property laws.

You are granted a limited, non-exclusive, non-transferable license to use the App for personal, non-commercial purposes. This license does not include:
• The right to resell or commercialize the App
• The right to modify or create derivative works
• The right to reverse engineer or decompile the App
          ''',
        ),
        _buildTermSection(
          '5. Prohibited Activities',
          '''
You may not use the App to:

• Violate any applicable laws or regulations
• Harass, abuse, or harm another person
• Send spam or unauthorized commercial communications
• Upload viruses or malicious code
• Collect or track personal information of others
• Impersonate another person or entity
• Interfere with or disrupt the App's servers or networks

We reserve the right to investigate and prosecute violations of these terms to the fullest extent of the law.
          ''',
        ),
        _buildTermSection(
          '6. Termination',
          '''
We may terminate or suspend your account immediately, without prior notice or liability, for any reason whatsoever, including without limitation if you breach the Terms.

Upon termination, your right to use the App will immediately cease. If you wish to terminate your account, you may simply discontinue using the App or delete your account through the app settings.
          ''',
        ),
        _buildTermSection(
          '7. Limitation of Liability',
          '''
In no event shall TaskNest, nor its directors, employees, partners, agents, suppliers, or affiliates, be liable for any indirect, incidental, special, consequential or punitive damages, including without limitation, loss of profits, data, use, goodwill, or other intangible losses, resulting from:

• Your access to or use of or inability to access or use the App
• Any conduct or content of any third party on the App
• Any unauthorized access to or use of our servers and/or any personal information stored therein
• Any interruption or cessation of transmission to or from the App
• Any bugs, viruses, Trojan horses, or the like that may be transmitted to or through the App
          ''',
        ),
        _buildTermSection(
          '8. Governing Law',
          '''
These Terms shall be governed and construed in accordance with the laws, without regard to its conflict of law provisions.

Our failure to enforce any right or provision of these Terms will not be considered a waiver of those rights. If any provision of these Terms is held to be invalid or unenforceable by a court, the remaining provisions of these Terms will remain in effect.
          ''',
        ),
        _buildTermSection(
          '9. Changes to Terms',
          '''
We reserve the right, at our sole discretion, to modify or replace these Terms at any time. If a revision is material, we will provide at least 30 days' notice prior to any new terms taking effect.

What constitutes a material change will be determined at our sole discretion. By continuing to access or use our App after any revisions become effective, you agree to be bound by the revised terms.
          ''',
        ),
        _buildTermSection(
          '10. Contact Information',
          '''
If you have any questions about these Terms, please contact us at:

Email: ${AppConstants.supportEmail}
Website: ${AppConstants.websiteUrl}
Phone: ${AppConstants.supportPhone}

We will respond to all legitimate inquiries within a reasonable time frame.
          ''',
        ),
      ],
    );
  }

  Widget _buildTermSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        const SizedBox(height: 8),
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

  Widget _buildAcceptanceSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Your Acceptance',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'By using TaskNest, you acknowledge that you have read, understood, and agree to be bound by these Terms and Conditions. '
              'You also agree to our Privacy Policy and any other policies referenced herein.',
              style: TextStyle(fontSize: 14, height: 1.6),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                children: [
                  Icon(Icons.warning_amber, color: Colors.orange),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'If you do not agree to these terms, you must immediately stop using the App and delete your account.',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Questions About These Terms?',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'If you have any questions or concerns about these Terms and Conditions, please don\'t hesitate to contact our support team.',
          style: TextStyle(fontSize: 14, height: 1.6),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            ElevatedButton(
              onPressed: () => _launchEmail(AppConstants.supportEmail),
              child: const Text('Email Support'),
            ),
            const SizedBox(width: 12),
            OutlinedButton(
              onPressed: () => _launchUrl(AppConstants.websiteUrl),
              child: const Text('Visit Website'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const Text(
          'We typically respond to all inquiries within 24-48 hours during business days.',
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }

  void _scrollToSection(BuildContext context, String section) {
    // This would typically use ScrollController to scroll to specific sections
    // For simplicity, we'll show a snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Scroll to: $section')),
    );
  }

  Future<void> _launchEmail(String email) async {
    final uri = Uri.parse('mailto:$email?subject=Terms and Conditions Inquiry');
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

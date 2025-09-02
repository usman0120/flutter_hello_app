import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:tasknest/utils/constants.dart';
import 'package:tasknest/widgets/custom_appbar.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Terms & Conditions',
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 24),
            _buildTermsContent(),
            const SizedBox(height: 32),
            _buildAcceptanceSection(),
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
          'Terms and Conditions',
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

  Widget _buildTermsContent() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TermsSection(
          title: '1. Acceptance of Terms',
          content:
              'By downloading, installing, or using TaskNest ("the App"), you agree to be bound by these Terms and Conditions. '
              'If you do not agree to these terms, please do not use the App.',
        ),
        SizedBox(height: 24),
        TermsSection(
          title: '2. Description of Service',
          content: 'TaskNest is a productivity application that provides:\n\n'
              '• Task management and organization\n'
              '• Habit tracking and streak monitoring\n'
              '• Calendar integration\n'
              '• Progress statistics and analytics\n'
              '• Local notifications and reminders\n\n'
              'The App is provided "as is" and we reserve the right to modify or discontinue the service at any time.',
        ),
        SizedBox(height: 24),
        TermsSection(
          title: '3. User Accounts',
          content:
              'TaskNest operates primarily as a local application. While no account creation is required for basic functionality, '
              'certain features may require optional account creation in the future. You are responsible for:\n\n'
              '• Maintaining the confidentiality of any account information\n'
              '• All activities that occur under your account\n'
              '• Ensuring that you exit from your account at the end of each session',
        ),
        SizedBox(height: 24),
        TermsSection(
          title: '4. User Responsibilities',
          content: 'As a user of TaskNest, you agree to:\n\n'
              '• Use the App only for lawful purposes\n'
              '• Not attempt to reverse engineer or modify the App\n'
              '• Not use the App to store illegal or harmful content\n'
              '• Maintain backup copies of your important data\n'
              '• Keep your device secure to protect your data',
        ),
        SizedBox(height: 24),
        TermsSection(
          title: '5. Intellectual Property',
          content:
              'The TaskNest application, including all source code, databases, functionality, software, website designs, audio, '
              'video, text, photographs, and graphics, are owned by us and are protected by copyright and trademark laws.\n\n'
              'You are granted a limited license to use the App for personal, non-commercial purposes. '
              'You may not copy, reproduce, distribute, or create derivative works without explicit permission.',
        ),
        SizedBox(height: 24),
        TermsSection(
          title: '6. Data and Privacy',
          content:
              'Your use of TaskNest is subject to our Privacy Policy. Please review our Privacy Policy, which also governs the App '
              'and informs users of our data collection practices.\n\n'
              'We store your data locally on your device. It is your responsibility to maintain backups and protect your device.',
        ),
        SizedBox(height: 24),
        TermsSection(
          title: '7. Limitation of Liability',
          content:
              'To the fullest extent permitted by law, we shall not be liable for any indirect, incidental, special, '
              'consequential, or punitive damages, including but not limited to:\n\n'
              '• Loss of profits, data, or use\n'
              '• Business interruption\n'
              '• Device damage or data loss\n'
              '• Any other commercial damages or losses\n\n'
              'Your sole remedy for dissatisfaction with the App is to stop using it.',
        ),
        SizedBox(height: 24),
        TermsSection(
          title: '8. Disclaimer of Warranties',
          content:
              'The App is provided "as is" and "as available" without any warranties of any kind, either express or implied. '
              'We do not warrant that:\n\n'
              '• The App will meet your specific requirements\n'
              '• The App will be uninterrupted, timely, secure, or error-free\n'
              '• The results that may be obtained from the use of the App will be accurate or reliable\n'
              '• Any errors in the App will be corrected',
        ),
        SizedBox(height: 24),
        TermsSection(
          title: '9. Changes to Terms',
          content:
              'We reserve the right, at our sole discretion, to modify or replace these Terms at any time. '
              'If a revision is material, we will provide at least 30 days\' notice prior to any new terms taking effect. '
              'What constitutes a material change will be determined at our sole discretion.\n\n'
              'By continuing to access or use our App after any revisions become effective, you agree to be bound by the revised terms.',
        ),
        SizedBox(height: 24),
        TermsSection(
          title: '10. Governing Law',
          content:
              'These Terms shall be governed and construed in accordance with the laws, without regard to its conflict of law provisions.\n\n'
              'Our failure to enforce any right or provision of these Terms will not be considered a waiver of those rights. '
              'If any provision of these Terms is held to be invalid or unenforceable by a court, the remaining provisions will remain in effect.',
        ),
        SizedBox(height: 24),
        TermsSection(
          title: '11. Contact Information',
          content:
              'If you have any questions about these Terms, please contact us at:\n\n'
              'Email: ${AppConstants.contactEmail}\n'
              'We will respond to your inquiry within a reasonable timeframe.',
        ),
      ],
    );
  }

  Widget _buildAcceptanceSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
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
              'By using TaskNest, you signify your acceptance of these terms and conditions. '
              'If you do not agree to these terms, please do not use our application.',
              style: TextStyle(height: 1.5),
            ),
            const SizedBox(height: 16),
            const Text(
              'Continued use of the App following the posting of changes to these terms will be deemed your acceptance of those changes.',
              style: TextStyle(
                fontStyle: FontStyle.italic,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: () => _launchFullTerms(),
                child: const Text('View Full Terms Online'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchFullTerms() async {
    if (await canLaunchUrl(Uri.parse(AppConstants.termsOfServiceUrl))) {
      await launchUrl(Uri.parse(AppConstants.termsOfServiceUrl));
    }
  }
}

class TermsSection extends StatelessWidget {
  final String title;
  final String content;

  const TermsSection({
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

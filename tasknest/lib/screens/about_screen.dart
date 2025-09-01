import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:tasknest/utils/constants.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About TaskNest'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // App Icon and Name
            _buildAppHeader(),
            const SizedBox(height: 32),

            // App Description
            _buildAppDescription(),
            const SizedBox(height: 32),

            // Features
            _buildFeaturesSection(),
            const SizedBox(height: 32),

            // Development Team
            _buildTeamSection(),
            const SizedBox(height: 32),

            // Social Media Links
            _buildSocialMediaSection(),
            const SizedBox(height: 32),

            // App Statistics
            _buildStatisticsSection(),
            const SizedBox(height: 32),

            // Credits
            _buildCreditsSection(),
            const SizedBox(height: 32),

            // Copyright
            _buildCopyrightSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildAppHeader() {
    return Column(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.blue.shade400,
                Colors.blue.shade600,
              ],
            ),
          ),
          child: const Icon(
            Icons.task_alt,
            size: 60,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          AppConstants.appName,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Version ${AppConstants.appVersion}',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildAppDescription() {
    return const Column(
      children: [
        Text(
          AppConstants.appDescription,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            height: 1.5,
          ),
        ),
        SizedBox(height: 16),
        Text(
          'TaskNest helps you organize your tasks, build healthy habits, '
          'and achieve your goals with intuitive features and beautiful design.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey,
            height: 1.4,
          ),
        ),
      ],
    );
  }

  Widget _buildFeaturesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Features',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.5,
          children: [
            _buildFeatureItem(Icons.task, 'Task Management',
                'Create and organize tasks with categories and priorities'),
            _buildFeatureItem(Icons.auto_awesome, 'Habit Tracking',
                'Build and maintain healthy habits with streak tracking'),
            _buildFeatureItem(Icons.notifications, 'Smart Reminders',
                'Get timely notifications for tasks and habits'),
            _buildFeatureItem(Icons.analytics, 'Progress Analytics',
                'Track your productivity with detailed statistics'),
            _buildFeatureItem(Icons.calendar_today, 'Calendar View',
                'Visualize your schedule with integrated calendar'),
            _buildFeatureItem(Icons.palette, 'Custom Themes',
                'Personalize the app with multiple theme options'),
          ],
        ),
      ],
    );
  }

  Widget _buildFeatureItem(IconData icon, String title, String description) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 24, color: Colors.blue),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 10,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Development Team',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        _buildTeamMember(
          'John Doe',
          'Lead Developer',
          'john.doe@tasknest.com',
          Icons.code,
        ),
        _buildTeamMember(
          'Jane Smith',
          'UI/UX Designer',
          'jane.smith@tasknest.com',
          Icons.design_services,
        ),
        _buildTeamMember(
          'Mike Johnson',
          'Product Manager',
          'mike.johnson@tasknest.com',
          Icons.manage_accounts,
        ),
      ],
    );
  }

  Widget _buildTeamMember(
      String name, String role, String email, IconData icon) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.blue.shade100,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 20, color: Colors.blue),
      ),
      title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(role),
      trailing: IconButton(
        icon: const Icon(Icons.email, size: 20),
        onPressed: () => _launchEmail(email),
      ),
    );
  }

  Widget _buildSocialMediaSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Follow Us',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildSocialButton(
                Icons.facebook, 'Facebook', AppConstants.facebookUrl),
            _buildSocialButton(
                Icons.camera_alt, 'Instagram', AppConstants.instagramUrl),
            _buildSocialButton(Icons.link, 'Twitter', AppConstants.twitterUrl),
            _buildSocialButton(
                Icons.language, 'Website', AppConstants.websiteUrl),
          ],
        ),
      ],
    );
  }

  Widget _buildSocialButton(IconData icon, String label, String url) {
    return Column(
      children: [
        IconButton(
          icon: Icon(icon, size: 30),
          onPressed: () => _launchUrl(url),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildStatisticsSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              'App Statistics',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem('100K+', 'Downloads'),
                _buildStatItem('4.8', 'Rating'),
                _buildStatItem('95%', 'Satisfaction'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildCreditsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Credits & Acknowledgments',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        _buildCreditItem('Flutter', 'Google LLC', 'UI Framework'),
        _buildCreditItem('Icons8', 'Icons8 Team', 'Icons and Stickers'),
        _buildCreditItem('Flaticon', 'Flaticon Community', 'Additional Icons'),
        _buildCreditItem('Unsplash', 'Various Artists', 'Background Images'),
      ],
    );
  }

  Widget _buildCreditItem(String name, String by, String forWhat) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const Icon(Icons.attribution, size: 20),
      title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text('$forWhat by $by'),
    );
  }

  Widget _buildCopyrightSection() {
    return const Column(
      children: [
        Text(
          '© 2024 TaskNest. All rights reserved.',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Made with ❤️ for productivity enthusiasts',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Future<void> _launchEmail(String email) async {
    final uri = Uri.parse('mailto:$email');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}

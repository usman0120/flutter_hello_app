// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasknest/services/theme_service.dart';
import 'package:tasknest/utils/constants.dart';
import 'package:tasknest/widgets/theme_switcher.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final List<Widget>? actions;
  final bool centerTitle;
  final double elevation;
  final bool automaticallyImplyLeading;
  final Widget? leading;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? titleSpacing;
  final bool showThemeSwitcher;
  final bool showNotificationBadge;
  final int notificationCount;

  const CustomAppBar({
    super.key,
    required this.title,
    this.showBackButton = true,
    this.actions,
    this.centerTitle = true,
    this.elevation = 0,
    this.automaticallyImplyLeading = true,
    this.leading,
    this.backgroundColor,
    this.foregroundColor,
    this.titleSpacing,
    this.showThemeSwitcher = false,
    this.showNotificationBadge = false,
    this.notificationCount = 0,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeService = Provider.of<ThemeService>(context);

    return AppBar(
      title: Text(
        title,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: foregroundColor ?? theme.colorScheme.onPrimary,
        ),
      ),
      leading: _buildLeading(context),
      automaticallyImplyLeading: automaticallyImplyLeading,
      centerTitle: centerTitle,
      elevation: elevation,
      backgroundColor: backgroundColor ?? theme.appBarTheme.backgroundColor,
      foregroundColor: foregroundColor ?? theme.appBarTheme.foregroundColor,
      titleSpacing: titleSpacing,
      actions: _buildActions(context, themeService),
      flexibleSpace: _buildGradientBackground(theme),
      shape: _buildAppBarShape(),
    );
  }

  Widget? _buildLeading(BuildContext context) {
    if (leading != null) return leading;

    if (showBackButton && Navigator.canPop(context)) {
      return IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.pop(context),
        tooltip: 'Back',
      );
    }

    return null;
  }

  List<Widget> _buildActions(BuildContext context, ThemeService themeService) {
    final actionsList = <Widget>[];

    // Add notification icon if enabled
    if (showNotificationBadge) {
      actionsList.add(
        _buildNotificationButton(context),
      );
    }

    // Add theme switcher if enabled
    if (showThemeSwitcher) {
      actionsList.add(
        IconButton(
          icon: const Icon(Icons.color_lens),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => const ThemeSwitcherDialog(),
            );
          },
          tooltip: 'Change theme',
        ),
      );
    }

    // Add quick theme toggle
    actionsList.add(
      IconButton(
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
        tooltip: 'Toggle theme',
      ),
    );

    // Add custom actions
    if (actions != null) {
      actionsList.addAll(actions!);
    }

    return actionsList;
  }

  Widget _buildNotificationButton(BuildContext context) {
    return Stack(
      children: [
        IconButton(
          icon: const Icon(Icons.notifications),
          onPressed: () {
            // Handle notification tap
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Notifications screen coming soon')),
            );
          },
          tooltip: 'Notifications',
        ),
        if (notificationCount > 0)
          Positioned(
            right: 8,
            top: 8,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(6),
              ),
              constraints: const BoxConstraints(
                minWidth: 12,
                minHeight: 12,
              ),
              child: Text(
                notificationCount > 9 ? '9+' : notificationCount.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 8,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }

  Widget? _buildGradientBackground(ThemeData theme) {
    if (backgroundColor != null) return null;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.primaryColor,
            // ignore: duplicate_ignore
            // ignore: deprecated_member_use
            theme.primaryColor.withOpacity(0.8),
          ],
        ),
      ),
    );
  }

  ShapeBorder? _buildAppBarShape() {
    return const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(16),
        bottomRight: Radius.circular(16),
      ),
    );
  }
}

// Specialized app bars for different screens

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final int notificationCount;
  final VoidCallback? onProfileTap;

  const HomeAppBar({
    super.key,
    this.notificationCount = 0,
    this.onProfileTap,
  });

  @override
  Size get preferredSize =>
      const Size.fromHeight(kToolbarHeight + 20); // Taller app bar

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).primaryColor.withOpacity(0.8),
          ],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 40, 16, 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // App logo and name
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.task_alt,
                    color: Colors.blue,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  AppConstants.appName,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),

            // Right side actions
            Row(
              children: [
                _buildNotificationButton(),
                const SizedBox(width: 12),
                _buildProfileButton(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationButton() {
    return Stack(
      children: [
        IconButton(
          icon: const Icon(Icons.notifications, color: Colors.white, size: 24),
          onPressed: () {
            // Handle notification tap
          },
        ),
        if (notificationCount > 0)
          Positioned(
            right: 8,
            top: 8,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(6),
              ),
              constraints: const BoxConstraints(
                minWidth: 16,
                minHeight: 16,
              ),
              child: Text(
                notificationCount > 9 ? '9+' : notificationCount.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildProfileButton() {
    return GestureDetector(
      onTap: onProfileTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.3)),
        ),
        child: const Icon(
          Icons.person,
          color: Colors.white,
          size: 20,
        ),
      ),
    );
  }
}

class SearchAppBar extends StatelessWidget implements PreferredSizeWidget {
  final TextEditingController controller;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onCancel;
  final String hintText;

  const SearchAppBar({
    super.key,
    required this.controller,
    required this.onSearchChanged,
    required this.onCancel,
    this.hintText = 'Search tasks...',
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: TextField(
        controller: controller,
        onChanged: onSearchChanged,
        decoration: InputDecoration(
          hintText: hintText,
          border: InputBorder.none,
          hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
        ),
        style: const TextStyle(color: Colors.white),
        cursorColor: Colors.white,
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        if (controller.text.isNotEmpty)
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              controller.clear();
              onSearchChanged('');
            },
          ),
      ],
      backgroundColor: Theme.of(context).primaryColor,
      foregroundColor: Colors.white,
    );
  }
}

class TransparentAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final List<Widget>? actions;
  final Color? backgroundColor;

  const TransparentAppBar({
    super.key,
    required this.title,
    this.showBackButton = true,
    this.actions,
    this.backgroundColor,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      leading: showBackButton && Navigator.canPop(context)
          ? IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            )
          : null,
      actions: actions,
      backgroundColor: backgroundColor ?? Colors.transparent,
      elevation: 0,
      foregroundColor: Colors.white,
    );
  }
}

// App bar with tabs
class TabbedAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget> tabs;
  final TabController? tabController;
  final bool isScrollable;

  const TabbedAppBar({
    super.key,
    required this.title,
    required this.tabs,
    this.tabController,
    this.isScrollable = false,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight * 2);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      bottom: TabBar(
        controller: tabController,
        tabs: tabs,
        isScrollable: isScrollable,
        indicatorColor: Colors.white,
        labelStyle: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}

// App bar with progress indicator
class ProgressAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final double progress;
  final Color? progressColor;

  const ProgressAppBar({
    super.key,
    required this.title,
    required this.progress,
    this.progressColor,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 4);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(4),
        child: LinearProgressIndicator(
          value: progress,
          backgroundColor: Colors.transparent,
          color: progressColor ?? Theme.of(context).primaryColor,
          minHeight: 4,
        ),
      ),
    );
  }
}

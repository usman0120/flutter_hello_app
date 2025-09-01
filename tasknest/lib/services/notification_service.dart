import 'dart:typed_data';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter/material.dart';
import 'package:tasknest/models/task_model.dart';
import 'package:tasknest/models/habit_model.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Initialize notifications
  Future<void> init() async {
    // Initialize timezone database
    tz.initializeTimeZones();

    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosInitializationSettings =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      notificationCategories: [
        DarwinNotificationCategory(
          'task_reminders',
          actions: <DarwinNotificationAction>[
            DarwinNotificationAction.plain('complete', 'Complete'),
            DarwinNotificationAction.plain('snooze', 'Snooze'),
          ],
        ),
        DarwinNotificationCategory(
          'habit_reminders',
          actions: <DarwinNotificationAction>[
            DarwinNotificationAction.plain('complete', 'Complete'),
            DarwinNotificationAction.plain('snooze', 'Snooze'),
          ],
        ),
      ],
    );

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings,
    );

    await _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // Handle notification tap
        debugPrint('Notification tapped: ${response.payload}');
        _handleNotificationResponse(response);
      },
      onDidReceiveBackgroundNotificationResponse:
          (NotificationResponse response) {
        // Handle background notification tap
        debugPrint('Background notification tapped: ${response.payload}');
        _handleNotificationResponse(response);
      },
    );

    // Create notification channels
    await _createNotificationChannels();
  }

  // Create notification channels
  Future<void> _createNotificationChannels() async {
    const AndroidNotificationChannel taskChannel = AndroidNotificationChannel(
      'task_reminders',
      'Task Reminders',
      description: 'Notifications for task reminders',
      importance: Importance.high,
    );

    const AndroidNotificationChannel habitChannel = AndroidNotificationChannel(
      'habit_reminders',
      'Habit Reminders',
      description: 'Notifications for habit reminders',
      importance: Importance.high,
    );

    const AndroidNotificationChannel generalChannel =
        AndroidNotificationChannel(
      'general_notifications',
      'General Notifications',
      description: 'General app notifications',
      importance: Importance.defaultImportance,
    );

    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(taskChannel);

    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(habitChannel);

    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(generalChannel);
  }

  // Android notification details
  NotificationDetails _androidNotificationDetails(
      String channelId, String channelName) {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        channelId,
        channelName,
        channelDescription: 'Notifications for $channelName',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker',
        enableVibration: true,
        vibrationPattern: Int64List.fromList([0, 250, 250, 250]),
        playSound: true,
        category: AndroidNotificationCategory.reminder,
      ),
      iOS: const DarwinNotificationDetails(
        categoryIdentifier: channelId,
      ),
    );
  }

  // iOS notification details
  NotificationDetails _iosNotificationDetails({String category = 'general'}) {
    return NotificationDetails(
      iOS: DarwinNotificationDetails(
        categoryIdentifier: category,
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );
  }

  // Schedule task reminder notification
  Future<void> scheduleTaskReminder(Task task) async {
    if (task.reminderDate == null || !task.hasReminder) return;

    final tz.TZDateTime scheduledDate = tz.TZDateTime.from(
      task.reminderDate!,
      tz.local,
    );

    // Check if the notification is in the future
    if (scheduledDate.isBefore(tz.TZDateTime.now(tz.local))) {
      return;
    }

    await _notificationsPlugin.zonedSchedule(
      task.id! + 1000, // Unique ID for notification
      'Task Reminder: ${task.title}',
      task.description.isNotEmpty
          ? task.description
          : 'Due: ${_formatDate(task.dueDate)}',
      scheduledDate,
      _androidNotificationDetails('task_reminders', 'Task Reminders'),
      payload: 'task_${task.id}',
    );
  }

  // Schedule habit reminder notification
  Future<void> scheduleHabitReminder(Habit habit) async {
    if (habit.reminderTime == null || !habit.hasReminder) return;

    final now = DateTime.now();
    var scheduledTime = DateTime(
      now.year,
      now.month,
      now.day,
      habit.reminderTime!.hour,
      habit.reminderTime!.minute,
    );

    // If the time has already passed today, schedule for tomorrow
    if (scheduledTime.isBefore(now)) {
      scheduledTime = scheduledTime.add(const Duration(days: 1));
    }

    final tz.TZDateTime scheduledDate =
        tz.TZDateTime.from(scheduledTime, tz.local);

    await _notificationsPlugin.zonedSchedule(
      habit.id! + 2000, // Unique ID for notification
      'Habit Reminder: ${habit.title}',
      'Time to complete your habit!',
      scheduledDate,
      _androidNotificationDetails('habit_reminders', 'Habit Reminders'),
      payload: 'habit_${habit.id}',
    );
  }

  // Schedule repeating habit reminder
  Future<void> scheduleRepeatingHabitReminder(Habit habit) async {
    if (habit.reminderTime == null || !habit.hasReminder) return;

    final now = DateTime.now();
    var scheduledTime = DateTime(
      now.year,
      now.month,
      now.day,
      habit.reminderTime!.hour,
      habit.reminderTime!.minute,
    );

    // If the time has already passed today, schedule for tomorrow
    if (scheduledTime.isBefore(now)) {
      scheduledTime = scheduledTime.add(const Duration(days: 1));
    }

    final tz.TZDateTime scheduledDate =
        tz.TZDateTime.from(scheduledTime, tz.local);

    // For repeating notifications, we need to use a different approach
    // since zonedSchedule doesn't support exact repeating in the new API
    await _scheduleDailyHabitReminder(habit, scheduledDate);
  }

  // Helper method for daily habit reminders
  Future<void> _scheduleDailyHabitReminder(
      Habit habit, tz.TZDateTime firstDate) async {
    await _notificationsPlugin.zonedSchedule(
      habit.id! + 3000, // Unique ID for repeating notification
      'Daily Habit Reminder: ${habit.title}',
      'Don\'t forget to complete your habit today!',
      firstDate,
      _androidNotificationDetails('habit_reminders', 'Habit Reminders'),
      payload: 'habit_repeat_${habit.id}',
    );
  }

  // Cancel task reminder
  Future<void> cancelTaskReminder(int taskId) async {
    await _notificationsPlugin.cancel(taskId + 1000);
  }

  // Cancel habit reminder
  Future<void> cancelHabitReminder(int habitId) async {
    await _notificationsPlugin.cancel(habitId + 2000);
    await _notificationsPlugin
        .cancel(habitId + 3000); // Cancel repeating reminder too
  }

  // Show immediate notification
  Future<void> showInstantNotification(
      String title, String body, String payload) async {
    await _notificationsPlugin.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      _androidNotificationDetails(
          'general_notifications', 'General Notifications'),
      payload: payload,
    );
  }

  // Handle notification response
  void _handleNotificationResponse(NotificationResponse response) {
    final String? payload = response.payload;
    if (payload != null) {
      debugPrint('Notification payload: $payload');

      // Handle different notification types
      if (payload.startsWith('task_')) {
        _handleTaskNotification(payload);
      } else if (payload.startsWith('habit_')) {
        _handleHabitNotification(payload);
      }
    }
  }

  void _handleTaskNotification(String payload) {
    // Extract task ID from payload and handle the notification
    final taskId = int.tryParse(payload.replaceAll('task_', ''));
    if (taskId != null) {
      debugPrint('Task notification handled for task ID: $taskId');
      // You can add navigation logic here
    }
  }

  void _handleHabitNotification(String payload) {
    // Extract habit ID from payload and handle the notification
    final habitId = int.tryParse(
        payload.replaceAll('habit_', '').replaceAll('_repeat', ''));
    if (habitId != null) {
      debugPrint('Habit notification handled for habit ID: $habitId');
      // You can add habit completion logic here
    }
  }

  // Format date for notification
  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  // Check notification permissions
  Future<bool> checkPermissions() async {
    final bool? androidResult = await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.areNotificationsEnabled();

    final bool? iosResult = await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.getNotificationSettings()
        .then((settings) =>
            settings.authorizationStatus == AuthorizationStatus.authorized);

    return androidResult ?? iosResult ?? false;
  }

  // Request notification permissions
  Future<void> requestPermissions() async {
    // Android doesn't require permission request for notifications
    // iOS requires permission request
    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
          critical: true,
        );
  }

  // Cancel all notifications
  Future<void> cancelAllNotifications() async {
    await _notificationsPlugin.cancelAll();
  }

  // Get pending notifications
  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await _notificationsPlugin.pendingNotificationRequests();
  }

  // Check if notifications are enabled
  Future<bool> areNotificationsEnabled() async {
    final NotificationAppLaunchDetails? details =
        await _notificationsPlugin.getNotificationAppLaunchDetails();
    return details?.didNotificationLaunchApp ?? false;
  }

  // Get notification settings
  Future<NotificationSettings> getNotificationSettings() async {
    return await _notificationsPlugin.getNotificationSettings();
  }

  // Schedule multiple notifications
  Future<void> scheduleMultipleNotifications(List<Task> tasks) async {
    for (final task in tasks) {
      if (task.hasReminder && task.reminderDate != null) {
        await scheduleTaskReminder(task);
      }
    }
  }

  // Reschedule all notifications (useful after app updates)
  Future<void> rescheduleAllNotifications(
      List<Task> tasks, List<Habit> habits) async {
    // Cancel all existing notifications
    await cancelAllNotifications();

    // Schedule task notifications
    for (final task in tasks) {
      if (task.hasReminder && task.reminderDate != null) {
        await scheduleTaskReminder(task);
      }
    }

    // Schedule habit notifications
    for (final habit in habits) {
      if (habit.hasReminder && habit.reminderTime != null) {
        await scheduleHabitReminder(habit);
        await scheduleRepeatingHabitReminder(habit);
      }
    }
  }

  // Show progress notification
  Future<void> showProgressNotification(
    String title,
    String body,
    int progress,
    int maxProgress,
    String channelId,
    String channelName,
  ) async {
    await _notificationsPlugin.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channelId,
          channelName,
          channelDescription: 'Progress notifications',
          importance: Importance.low,
          priority: Priority.low,
          showProgress: true,
          maxProgress: maxProgress,
          progress: progress,
          onlyAlertOnce: true,
        ),
      ),
    );
  }

  // Update progress notification
  Future<void> updateProgressNotification(
    int id,
    String title,
    String body,
    int progress,
    int maxProgress,
    String channelId,
    String channelName,
  ) async {
    await _notificationsPlugin.show(
      id,
      title,
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channelId,
          channelName,
          channelDescription: 'Progress notifications',
          importance: Importance.low,
          priority: Priority.low,
          showProgress: true,
          maxProgress: maxProgress,
          progress: progress,
          onlyAlertOnce: true,
        ),
      ),
    );
  }
}

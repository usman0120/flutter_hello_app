class Habit {
  int? id;
  String title;
  String description;
  int targetFrequency; // times per week
  int currentStreak;
  int completedCount;
  List<bool> completionDays; // Track completion for each day of the week
  String category;
  String colorCode;
  DateTime startDate;
  DateTime? lastCompleted;
  int reminderId;
  bool hasReminder;

  Habit({
    this.id,
    required this.title,
    this.description = '',
    required this.targetFrequency,
    this.currentStreak = 0,
    this.completedCount = 0,
    required this.completionDays,
    this.category = 'Personal',
    this.colorCode = '0xFF2196F3',
    required this.startDate,
    this.lastCompleted,
    this.reminderId = -1,
    this.hasReminder = false,
  });

  double get completionRate {
    if (completedCount == 0) return 0.0;
    final daysSinceStart = DateTime.now().difference(startDate).inDays;
    if (daysSinceStart == 0) return 0.0;
    return (completedCount / (targetFrequency * (daysSinceStart / 7)))
        .clamp(0.0, 1.0);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'targetFrequency': targetFrequency,
      'currentStreak': currentStreak,
      'completedCount': completedCount,
      'completionDays': completionDays.map((day) => day ? '1' : '0').join(''),
      'category': category,
      'colorCode': colorCode,
      'startDate': startDate.millisecondsSinceEpoch,
      'lastCompleted': lastCompleted?.millisecondsSinceEpoch,
      'reminderId': reminderId,
      'hasReminder': hasReminder ? 1 : 0,
    };
  }

  factory Habit.fromMap(Map<String, dynamic> map) {
    final completionDaysString = map['completionDays'].toString();
    final completionDays =
        completionDaysString.split('').map((e) => e == '1').toList();

    // Ensure we have exactly 7 days
    while (completionDays.length < 7) {
      completionDays.add(false);
    }
    while (completionDays.length > 7) {
      completionDays.removeLast();
    }

    return Habit(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      targetFrequency: map['targetFrequency'],
      currentStreak: map['currentStreak'],
      completedCount: map['completedCount'],
      completionDays: completionDays,
      category: map['category'],
      colorCode: map['colorCode'],
      startDate: DateTime.fromMillisecondsSinceEpoch(map['startDate']),
      lastCompleted: map['lastCompleted'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['lastCompleted'])
          : null,
      reminderId: map['reminderId'],
      hasReminder: map['hasReminder'] == 1,
    );
  }

  Habit copyWith({
    int? id,
    String? title,
    String? description,
    int? targetFrequency,
    int? currentStreak,
    int? completedCount,
    List<bool>? completionDays,
    String? category,
    String? colorCode,
    DateTime? startDate,
    DateTime? lastCompleted,
    int? reminderId,
    bool? hasReminder,
  }) {
    return Habit(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      targetFrequency: targetFrequency ?? this.targetFrequency,
      currentStreak: currentStreak ?? this.currentStreak,
      completedCount: completedCount ?? this.completedCount,
      completionDays: completionDays ?? this.completionDays,
      category: category ?? this.category,
      colorCode: colorCode ?? this.colorCode,
      startDate: startDate ?? this.startDate,
      lastCompleted: lastCompleted ?? this.lastCompleted,
      reminderId: reminderId ?? this.reminderId,
      hasReminder: hasReminder ?? this.hasReminder,
    );
  }
}

class Task {
  int? id;
  String title;
  String description;
  DateTime dueDate;
  bool isCompleted;
  String category;
  String priority;
  List<String> tags;
  String colorCode;
  int reminderId;
  bool hasReminder;
  DateTime? completedAt;
  DateTime createdAt;

  Task({
    this.id,
    required this.title,
    this.description = '',
    required this.dueDate,
    this.isCompleted = false,
    this.category = 'Personal',
    this.priority = 'Medium',
    this.tags = const [],
    this.colorCode = '0xFF4CAF50',
    this.reminderId = -1,
    this.hasReminder = false,
    this.completedAt,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dueDate': dueDate.millisecondsSinceEpoch,
      'isCompleted': isCompleted ? 1 : 0,
      'category': category,
      'priority': priority,
      'tags': tags.join(','),
      'colorCode': colorCode,
      'reminderId': reminderId,
      'hasReminder': hasReminder ? 1 : 0,
      'completedAt': completedAt?.millisecondsSinceEpoch,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      dueDate: DateTime.fromMillisecondsSinceEpoch(map['dueDate']),
      isCompleted: map['isCompleted'] == 1,
      category: map['category'],
      priority: map['priority'],
      tags: map['tags'].toString().isNotEmpty
          ? map['tags'].toString().split(',')
          : [],
      colorCode: map['colorCode'],
      reminderId: map['reminderId'],
      hasReminder: map['hasReminder'] == 1,
      completedAt: map['completedAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['completedAt'])
          : null,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
    );
  }

  Task copyWith({
    int? id,
    String? title,
    String? description,
    DateTime? dueDate,
    bool? isCompleted,
    String? category,
    String? priority,
    List<String>? tags,
    String? colorCode,
    int? reminderId,
    bool? hasReminder,
    DateTime? completedAt,
    DateTime? createdAt,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      isCompleted: isCompleted ?? this.isCompleted,
      category: category ?? this.category,
      priority: priority ?? this.priority,
      tags: tags ?? this.tags,
      colorCode: colorCode ?? this.colorCode,
      reminderId: reminderId ?? this.reminderId,
      hasReminder: hasReminder ?? this.hasReminder,
      completedAt: completedAt ?? this.completedAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class Category {
  final String name;
  final String colorCode;
  final String icon;
  final int taskCount;
  final int habitCount;

  Category({
    required this.name,
    required this.colorCode,
    required this.icon,
    this.taskCount = 0,
    this.habitCount = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'colorCode': colorCode,
      'icon': icon,
      'taskCount': taskCount,
      'habitCount': habitCount,
    };
  }

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      name: map['name'],
      colorCode: map['colorCode'],
      icon: map['icon'],
      taskCount: map['taskCount'],
      habitCount: map['habitCount'],
    );
  }

  Category copyWith({
    String? name,
    String? colorCode,
    String? icon,
    int? taskCount,
    int? habitCount,
  }) {
    return Category(
      name: name ?? this.name,
      colorCode: colorCode ?? this.colorCode,
      icon: icon ?? this.icon,
      taskCount: taskCount ?? this.taskCount,
      habitCount: habitCount ?? this.habitCount,
    );
  }
}

// Predefined categories
class Categories {
  static final List<Category> defaultCategories = [
    Category(
      name: 'Work',
      colorCode: '0xFFFF5722',
      icon: '💼',
    ),
    Category(
      name: 'Study',
      colorCode: '0xFF9C27B0',
      icon: '📚',
    ),
    Category(
      name: 'Health',
      colorCode: '0xFF4CAF50',
      icon: '🏥',
    ),
    Category(
      name: 'Personal',
      colorCode: '0xFF2196F3',
      icon: '👤',
    ),
    Category(
      name: 'Finance',
      colorCode: '0xFFFFC107',
      icon: '💰',
    ),
    Category(
      name: 'Social',
      colorCode: '0xFFE91E63',
      icon: '👥',
    ),
    Category(
      name: 'Home',
      colorCode: '0xFF795548',
      icon: '🏠',
    ),
    Category(
      name: 'Other',
      colorCode: '0xFF9E9E9E',
      icon: '📦',
    ),
  ];
}

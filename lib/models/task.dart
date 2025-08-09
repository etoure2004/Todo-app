class Task {
  String name;
  String description; 
  bool isDone;

  Task({
    required this.name,
    this.description = '', 
    this.isDone = false,
  });

  void toggleDone() => isDone = !isDone;

  // For local storage
  Map<String, dynamic> toMap() => {
        'name': name,
        'description': description,
        'isDone': isDone,
      };

  factory Task.fromMap(Map<String, dynamic> map) => Task(
        name: map['name'] as String,
        description: (map['description'] ?? '') as String,
        isDone: (map['isDone'] ?? false) as bool,
      );
}

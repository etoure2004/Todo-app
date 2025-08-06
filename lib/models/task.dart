class Task {
  final String name;
  final String description;
  bool isDone;

  Task({
    required this.name,
    required this.description,
    this.isDone = false,
  });

  void toggleDone() {
    isDone = !isDone;
  }
}


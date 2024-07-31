class Task {
  int id = 0;
  String title;
  String description;
  bool completed;
  String priority;
  DateTime dueDate;
  DateTime createdAt;
  // DateTime updatedAt;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.completed,
    required this.priority,
    required this.dueDate,
    required this.createdAt,
    // required this.updatedAt,
  });
}

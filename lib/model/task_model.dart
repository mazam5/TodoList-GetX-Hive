class Task {
  int id = 0;
  String title;
  String description;
  bool completed;
  String priority;
  DateTime dueDate;
  DateTime createdAt;
  int reminderTimes;

  Task(
      {required this.id,
      required this.title,
      required this.description,
      required this.completed,
      required this.priority,
      required this.dueDate,
      required this.createdAt,
      required this.reminderTimes});

  Task copyWith({required bool completed}) {
    return Task(
        id: id,
        title: title,
        description: description,
        completed: completed,
        priority: priority,
        dueDate: dueDate,
        createdAt: createdAt,
        reminderTimes: reminderTimes);
  }
}

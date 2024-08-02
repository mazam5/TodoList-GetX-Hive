import 'package:hive/hive.dart';
import 'package:todo_list_app/model/task_model.dart';

class TaskAdapter extends TypeAdapter<Task> {
  @override
  final int typeId = 0;

  @override
  Task read(BinaryReader reader) {
    final id = reader.read();
    final title = reader.read();
    final description = reader.read();
    final completed = reader.read();
    final priority = reader.read();
    final dueDate = reader.read();
    final createdAt = reader.read();
    final reminderTimes = reader.read() ?? [];
    return Task(
      id: id,
      title: title,
      description: description,
      completed: completed,
      priority: priority,
      dueDate: dueDate,
      createdAt: createdAt,
      reminderTimes: reminderTimes,
    );
  }

  @override
  void write(BinaryWriter writer, Task obj) {
    writer
      ..write(obj.id)
      ..write(obj.title)
      ..write(obj.description)
      ..write(obj.completed)
      ..write(obj.priority)
      ..write(obj.dueDate)
      ..write(obj.createdAt)
      ..write(obj.reminderTimes);
  }
}

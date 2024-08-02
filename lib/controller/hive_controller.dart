import 'package:hive/hive.dart';
import 'package:todo_list_app/model/task_model.dart';

class TaskAdapter extends TypeAdapter<Task> {
  @override
  final int typeId = 0;

  @override
  Task read(BinaryReader reader) {
    return Task(
      id: reader.read(),
      title: reader.read(),
      description: reader.read(),
      completed: reader.read(),
      priority: reader.read(),
      dueDate: reader.read(),
      createdAt: reader.read(),
      reminderTimes: reader.read(),
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
      ..write(obj.createdAt);
  }
}

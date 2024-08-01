import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_list_app/model/task_model.dart';

class TaskController extends GetxController {
  final RxList<Task> _taskList = <Task>[
    Task(
      id: 1,
      title: 'Task 1',
      description: 'Description 1',
      completed: true,
      priority: 'High',
      dueDate: DateTime(2024, 8, 3),
      createdAt: DateTime.now(),
    ),
    Task(
      id: 2,
      title: 'Task 2',
      description: 'Description 2',
      completed: false,
      priority: 'Medium',
      dueDate: DateTime(2024, 8, 5),
      createdAt: DateTime.now(),
    ),
    Task(
      id: 3,
      title: 'Task 3',
      description: 'Description 3',
      completed: false,
      priority: 'Low',
      dueDate: DateTime(2024, 8, 7),
      createdAt: DateTime.now(),
    ),
  ].obs;

  List<Task> get taskList => _taskList;

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  bool completed = false;
  DateTime dueDate = DateTime.now();
  String priority = '';
  bool isEditing = false;

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  void addTask() {
    final task = Task(
      id: _taskList.length + 1,
      title: titleController.text,
      description: descriptionController.text,
      completed: completed,
      priority: priority,
      dueDate: dueDate,
      createdAt: DateTime.now(),
    );
    _taskList.add(task);
    Get.back();
    clearFields();
    Get.showSnackbar(
      const GetSnackBar(
        duration: Duration(seconds: 3),
        backgroundColor: Colors.green,
        messageText: Text('Task added successfully!'),
      ),
    );
  }

  void editTask(int id) {
    isEditing = true;
    final index = _taskList.indexWhere((task) => task.id == id);
    if (index != -1) {
      titleController.text = _taskList[index].title;
      descriptionController.text = _taskList[index].description;
      completed = _taskList[index].completed;
      dueDate = _taskList[index].dueDate;
      priority = _taskList[index].priority;
    }
  }

  void updateTask(int id) {
    final index = _taskList.indexWhere((task) => task.id == id);
    if (index != -1) {
      _taskList[index] = Task(
        id: id,
        title: titleController.text,
        description: descriptionController.text,
        completed: completed,
        priority: priority,
        dueDate: dueDate,
        createdAt: DateTime.now(),
      );
    }
    clearFields();
    Get.back();
    isEditing = false;
    Get.showSnackbar(
      const GetSnackBar(
        duration: Duration(seconds: 3),
        backgroundColor: Colors.blue,
        messageText: Text('Task updated successfully!'),
      ),
    );
  }

  void markAsCompleted(int id) {
    final index = _taskList.indexWhere((task) => task.id == id);
    if (index != -1) {
      if (_taskList[index].completed) {
        Get.showSnackbar(
          const GetSnackBar(
            duration: Duration(seconds: 3),
            backgroundColor: Colors.red,
            messageText: Text('Task already marked as completed!'),
          ),
        );
        return;
      }
      _taskList[index] = _taskList[index].copyWith(
        completed: !_taskList[index].completed,
      );
      _taskList.refresh();
    }
    Get.showSnackbar(
      const GetSnackBar(
        duration: Duration(seconds: 3),
        backgroundColor: Colors.orange,
        messageText: Text('Task marked as completed!'),
      ),
    );
  }

  void removeTask(int id) {
    _taskList.removeWhere((task) => task.id == id);
  }

  void undoDelete(int id, Task task) {
    final index = _taskList.indexWhere((t) => t.id == id);
    if (index != -1) {
      _taskList.insert(index, task);
    } else {
      _taskList.add(task);
    }
  }

  void clearFields() {
    titleController.clear();
    descriptionController.clear();
    completed = false;
    dueDate = DateTime.now();
    priority = '';
    isEditing = false;
  }
}

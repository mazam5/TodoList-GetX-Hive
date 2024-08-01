import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_list_app/model/task_model.dart';

class TaskController extends GetxController {
  final Box<Task> _myBox = Hive.box<Task>('tasks');

  @override
  void onInit() {
    _initializeTasks();
    super.onInit();
  }

  final RxList<Task> _taskList = <Task>[].obs;

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

  void _initializeTasks() {
    if (_myBox.isEmpty) {
      _myBox.put(
        1,
        Task(
          id: 1,
          title: 'Task 1',
          description: 'Description 1',
          completed: true,
          priority: 'High',
          dueDate: DateTime.now(),
          createdAt: DateTime.now(),
        ),
      );
      _myBox.put(
        2,
        Task(
          id: 2,
          title: 'Task 2',
          description: 'Description 2',
          completed: false,
          priority: 'Medium',
          dueDate: DateTime.now(),
          createdAt: DateTime.now(),
        ),
      );
      _myBox.put(
        3,
        Task(
          id: 3,
          title: 'Task 3',
          description: 'Description 3',
          completed: false,
          priority: 'Low',
          dueDate: DateTime.now(),
          createdAt: DateTime.now(),
        ),
      );
    }
    _taskList.assignAll(_myBox.values.toList());
  }

  void addTask() {
    final task = Task(
      id: _myBox.length + 1,
      title: titleController.text,
      description: descriptionController.text,
      completed: completed,
      priority: priority,
      dueDate: dueDate,
      createdAt: DateTime.now(),
    );
    clearFields();
    Get.back();
    Get.showSnackbar(
      const GetSnackBar(
        duration: Duration(seconds: 3),
        backgroundColor: Colors.green,
        messageText: Text('Task added successfully!'),
      ),
    );
    _myBox.put(task.id, task);
    _taskList.add(task);
  }

  void editTask(int id) {
    isEditing = true;
    final task = _myBox.get(id);
    if (task != null && !task.completed) {
      titleController.text = task.title;
      descriptionController.text = task.description;
      completed = task.completed;
      dueDate = task.dueDate;
      priority = task.priority;
    } else {
      isEditing = false;
      Get.showSnackbar(
        const GetSnackBar(
          duration: Duration(seconds: 3),
          backgroundColor: Colors.red,
          messageText: Text('Completed tasks cannot be edit!'),
        ),
      );
    }
  }

  void updateTask(int id) {
    final task = _myBox.get(id);
    if (task != null) {
      final updatedTask = Task(
        id: id,
        title: titleController.text,
        description: descriptionController.text,
        completed: completed,
        priority: priority,
        dueDate: dueDate,
        createdAt: task.createdAt,
      );
      _myBox.put(id, updatedTask);
      _taskList[_taskList.indexWhere((task) => task.id == id)] = updatedTask;
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
    final task = _myBox.get(id);
    if (task != null && !task.completed) {
      final updatedTask = task.copyWith(completed: true);
      _myBox.put(id, updatedTask);
      _taskList[_taskList.indexWhere((task) => task.id == id)] = updatedTask;
      _taskList.refresh();
      Get.showSnackbar(
        const GetSnackBar(
          duration: Duration(seconds: 3),
          backgroundColor: Colors.orange,
          messageText: Text('Task marked as completed!'),
        ),
      );
    } else {
      Get.showSnackbar(
        const GetSnackBar(
          duration: Duration(seconds: 3),
          backgroundColor: Colors.red,
          messageText: Text('Task already marked as completed!'),
        ),
      );
    }
  }

  void removeTask(int id) {
    final taskIndex = _taskList.indexWhere((task) => task.id == id);
    if (taskIndex != -1) {
      _myBox.delete(id);
      // _taskList.removeAt(taskIndex);
      _taskList.removeWhere((task) => task.id == id);
      Get.back();
      Get.showSnackbar(
        const GetSnackBar(
          backgroundColor: Colors.red,
          messageText: Text('Task has been deleted!'),
          duration: Duration(seconds: 4),
        ),
      );
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

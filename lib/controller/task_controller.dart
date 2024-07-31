import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_list_app/model/task_model.dart';

class TaskController extends GetxController {
  final List<Task> _taskList = <Task>[
    Task(
      id: 1,
      title: 'Task 1',
      description: 'Description 1',
      completed: false,
      priority: 'high',
      dueDate: DateTime.now(),
      createdAt: DateTime.now(),
    ),
    Task(
      id: 2,
      title: 'Task 2',
      description: 'Description 2',
      completed: false,
      priority: 'medium',
      dueDate: DateTime.now(),
      createdAt: DateTime.now(),
    ),
    Task(
      id: 3,
      title: 'Task 3',
      description: 'Description 3',
      completed: false,
      priority: 'low',
      dueDate: DateTime.now(),
      createdAt: DateTime.now(),
    ),
  ].obs;

  List<Task> get taskList => _taskList;

  TextEditingController? titleController;
  TextEditingController? descriptionController;
  bool? completed;
  DateTime? dueDate;
  String? priority;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    titleController = TextEditingController();
    descriptionController = TextEditingController();
    completed = false;
    dueDate = DateTime.now();
    priority = null;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    titleController!.dispose();
    descriptionController!.dispose();
  }

  void addTask() {
    final task = Task(
      id: _taskList.length + 1,
      title: titleController!.text,
      description: descriptionController!.text,
      completed: completed!,
      priority: priority!,
      dueDate: dueDate!,
      createdAt: DateTime.now(),
    );
    _taskList.add(task);
    titleController!.clear();
    descriptionController!.clear();
    completed = false;
    dueDate = DateTime.now();
    priority = null;
  }

  void editTask(int id) {
    final index = _taskList.indexWhere((task) => task.id == id);
    if (index != -1) {
      titleController!.text = _taskList[index].title;
      descriptionController!.text = _taskList[index].description;
      completed = _taskList[index].completed;
      dueDate = _taskList[index].dueDate;
      priority = _taskList[index].priority;
    }
  }

  void removeTask(int id) {
    _taskList.removeWhere((task) => task.id == id);
  }

  void markAsCompleted(int id) {
    final index = _taskList.indexWhere((task) => task.id == id);
    if (index != -1) {
      _taskList[index].completed = !_taskList[index].completed;
      print(
          'Task ${_taskList[index].title} is completed: ${_taskList[index].completed}');
    }
  }

  void updateTask(int id, Task task) {
    final index = _taskList.indexWhere((task) => task.id == id);
    if (index != -1) {
      _taskList[index] = task;
    }
  }
}

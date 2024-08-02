import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_list_app/controller/notifications_controller.dart';
import 'package:todo_list_app/model/task_model.dart';

class TaskController extends GetxController {
  final Box<Task> _myBox = Hive.box<Task>('tasks');

  final RxList<Task> _taskList = <Task>[].obs;
  final RxList<Task> _filteredTaskList = <Task>[].obs;

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController searchController = TextEditingController();

  final RxString selectedPriority = ''.obs;

  RxString priority = 'Low'.obs;
  Rx<DateTime> dueDate = DateTime.now().obs;
  Rx<DateTime> filterDueDate = DateTime.now().obs;
  Rx<DateTime> filterCreateDate = DateTime.now().obs;

  RxInt reminderTimes = 0.obs;

  bool completed = false;
  bool isEditing = false;

  List<Task> get taskList => _filteredTaskList;

  @override
  void onInit() {
    _initializeTasks();
    super.onInit();
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    searchController.dispose();
    super.dispose();
  }

  void _initializeTasks() {
    _taskList.assignAll(_myBox.values.toList());
    _filteredTaskList.assignAll(_taskList);
  }

  void addTask() async {
    final taskId = _myBox.isEmpty
        ? 1
        : _myBox.keys
                .cast<int>()
                .map((e) => e)
                .reduce((a, b) => a > b ? a : b) +
            1;
    final task = Task(
      id: taskId,
      title: titleController.text,
      description: descriptionController.text,
      completed: completed,
      priority: priority.value,
      dueDate: dueDate.value,
      createdAt: DateTime.now(),
      reminderTimes: reminderTimes.value,
    );

    await _myBox.put(task.id, task);
    _taskList.add(task);
    _filteredTaskList.add(task);
    Get.back();
    Get.showSnackbar(
      const GetSnackBar(
        duration: Duration(seconds: 3),
        backgroundColor: Colors.green,
        messageText: Text('Task added successfully!',
            style: TextStyle(color: Colors.white)),
      ),
    );
    await NotificationController.createNewNotification(
      task.title,
      task.description,
      task.dueDate,
    );
    clearTextFields();
  }

  void editTask(int id) {
    isEditing = true;
    final task = _myBox.get(id);
    if (task != null && !task.completed) {
      titleController.text = task.title;
      descriptionController.text = task.description;
      completed = task.completed;
      dueDate.value = task.dueDate;
      priority.value = task.priority;
    } else {
      isEditing = false;
      Get.showSnackbar(
        const GetSnackBar(
          duration: Duration(seconds: 3),
          backgroundColor: Colors.red,
          messageText: Text('Completed tasks cannot be edited!'),
        ),
      );
    }
  }

  void updateTask(int id, int reminderTimes) async {
    final task = _myBox.get(id);
    if (task != null) {
      final updatedTask = Task(
        id: id,
        title: titleController.text,
        description: descriptionController.text,
        completed: completed,
        priority: priority.value,
        dueDate: dueDate.value,
        createdAt: task.createdAt,
        reminderTimes: reminderTimes,
      );
      await _myBox.put(id, updatedTask);
      final index = _taskList.indexWhere((task) => task.id == id);
      if (index != -1) {
        _taskList[index] = updatedTask;
        _filteredTaskList[index] = updatedTask;
      }
    }
    clearTextFields();
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
      final index = _taskList.indexWhere((task) => task.id == id);
      if (index != -1) {
        _taskList[index] = updatedTask;
      }
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
      _taskList.removeAt(taskIndex);
      _filteredTaskList.removeAt(taskIndex);
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

  void filterTasks(String priority, DateTime dueDate, DateTime createDate) {
    var filtered = _taskList.where((task) {
      var matchesPriority = priority.isEmpty || task.priority == priority;

      var matchesDueDate = (dueDate == DateTime.now()) ||
          task.dueDate.isAtSameMomentAs(dueDate) ||
          task.dueDate.isBefore(dueDate);

      var matchesCreateDate = (createDate == DateTime.now()) ||
          task.createdAt.isAtSameMomentAs(createDate) ||
          task.createdAt.isAfter(createDate);

      return matchesPriority || matchesDueDate || matchesCreateDate;
    }).toList();

    _filteredTaskList.assignAll(filtered);
    Get.back();
  }

  void searchTasks(
    String searchText,
  ) {
    var filtered = _taskList.where((task) {
      var matchesSearchText = searchText.isEmpty ||
          task.title.toLowerCase().contains(searchText.toLowerCase()) ||
          task.description.toLowerCase().contains(searchText.toLowerCase());
      return matchesSearchText;
    }).toList();
    _filteredTaskList.assignAll(filtered);
    Get.back();
  }

  void clearTextFields() {
    titleController.clear();
    descriptionController.clear();
    completed = false;
    dueDate.value = DateTime.now();
    priority.value = 'Low';
    // isEditing = false;
  }

  void clearFilters() {
    searchController.clear();
    selectedPriority.value = '';
    filterDueDate.value = DateTime.now();
    filterCreateDate.value = DateTime.now();
    _filteredTaskList.assignAll(_taskList);
  }
}

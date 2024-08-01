import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:todo_list_app/controller/task_controller.dart';

import 'package:todo_list_app/model/task_model.dart';

class DeleteDialog extends StatelessWidget {
  const DeleteDialog({
    super.key,
    required this.controller,
    required this.todo,
  });

  final TaskController controller;
  final Task todo;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Delete Todo?'),
      content: const Text('Are you sure you want to delete this todo?'),
      actions: [
        TextButton(
          onPressed: () {
            Get.back();
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            controller.removeTask(todo.id);
          },
          child: const Text('Delete'),
        ),
      ],
    );
  }
}

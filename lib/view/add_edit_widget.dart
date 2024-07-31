import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_list_app/controller/task_controller.dart';
import 'package:todo_list_app/model/task_model.dart';

class AddEditDialog extends StatelessWidget {
  AddEditDialog({super.key, required bool isEditing, required Task task});

  final TaskController controller = Get.put(TaskController());

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Form(
        key: GlobalKey<FormState>(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Todo',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextField(
              controller: controller.titleController,
              onChanged: (value) => {
                controller.titleController!.text = value,
                print(controller.titleController!.text),
              },
              key: const ValueKey('title'),
              // autofocus: true,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: controller.descriptionController,
              onChanged: (value) => {
                controller.descriptionController!.text = value,
                print(controller.descriptionController!.text),
              },
              key: const ValueKey('description'),
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DropdownButton(
                  // value: controller.priority,
                  hint: Text(
                    controller.priority == null
                        ? 'Priority'
                        : controller.priority!,
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'Low',
                      child: Text('Low'),
                    ),
                    DropdownMenuItem(
                      value: 'Medium',
                      child: Text('Medium'),
                    ),
                    DropdownMenuItem(
                      value: 'High',
                      child: Text('High'),
                    ),
                  ],
                  onChanged: (value) {
                    controller.priority = value;
                    print(controller.priority);
                  },
                ),
                TextButton(
                  onPressed: () {
                    showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2025),
                    ).then((value) {
                      if (value != null) {
                        controller.dueDate = value;
                        print(controller.dueDate);
                      }
                    });
                  },
                  child: Text(
                    controller.dueDate == null
                        ? 'Due Date'
                        : controller.dueDate.toString().substring(0, 10),
                  ),
                ),
              ],
            ),
            FilledButton(
              onPressed: () {
                controller.addTask();
                Get.back();
                Get.showSnackbar(
                  const GetSnackBar(
                    duration: Duration(seconds: 2),
                    backgroundColor: Colors.green,
                    messageText: Text('Task added successfully!'),
                  ),
                );
              },
              child: const Text('Create Todo'),
            ),
          ],
        ),
      ),
    );
  }
}

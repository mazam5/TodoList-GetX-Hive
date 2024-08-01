import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_list_app/controller/task_controller.dart';

class AddEditDialog extends StatelessWidget {
  AddEditDialog({super.key, required this.id});

  final TaskController controller = Get.put(TaskController());

  final int id;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Form(
        key: GlobalKey<FormState>(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const Text(
                  'Todo',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            TextFormField(
              key: const ValueKey('title'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
              controller: controller.titleController,
              textCapitalization: TextCapitalization.sentences,
              onChanged: (value) => {
                controller.titleController.text = value,
                // print(controller.titleController!.text),
              },
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            const SizedBox(height: 10),
            TextFormField(
              key: const ValueKey('description'),
              controller: controller.descriptionController,
              textCapitalization: TextCapitalization.sentences,
              minLines: 1,
              maxLines: 3,
              onChanged: (value) =>
                  {controller.descriptionController.text = value},
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DropdownButton(
                  hint: Text(
                    controller.priority == ''.obs
                        ? 'Priority'
                        : controller.priority.toString(),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'High',
                      child: Text('High'),
                    ),
                    DropdownMenuItem(
                      value: 'Medium',
                      child: Text('Medium'),
                    ),
                    DropdownMenuItem(
                      value: 'Low',
                      child: Text('Low'),
                    ),
                  ],
                  onChanged: (value) =>
                      controller.priority = value.toString().obs,
                ),
                TextButton(
                  onPressed: () {
                    showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2025),
                      currentDate: DateTime.now(),
                    ).then((value) {
                      if (value != null) {
                        controller.dueDate = value.toString().obs;
                      }
                    });
                  },
                  child: Text(
                    controller.dueDate == DateTime.now().toIso8601String().obs
                        ? 'Due Date'
                        : controller.dueDate.toString().substring(0, 10),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                OutlinedButton(
                    onPressed: () {
                      controller.clearFields();
                    },
                    child: const Text('Clear')),
                const Spacer(),
                FilledButton(
                  onPressed: () {
                    controller.isEditing
                        ? controller.updateTask(id)
                        : controller.addTask();
                  },
                  child: const Text('Save Todo'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

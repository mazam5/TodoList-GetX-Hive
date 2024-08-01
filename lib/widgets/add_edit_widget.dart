import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

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
              onEditingComplete: () {
                if (controller.titleController.text.isNotEmpty) {
                  FocusScope.of(context).nextFocus();
                }
              },
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
              minLines: 1,
              maxLines: 3,
              onChanged: (value) =>
                  {controller.descriptionController.text = value},
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Obx(
                  () => DropdownButton<String>(
                    value: controller.priority.value.isNotEmpty
                        ? controller.priority.value
                        : null,
                    hint: Text(
                      controller.priority.value.isEmpty
                          ? 'Priority'
                          : controller.priority.value,
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
                      if (value != null) {
                        controller.priority.value = value;
                      }
                    },
                  ),
                ),
                Obx(
                  () => TextButton(
                    onPressed: () {
                      showDatePicker(
                        context: context,
                        initialDate: controller.dueDate.value,
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2025),
                      ).then((value) {
                        if (value != null) {
                          controller.dueDate.value = value;
                        }
                      });
                    },
                    child: Text(
                      controller.dueDate.value == DateTime.now()
                          ? 'Due Date'
                          : DateFormat('dd-MMM-yyyy').format(
                              controller.dueDate.value,
                            ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                OutlinedButton(
                    onPressed: () {
                      controller.clearTextFields();
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

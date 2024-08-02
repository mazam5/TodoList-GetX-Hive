import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_list_app/controller/notifications_controller.dart';
import 'package:todo_list_app/controller/task_controller.dart';
import 'package:todo_list_app/model/task_model.dart';

class AddNotification extends StatelessWidget {
  AddNotification({super.key, required this.todo});
  TaskController controller = Get.put(TaskController());
  final Task todo;

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
                  'Reminder',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Obx(
                  () => Wrap(children: [
                    ChoiceChip(
                      label: const Text('1'),
                      selected: controller.reminderTimes.value == 1,
                      onSelected: (value) {
                        controller.reminderTimes.value = 1;
                      },
                    ),
                    ChoiceChip(
                      label: const Text('2'),
                      selected: controller.reminderTimes.value == 2,
                      onSelected: (value) {
                        controller.reminderTimes.value = 2;
                      },
                    ),
                    ChoiceChip(
                      label: const Text('3'),
                      selected: controller.reminderTimes.value == 3,
                      onSelected: (value) {
                        controller.reminderTimes.value = 3;
                      },
                    ),
                  ]),
                ),
                const Text('per day')
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    controller.editTask(todo.id);
                    controller.updateTask(
                      todo.id,
                      controller.reminderTimes.value,
                    );
                    // Schedule the notifications
                    NotificationController.scheduleNewNotifications(todo);
                    Get.back();
                  },
                  child: const Text('Save'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

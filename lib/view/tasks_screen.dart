import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_list_app/controller/task_controller.dart';
import 'package:todo_list_app/widgets/add_reminder.dart';
import 'package:todo_list_app/widgets/delete_dialog.dart';

import '../widgets/add_edit_widget.dart';

class MainScreen extends StatelessWidget {
  MainScreen({super.key});

  final TaskController controller = Get.put(TaskController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.grey[300],
        title: const Text('To Do List App'),
      ),
      body: Obx(
        () => (controller.taskList.isEmpty)
            ? const Center(
                child: Text('No tasks found'),
              )
            : ListView.builder(
                itemCount: controller.taskList.length,
                itemBuilder: (context, index) {
                  final todo = controller.taskList[index];
                  return Container(
                    margin: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: GestureDetector(
                      onDoubleTap: () {
                        // edit task
                        controller.editTask(todo.id);
                        if (!todo.completed) {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AddEditDialog(
                                id: todo.id,
                              );
                            },
                          );
                        }
                      },
                      onLongPress: () {
                        // delete task
                        showDialog(
                          context: context,
                          builder: (context) {
                            return DeleteDialog(
                              controller: controller,
                              todo: todo,
                            );
                          },
                        );
                      },
                      child: Dismissible(
                        key: ValueKey(todo.id),
                        dismissThresholds: const {
                          DismissDirection.endToStart: 0.6,
                          DismissDirection.startToEnd: 0.6,
                        },
                        confirmDismiss: (direction) async {
                          if (direction == DismissDirection.endToStart) {
                            // delete task
                            return await showDialog(
                              context: context,
                              builder: (context) {
                                return DeleteDialog(
                                  controller: controller,
                                  todo: todo,
                                );
                              },
                            );
                          } else if (direction == DismissDirection.startToEnd) {
                            // edit task
                            controller.editTask(todo.id);
                            if (!todo.completed) {
                              return await showDialog(
                                context: context,
                                builder: (context) {
                                  controller.isEditing = false;
                                  return AddEditDialog(
                                    id: todo.id,
                                  );
                                },
                              );
                            }
                          }
                          return false;
                        },
                        background: Container(
                          color: Colors.blue,
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.only(left: 20),
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          child: const Icon(
                            Icons.edit,
                            color: Colors.white,
                          ),
                        ),
                        secondaryBackground: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          child: const Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                        ),
                        child: ListTile(
                          leading: Checkbox(
                            key: ValueKey(todo.id),
                            value: todo.completed,
                            onChanged: (value) {
                              if (value != null) {
                                controller.markAsCompleted(todo.id);
                              }
                            },
                          ),
                          title: Text(
                            todo.title,
                            style: TextStyle(
                              color: todo.completed == true
                                  ? Colors.grey
                                  : Colors.black,
                              fontWeight: FontWeight.bold,
                              decoration: todo.completed == true
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                            ),
                          ),
                          subtitle: Text(
                            todo.description,
                            textHeightBehavior: const TextHeightBehavior(
                              applyHeightToFirstAscent: true,
                              applyHeightToLastDescent: false,
                              leadingDistribution: TextLeadingDistribution.even,
                            ),
                            style: TextStyle(
                              color: todo.completed == true
                                  ? Colors.grey
                                  : Colors.black,
                              decoration: todo.completed == true
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                            ),
                          ),
                          trailing: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return const AddNotification();
                                    },
                                  );
                                },
                                icon: const Icon(Icons.add_alert_rounded),
                              ),
                              SizedBox(
                                width: 100,
                                child: Column(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: todo.priority == 'High'
                                            ? Colors.red
                                            : todo.priority == 'Medium'
                                                ? Colors.orange
                                                : Colors.green,
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                      child: Text(
                                        todo.priority,
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                    ),
                                    Text(todo.dueDate
                                        .toString()
                                        .substring(0, 10)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text('Add Task'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        highlightElevation: 10,
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              controller.titleController.clear();
              controller.descriptionController.clear();
              controller.priority = ''.obs;
              controller.dueDate = DateTime.now().toIso8601String().obs;
              return AddEditDialog(
                id: 0,
              );
            },
          );
        },
      ),
    );
  }
}

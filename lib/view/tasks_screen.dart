import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_list_app/controller/task_controller.dart';
import 'package:todo_list_app/model/task_model.dart';

import 'add_edit_widget.dart';

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
      // body: FutureBuilder(
      //   future: strapiService.fetchTasks(),
      //   builder: (BuildContext context, AsyncSnapshot snapshot) {
      //     if (snapshot.connectionState == ConnectionState.waiting) {
      //       return const Center(
      //         child: CircularProgressIndicator(),
      //       );
      //     } else if (snapshot.hasError) {
      //       return const Center(
      //         child: Text('Error fetching tasks'),
      //       );
      //     } else if (snapshot.data.isEmpty) {
      //       return const Center(
      //         child: Text('No tasks found'),
      //       );
      //     } else {
      // return
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
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AddEditDialog(
                              id: todo.id,
                            );
                          },
                        );
                      },
                      onLongPress: () {
                        // delete task
                        showDialog(
                          context: context,
                          builder: (context) {
                            return DeleteDialog(
                                controller: controller, todo: todo);
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
                          contentPadding: const EdgeInsets.all(10),
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
                          trailing: Column(
                            children: [
                              Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: todo.priority == 'High'
                                        ? Colors.red
                                        : todo.priority == 'Medium'
                                            ? Colors.orange
                                            : Colors.green,
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  child: Text(todo.priority)),
                              Text(todo.dueDate.toString().substring(0, 10)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),

      //     }
      //   },
      // ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              controller.titleController.clear();
              controller.descriptionController.clear();
              controller.priority = '';
              controller.dueDate = DateTime.now();
              return AddEditDialog(
                id: 0,
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

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
            Get.back();
            Get.showSnackbar(
              GetSnackBar(
                backgroundColor: Colors.red,
                messageText: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Task has been deleted!'),
                    TextButton.icon(
                      onPressed: () {
                        Get.back();
                      },
                      icon: const Icon(Icons.undo),
                      label: const Text('Undo'),
                    ),
                  ],
                ),
                duration: const Duration(seconds: 6),
              ),
            );
          },
          child: const Text('Delete'),
        ),
      ],
    );
  }
}

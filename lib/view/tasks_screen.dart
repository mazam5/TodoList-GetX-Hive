import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

import 'package:todo_list_app/controller/task_controller.dart';
import 'package:todo_list_app/widgets/add_edit_widget.dart';
import 'package:todo_list_app/widgets/delete_dialog.dart';

class MainScreen extends StatelessWidget {
  MainScreen({super.key});

  final TaskController controller = Get.put(TaskController());
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  _displayEndDrawer(BuildContext context) {
    _scaffoldKey.currentState!.openEndDrawer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.grey[300],
        title: const Text('To Do List App'),
        actions: [
          IconButton(
            icon: const Icon(Iconsax.filter_search),
            onPressed: () {
              _displayEndDrawer(context);
            },
          ),
        ],
      ),
      endDrawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Center(
                child: Text(
                  'Search & Filters',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            ListTile(
              leading: SizedBox(
                width: 200,
                child: TextFormField(
                  controller: controller.searchController,
                  decoration: InputDecoration(
                    labelText: 'Search',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        controller.searchController.clear();
                      },
                      icon: const Icon(Icons.clear),
                    ),
                  ),
                  onChanged: (value) {
                    controller.searchController.text = value;
                  },
                ),
              ),
              title: IconButton(
                onPressed: () {
                  controller.searchTasks(
                    controller.searchController.text,
                  );
                },
                icon: const Icon(Iconsax.global_search),
              ),
            ),
            const Divider(),
            Obx(
              () => ListTile(
                minTileHeight: 80,
                leading: DropdownButton<String>(
                  value: controller.selectedPriority.value.isEmpty
                      ? null
                      : controller.selectedPriority.value,
                  hint: const Text('Priority'),
                  items: ['All', 'Low', 'Medium', 'High']
                      .map(
                        (priority) => DropdownMenuItem<String>(
                          value: priority == 'All' ? '' : priority,
                          child: Text(priority),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    controller.selectedPriority.value = value!;
                  },
                ),
                subtitle: SizedBox(
                  width: 250,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('Due Date'),
                          TextButton(
                            onPressed: () {
                              showDatePicker(
                                context: context,
                                initialDate: controller.filterDueDate.value,
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2100),
                              ).then((value) {
                                if (value != null) {
                                  controller.filterDueDate.value = value;
                                }
                              });
                            },
                            child: Text(
                              controller.filterDueDate.value == DateTime.now()
                                  ? 'Due Date'
                                  : DateFormat('dd-MMM').format(
                                      controller.filterDueDate.value,
                                    ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 10),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('Create Date'),
                          TextButton(
                            onPressed: () {
                              showDatePicker(
                                context: context,
                                initialDate: controller.filterCreateDate.value,
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2100),
                              ).then((value) {
                                if (value != null) {
                                  controller.filterCreateDate.value = value;
                                }
                              });
                            },
                            child: Text(
                              controller.filterCreateDate.value ==
                                      DateTime.now()
                                  ? 'Created Date'
                                  : DateFormat('dd-MMM').format(
                                      controller.filterCreateDate.value,
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const Divider(),
            ListTile(
              horizontalTitleGap: 0,
              leading: SizedBox(
                width: 150,
                child: FilledButton.icon(
                  onPressed: () {
                    controller.filterTasks(
                      controller.selectedPriority.value,
                      controller.filterDueDate.value,
                      controller.filterCreateDate.value,
                    );
                  },
                  icon: const Icon(Iconsax.filter_search4),
                  label: const Text('Apply Filter'),
                ),
              ),
              trailing: SizedBox(
                width: 100,
                child: OutlinedButton(
                  onPressed: () {
                    controller.clearFilters();
                    Get.back();
                  },
                  child: const Text('Clear'),
                ),
              ),
            ),
          ],
        ),
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
                            style: TextStyle(
                              color: todo.completed == true
                                  ? Colors.grey
                                  : Colors.black,
                              fontWeight: FontWeight.w400,
                              decoration: todo.completed == true
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                            ),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.add_alert),
                              ),
                              SizedBox(
                                width: 100,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      DateFormat('dd-MMM-yyyy')
                                          .format(todo.dueDate),
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: todo.completed == true
                                            ? Colors.grey
                                            : Colors.black,
                                        fontWeight: FontWeight.w400,
                                        decoration: todo.completed == true
                                            ? TextDecoration.lineThrough
                                            : TextDecoration.none,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: todo.priority == 'Low'
                                            ? Colors.green
                                            : todo.priority == 'Medium'
                                                ? Colors.orange
                                                : Colors.red,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Text(
                                        todo.priority,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w400,
                                          decoration: todo.completed == true
                                              ? TextDecoration.lineThrough
                                              : TextDecoration.none,
                                        ),
                                      ),
                                    ),
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

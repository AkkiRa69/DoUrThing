import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homework6_json_server/models/task_model.dart';
import 'package:homework6_json_server/services/task_service.dart';
import 'package:intl/intl.dart';

class TaskController extends GetxController {
  final taskService = TaskService();
  var tasks = <TaskModel>[].obs; // Observable list
  var isCompleted = false.obs;
  var taskTitle = ''.obs;
  var taskDescription = ''.obs;
  Rx<DateTime?> startDate = DateTime.now().obs;
  Rx<DateTime?> dueDate = DateTime.now().obs;

  @override
  void onInit() {
    getTasks();
    super.onInit();
  }

  void getTasks() async {
    try {
      final value = await taskService.fetchTasks();
      tasks.assignAll(value); // Use assignAll to update observable list
      print(
          "Fetched tasks: ${tasks.length}"); // Debugging to ensure tasks are fetched
    } catch (e) {
      print("Error fetching tasks: $e");
    }
  }

  void addTask(
      {required String title,
      String description = "No description",
      bool isCompleted = false,
      String priority = 'Low',
      required DateTime dueData}) async {
    // Generate a new ID once and log it
    String newId = autoId();

    // Create a new task with the generated ID
    TaskModel newTask = TaskModel(
      id: newId,
      title: title,
      description: description,
      isCompleted: isCompleted,
      priority: priority,
      createdAt: DateTime.now().toString(),
      dueDate: dueData.toString(),
    );

    // Add the new task to the server/database
    try {
      await taskService.insertTask(newTask.toJson());
      tasks.add(newTask);
      print("Added task: ${newTask.title} with ID: $newId");
    } catch (e) {
      print("Error adding task: $e");
    }
  }

  void updateTask(
      {required int id,
      required String title,
      String description = "No description",
      bool isCompleted = false,
      String priority = 'Low',
      required DateTime dueData}) async {
    TaskModel task = TaskModel(
      id: id.toString(),
      title: title,
      description: description,
      isCompleted: isCompleted,
      priority: priority,
      createdAt: DateTime.now().toString(),
      dueDate: dueData.toString(),
    );
    taskService.updateTask(id, task.toJson());
    getTasks();
  }

  void deleteTask(int id) async {
    await taskService.deletedTask(id);
    getTasks();
  }

  String autoId() {
    if (tasks.isEmpty) {
      return '1'; // Start from ID '1' if no tasks exist
    }

    // Find the max ID from the existing tasks
    int max = int.parse(tasks[0].id.toString());
    for (int i = 0; i < tasks.length; i++) {
      int currentId = int.parse(tasks[i].id.toString());
      if (max < currentId) {
        max = currentId;
      }
    }
    final newId = (max + 1).toString();
    print("Generated ID: $newId");
    return newId;
  }

  void toggleCheckBox(int id, bool isCheck) async {
    // Fetch the existing task first to ensure we have the full data
    final task = tasks.firstWhere((task) => task.id == id.toString());

    // Update the task's isCompleted property
    task.isCompleted = isCheck;

    try {
      await taskService.updateStatus(id, isCheck, task.toJson());
      print("Updated task ID: $id to completed: $isCheck");
    } catch (e) {
      print("Error updating task: $e");
    }

    // Notify the observable list that the task has changed
    tasks.refresh();
  }

  final titleTextEditController = TextEditingController();
  final desTextEditController = TextEditingController();
  final startDateTextEditController = TextEditingController();
  final dueDateTextEditController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void showBottomSheet(BuildContext context, bool isUpdate, {int id = 0}) {
    if (isUpdate == true) {
      final task = tasks.firstWhere(
        (element) => int.parse(element.id.toString()) == id,
      );
      titleTextEditController.text = task.title.toString();
      desTextEditController.text = task.description.toString();
      startDateTextEditController.text =
          DateFormat("dd MMM, yyyy").format(startDate.value!);
      dueDateTextEditController.text =
          DateFormat("dd MMM, yyyy").format(dueDate.value!);
    }

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.only(top: 25, left: 20, right: 20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "ti".tr,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                  controller: titleTextEditController,
                  decoration: InputDecoration(
                    hintText: "en_ti".tr,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Get.isDarkMode ? Colors.white : Colors.black),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    border: InputBorder.none,
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Text(
                  "des".tr,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                  maxLines: null, // Allows unlimited lines
                  minLines: 5, // Minimum 3 lines
                  controller: desTextEditController,
                  decoration: InputDecoration(
                    hintText: "en_des".tr,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Get.isDarkMode ? Colors.white : Colors.black),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    border: InputBorder.none,
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "startdate".tr,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter some text';
                              }
                              return null;
                            },
                            controller: startDateTextEditController,
                            readOnly: true,
                            onTap: () async {
                              startDate.value = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime.now(),
                                lastDate: DateTime(2030, 8, 10),
                              );
                              startDateTextEditController.text =
                                  DateFormat("dd MMM, yyyy")
                                      .format(startDate.value!);
                            },
                            decoration: InputDecoration(
                              hintText: "en_start".tr,
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Get.isDarkMode
                                        ? Colors.white
                                        : Colors.black),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "duedate".tr,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter some text';
                              }
                              return null;
                            },
                            readOnly: true,
                            controller: dueDateTextEditController,
                            onTap: () async {
                              dueDate.value = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime.now(),
                                lastDate: DateTime(2030, 8, 10),
                              );
                              dueDateTextEditController.text =
                                  DateFormat("dd MMM, yyyy")
                                      .format(dueDate.value!);
                            },
                            decoration: InputDecoration(
                              hintText: "en_due".tr,
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Get.isDarkMode
                                        ? Colors.white
                                        : Colors.black),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.all(15),
                          backgroundColor:
                              Get.isDarkMode ? Colors.white : Colors.black,
                        ),
                        onPressed: () {
                          isUpdate
                              ? updateTask(
                                  id: id,
                                  title: titleTextEditController.text,
                                  dueData: dueDate.value!,
                                  description: desTextEditController.text,
                                )
                              : addTask(
                                  title: titleTextEditController.text,
                                  dueData: dueDate.value!,
                                  description: desTextEditController.text,
                                );
                          titleTextEditController.clear();
                          desTextEditController.clear();
                          startDateTextEditController.clear();
                          dueDateTextEditController.clear();
                          Get.back();
                        },
                        child: Text(
                          isUpdate ? "update".tr : "add".tr,
                          style: TextStyle(
                            fontSize: 16,
                            color: Get.isDarkMode ? Colors.black : Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void showTaskDetail(TaskModel task, BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Title",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "${task.title}",
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                const Text(
                  "Description",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "${task.description}",
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "Start Date: ${DateFormat("dd MMM, yyyy").format(DateTime.parse(task.createdAt.toString()))}",
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
                Text(
                  "Due Date: ${DateFormat("dd MMM, yyyy").format(DateTime.parse(task.dueDate.toString()))}",
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

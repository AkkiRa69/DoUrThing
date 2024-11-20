import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:homework6_json_server/controllers/task_controller.dart';

class HomePage extends GetView<TaskController> {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('title'.tr),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: () {
              Get.isDarkMode
                  ? Get.changeThemeMode(ThemeMode.light)
                  : Get.changeThemeMode(ThemeMode.dark);
            },
          ),
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: () {
              var locale = Get.locale == const Locale('km', 'KH')
                  ? const Locale('en', 'US')
                  : const Locale('km', 'KH');
              Get.updateLocale(locale);
            },
          ),
        ],
      ),
      body: Obx(
        () => controller.tasks.isEmpty
            ? const Center(child: Text("No Tasks"))
            : ListView.builder(
                shrinkWrap: true,
                itemCount: controller.tasks.length,
                itemBuilder: (context, index) {
                  final task = controller.tasks[index];
                  return Slidable(
                    key: const ValueKey(0),
                    startActionPane: ActionPane(
                      motion: const DrawerMotion(),
                      children: [
                        SlidableAction(
                          onPressed: (context) {
                            // Open bottom sheet for editing
                            controller.showBottomSheet(context, true,
                                id: int.parse(task.id.toString()));
                          },
                          backgroundColor: const Color(0xFF21B7CA),
                          foregroundColor: Colors.white,
                          icon: Icons.edit,
                          label: 'Edit',
                        ),
                      ],
                    ),
                    endActionPane: ActionPane(
                      motion: const DrawerMotion(),
                      dismissible: DismissiblePane(
                        onDismissed: () {
                          controller.deleteTask(int.parse(task.id.toString()));
                        },
                      ),
                      children: [
                        SlidableAction(
                          onPressed: (context) {
                            // Trigger delete task
                            controller
                                .deleteTask(int.parse(task.id.toString()));
                          },
                          backgroundColor: const Color(0xFFFE4A49),
                          foregroundColor: Colors.white,
                          icon: Icons.delete,
                          label: 'Delete',
                        ),
                      ],
                    ),
                    child: ListTile(
                      onTap: () {
                        controller.showTaskDetail(task, context);
                      },
                      style: ListTileStyle.drawer,
                      title: Text(
                        task.title.toString(),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          decorationThickness: 2,
                          decoration: task.isCompleted == true
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                      ),
                      subtitle: Text(
                        task.description.toString(),
                        style: TextStyle(
                          decorationThickness: 2,
                          decoration: task.isCompleted == true
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                      ),
                      trailing: Checkbox(
                        value: task.isCompleted,
                        onChanged: (value) {
                          controller.toggleCheckBox(
                              int.parse(task.id.toString()), value!);
                        },
                      ),
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
        ),
        onPressed: () {
          controller.showBottomSheet(context, false);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

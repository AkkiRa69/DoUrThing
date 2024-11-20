import 'package:flutter/material.dart';
import 'package:get/get_connect/connect.dart';
import 'package:homework6_json_server/models/task_model.dart';

class TaskService extends GetConnect {
  String url = "http://10.0.2.2:3000/tasks";

  //get ==
  Future<List<TaskModel>> fetchTasks() async {
    // Changed localhost to 10.0.2.2 for Android emulator
    final response = await get(url);
    if (response.status.hasError) {
      return Future.error(response.statusText.toString());
    } else {
      final temp = response.body as List;
      final data = temp.map((e) => TaskModel.fromJson(e)).toList();
      return data;
    }
  }

  //post == insert
  Future<void> insertTask(Map<String, dynamic> newTask) async {
    try {
      post(url, newTask);
    } catch (e) {
      debugPrint("Insert New Task Erro$e");
    }
  }

  //put == update
  Future<void> updateTask(int id, Map<String, dynamic> task) async {
    await put("$url/$id", task);
  }

  //update status
  Future<void> updateStatus(
      int id, bool isCheck, Map<String, dynamic> exitingTask) async {
    exitingTask['isCompleted'] = isCheck;
    await put("$url/$id", exitingTask);
  }

  //delete == delete
  Future<void> deletedTask(int id) async {
    await delete("$url/$id");
  }
}

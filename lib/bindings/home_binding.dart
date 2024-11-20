import 'package:get/get.dart';
import 'package:homework6_json_server/controllers/task_controller.dart';

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TaskController());
  }
}

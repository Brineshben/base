

import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../view/mappage/Controller/robotDetailsController.dart';

class HandleControllers {
  static createGetControllers() {
    Get.put(RobotStatusController());


  }

  static deleteAllGetControllers() async {
    await Get.delete<RobotStatusController>();


  }
}

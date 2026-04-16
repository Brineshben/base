

import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../view/mappage/Controller/poiController.dart';
import '../view/mappage/Controller/robotDetailsController.dart';

class HandleControllers {
  static createGetControllers() {
    Get.put(RobotStatusController());
    Get.put(PoiController());


  }

  static deleteAllGetControllers() async {
    await Get.delete<RobotStatusController>();
    await Get.delete<PoiController>();


  }
}

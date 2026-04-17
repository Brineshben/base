

import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../view/maplistpage/Controller/MaplistController.dart';
import '../view/mappage/Controller/poiController.dart';
import '../view/mappage/Controller/robotDetailsController.dart';
import '../view/settingspage/Controller/CurrentConfigController.dart';

class HandleControllers {
  static createGetControllers() {
    Get.put(RobotStatusController());
    Get.put(PoiController());
    Get.put(CurrentConfigController());
    Get.put(MapListController());


  }

  static deleteAllGetControllers() async {
    await Get.delete<RobotStatusController>();
    await Get.delete<PoiController>();
    await Get.delete<CurrentConfigController>();
    await Get.delete<MapListController>();


  }
}

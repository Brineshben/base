import 'dart:developer' as AppLogger;

import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../../service/ApiService.dart';
import '../Model/robotDetailsModel.dart';


class RobotStatusController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isLoaded = false.obs;
  RxBool isError = false.obs;
  Rx<robotDetailsModel?> robotMapData = Rx(null);

  Future<void> robotMapDataz() async {
    AppLogger.log("-----benebebn");

    isLoading.value = true;
    isLoaded.value = false;
    try {
      Map<String, dynamic> resp = await ApiServices.robotdetails();
      AppLogger.log("----quotes---$resp");
      // if (resp['status'] == 200) {
      robotMapData.value = robotDetailsModel.fromJson(resp);
      AppLogger.log("Nav State: ${robotMapData.value?.navState}");
      AppLogger.log("Distance: ${robotMapData.value?.distanceTraveled}");
      AppLogger.log("X: ${robotMapData.value?.robotPose?.x}");
      AppLogger.log("Y: ${robotMapData.value?.robotPose?.y}");
      AppLogger.log("Yaw: ${robotMapData.value?.robotPose?.yawDeg}");
        isLoading.value = true;

      // } else {
      //   isError.value = true;
      // }
    } catch (e) {
      isLoaded.value = false;

      ///popup
      ///
      ///
      ///
    } finally {
      isLoading.value = false;
    }
  }

}
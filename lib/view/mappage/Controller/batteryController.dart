import 'dart:developer' as AppLogger;

import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../../service/ApiService.dart';
import '../Model/batteryModel.dart';


class batteryController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isLoaded = false.obs;
  RxBool isError = false.obs;
  Rx<battery?> batteryData = Rx(null);

  Future<void> batteryDataz() async {
    AppLogger.log("-----robotMapDataz");

    isLoading.value = true;
    isLoaded.value = false;
    try {
      Map<String, dynamic> resp = await ApiServices.battery();
      AppLogger.log("----batteryDataz---$resp");
      if (resp['success'] == true) {
        batteryData.value = battery.fromJson(resp);
        AppLogger.log("Nav State: ${batteryData.value}");

        isLoading.value = true;

      } else {
        isError.value = true;
      }
    } catch (e) {
      isLoaded.value = false;
      AppLogger.log("Yaw: $e");

      ///popup
      ///
      ///
      ///
    } finally {
      isLoading.value = false;
    }
  }

}
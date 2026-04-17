import 'dart:developer' as AppLogger;

import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../../service/ApiService.dart';
import '../Model/currentModel.dart';


class CurrentConfigController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isLoaded = false.obs;
  RxBool isError = false.obs;
  Rx<CurrentConfigModel?> currentConfigData = Rx(null);

  Future<void> currentConfigDataz() async {
    AppLogger.log("-----robotMapDataz");

    isLoading.value = true;
    isLoaded.value = false;
    try {
      Map<String, dynamic> resp = await ApiServices.currentConfig();
      AppLogger.log("----robotMapDataz---$resp");
      if (resp['success'] == true) {
        currentConfigData.value = CurrentConfigModel.fromJson(resp);
        AppLogger.log("Nav State: ${currentConfigData.value?.ageS}");

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
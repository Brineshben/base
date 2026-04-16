import 'dart:developer' as AppLogger;

import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../../service/ApiService.dart';
import '../Model/poiModel.dart';
import '../Model/robotDetailsModel.dart';


class PoiController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isLoaded = false.obs;
  RxBool isError = false.obs;
  Rx<PoiModel?> PoiData = Rx(null);

  Future<void> PoiDataz() async {
    AppLogger.log("-----benebebn");

    isLoading.value = true;
    isLoaded.value = false;
    try {
      Map<String, dynamic> resp = await ApiServices.poiList();
      AppLogger.log("----PoiDataz---$resp");
      if (resp['success'] == true) {
      PoiData.value = PoiModel.fromJson(resp);

      isLoading.value = true;

      } else {
        isError.value = true;
      }
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
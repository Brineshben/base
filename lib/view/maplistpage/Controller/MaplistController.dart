import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:tarabase/service/ApiService.dart';

import '../Model/maplIstModel.dart';


class MapListController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isLoaded = false.obs;
  RxBool isError = false.obs;
  Rx<MapListModel?> mapListdata = Rx(null);

  RxList<Maps> mapList = <Maps>[].obs;

  Future<void> mapListDataz() async {
    isLoading.value = true;
    isLoaded.value = false;
    try {
      Map<String, dynamic> resp = await ApiServices.mapList();
      print("----talkToHumanseddf2wef-----$resp");
      if (resp['success'] == true) {
        mapListdata.value = MapListModel.fromJson(resp);
        mapList.value = mapListdata.value?.maps ?? [];
        isLoading.value = true;
      } else {
        isError.value = true;
      }
    } catch (e) {
      isLoaded.value = false;

      ///popup
    } finally {
      isLoading.value = false;
    }
  }

}
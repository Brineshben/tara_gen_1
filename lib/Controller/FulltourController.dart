import 'package:get/get.dart';

import '../Model/Navigate_model.dart';
import '../Service/Api_Service.dart';

class FullTourControllerNew extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isLoaded = false.obs;
  RxBool isError = false.obs;
  Rx<NavigationListModel?> fullTourData = Rx(null);
 RxList<NavigationData>  dataNavigation =  <NavigationData>[].obs;
 RxList<NavigationData>  newDataNavigation =  <NavigationData>[].obs;




  Future<void> fetchFullTourData() async {
    isLoading.value = true;
    isLoaded.value = false;
    isError.value = false;

    try {
      Map<String, dynamic> resp = await ApiServices.navigateoffline();

      if (resp['status'] == 'ok') {
        fullTourData.value = NavigationListModel.fromJson(resp);
        dataNavigation.value =fullTourData.value?.data ?? [] ;
        isLoaded.value = true;
      } else {
        isError.value = true;
      }
    } catch (e) {
      isError.value = true;
    } finally {
      isLoading.value = false;
    }
  }

  void  addData( NavigationData item){
    newDataNavigation.value.add(item);
    newDataNavigation.refresh();
  }

  void removeData (NavigationData item ){
    newDataNavigation.value.remove(item);
    newDataNavigation.refresh();
  }
}


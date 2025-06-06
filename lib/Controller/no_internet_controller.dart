import 'dart:io';
import 'package:get/get.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:ihub/View/Settings/no_internet.dart';

class ConnectivityController extends GetxController {
  final Connectivity _connectivity = Connectivity();
  var isConnected = true.obs;
  var isNoInternetPageShown = false;

  @override
  void onInit() {
    super.onInit();

    _connectivity.onConnectivityChanged.listen((result) async {
      bool hasConnection = result != ConnectivityResult.none;

      if (hasConnection) {
        final realInternet = await _hasInternetConnection();
        if (realInternet) {
          isConnected.value = true;

          if (isNoInternetPageShown) {
            Get.back();
            isNoInternetPageShown = false;
          }
        } else {
          _showNoInternetPage();
        }
      } else {
        _showNoInternetPage();
      }
    });
  }

  Future<bool> _hasInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  void _showNoInternetPage() {
    isConnected.value = false;
    if (!isNoInternetPageShown) {
      isNoInternetPageShown = true;
      Get.to(() => const NoInternetPage(), transition: Transition.fadeIn);
    }
  }
}

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:ihub/Controller/battery_Controller.dart';

import '../Model/background_model.dart';
import '../Service/Api_Service.dart';
import 'dart:ui' as ui;
import 'dart:typed_data';

class BackgroudController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isLoaded = false.obs;
  RxBool isError = false.obs;
  Rx<BackgroundModel?> backgroundModel = Rx(null);

  String defaultIMage = "assets/bg.jpeg";

  void resetStatus() {
    isLoading.value = false;
    isError.value = false;
  }

  Future<void> fetchBackground(int userID) async {
    isLoading.value = true;
    isLoaded.value = false;
    try {
      Map<String, dynamic> resp = await ApiServices.background(userId: userID);
      if (resp['status'] == "ok") {
        BackgroundModel backgrounddata = BackgroundModel.fromJson(resp);
        backgroundModel.value = backgrounddata;

        // Step 1: Get image from network as bytes
        final imageUrl = backgrounddata.backgroundImage ??
            defaultIMage; // or backgrounddata.bgImage etc.
        final response = await http.get(Uri.parse(imageUrl));

        if (response.statusCode == 200) {
          // Step 2: Decode image bytes to average color
          final image = await decodeImageFromList(response.bodyBytes);
          final avgColor = await getAverageColorFromUiImage(image);

          // Step 3: Estimate brightness
          final brightness = ThemeData.estimateBrightnessForColor(avgColor);
          Get.find<BatteryController>().foregroundColor.value =
              brightness == Brightness.dark ? Colors.white : Colors.black;

          print("Fetched image avg color: $avgColor, brightness: $brightness");
        }

        isLoaded.value = true;
      }
    } catch (e) {
      isLoaded.value = false;
      print(e);
    } finally {
      resetStatus();
    }
  }

  Future<Color> getAverageColorFromUiImage(ui.Image image) async {
    final byteData = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
    if (byteData == null) return Colors.transparent;

    final Uint8List pixels = byteData.buffer.asUint8List();
    int length = pixels.lengthInBytes;

    int r = 0, g = 0, b = 0, count = 0;

    for (int i = 0; i < length; i += 4) {
      r += pixels[i];
      g += pixels[i + 1];
      b += pixels[i + 2];
      count++;
    }

    return Color.fromARGB(255, r ~/ count, g ~/ count, b ~/ count);
  }
}

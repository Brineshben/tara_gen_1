import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ihub/Service/charge_service.dart';
import 'package:ihub/Utils/toast.dart';

class BatteryConfigController extends GetxController {
  // ✅ Reactive variables
  var isLoadingForUpdate = false.obs;
  var isLoadingForFetch = false.obs;
  var lowBatteryEntry = '0'.obs;
  var backToHomeEntry = '0'.obs;

  // ✅ Fetch current values from API
  Future<void> fetchChargeValues(BuildContext context) async {
    isLoadingForFetch.value = true;

    try {
      final response = await ChargeService.fetchCurrentCharge();
      print('Fetched Charge Response: $response');

      if (response['status'] == 'ok') {
        lowBatteryEntry.value =
            response['data']['low_battery_entry'].toString();
        backToHomeEntry.value =
            response['data']['back_to_home_entry'].toString();
      } else {
        _showSnack(context, 'Failed to fetch bettery data', Colors.red);
        lowBatteryEntry.value = "0";
        backToHomeEntry.value = '0';
      }
    } catch (e) {
      print('Error: $e');
      _showSnack(context, 'Something went wrong!', Colors.red);
    } finally {
      isLoadingForFetch.value = false;
    }
  }

  // ✅ Update charge values to API
  Future<void> updateChargeValues(BuildContext context) async {
    isLoadingForUpdate.value = true;

    try {
      final response = await ChargeService.updateCharge(
        batteryEntry: lowBatteryEntry.value,
        homeEntry: backToHomeEntry.value,
      );

      print('Update Response: $response');

      if (response['status'] == 'ok') {
        _showSnack(context, 'Values updated successfully!', Colors.green);
      } else {
        _showSnack(context, 'Update failed!', Colors.orange);
      }
    } catch (e) {
      print('Update Error: $e');
      _showSnack(context, 'Something went wrong!', Colors.red);
    } finally {
      isLoadingForUpdate.value = false;
    }
  }

  // ✅ Toast helper
  void _showSnack(BuildContext context, String message, Color color) {
    showTopRightToast(context: context, color: color, message: message);
  }
}

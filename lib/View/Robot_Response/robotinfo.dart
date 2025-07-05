import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ihub/Controller/Login_api_controller.dart';
import 'package:ihub/Controller/battery_Controller.dart';
import 'package:ihub/Service/sharedPreference.dart';

class RobotInfo extends StatelessWidget {
  RobotInfo({super.key});

  final loginController = Get.find<UserAuthController>();
  final batteryController = Get.find<BatteryController>();

  @override
  Widget build(BuildContext context) {
    // Load login data from SharedPreferences if null
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (loginController.loginData.value == null) {
        final storedData = await SharedPrefs().getLoginData();
        if (storedData != null) {
          loginController.loginData.value = storedData;
        }
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Robot & User Info',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.teal,
      ),
      body: Obx(() {
        final loginUser = loginController.loginData.value?.user;
        final batteryData = batteryController.batteryModel.value?.data?.first;
        final robot = batteryData?.robot;

        if (loginUser == null || robot == null) {
          return const Center(child: Text('No data found'));
        }

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text(
              "🔒 Logged-in User",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            InfoRow(label: "Username", value: loginUser.username ?? 'N/A'),
            InfoRow(label: "Email", value: loginUser.email ?? 'N/A'),
            InfoRow(label: "Role", value: loginUser.roletype ?? 'N/A'),

            const Divider(height: 30),

            const Text(
              "🤖 Robot Info",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            InfoRow(label: "Robot Name", value: robot.roboName ?? 'N/A'),
            InfoRow(label: "Robot ID", value: robot.roboId ?? 'N/A'),
            InfoRow(label: "Battery", value: "${robot.batteryStatus ?? 'N/A'}%"),
            InfoRow(label: "Position", value: robot.position ?? 'N/A'),
            InfoRow(label: "Language", value: robot.language ?? 'N/A'),
            InfoRow(label: "Subscription", value: robot.subscription == true ? "Yes" : "No"),
            InfoRow(label: "Active Status", value: robot.activeStatus == true ? "Active" : "Inactive"),
            InfoRow(label: "Charging", value: robot.charging == true ? "Yes" : "No"),
            InfoRow(label: "Docking Status", value: robot.dockingStatus ?? 'N/A'),
            InfoRow(label: "Ready to Navigate", value: robot.readyToNavigate == true ? "Yes" : "No"),
            InfoRow(label: "Motor Brake Released", value: robot.motorBrakeReleased == true ? "Yes" : "No"),
            InfoRow(label: "Emergency Stop", value: robot.emergencyStop == true ? "Pressed" : "Not Pressed"),
            InfoRow(label: "Map Enabled", value: robot.map == true ? "Yes" : "No"),
            InfoRow(label: "Quality", value: robot.quality ?? 'N/A'),
          ],
        );
      }),
    );
  }
}

class InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const InfoRow({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text("$label: ", style: const TextStyle(fontWeight: FontWeight.w600)),
          Expanded(
            child: Text(value, maxLines: 2, overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
  }
}

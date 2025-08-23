import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:ihub/Controller/Login_api_controller.dart';
import 'package:ihub/Controller/battery_Controller.dart';
import 'package:ihub/Service/sharedPreference.dart';

class RobotInfo extends StatelessWidget {
  RobotInfo({super.key});

  final loginController = Get.find<UserAuthController>();
  final batteryController = Get.find<BatteryController>();

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (loginController.loginData.value == null) {
        final storedData = await SharedPrefs().getLoginData();
        if (storedData != null) {
          loginController.loginData.value = storedData;
        }
      }
    });

    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.topRight,
            radius: 1.5,
            colors: [
              Color(0xFF0A0A0A),
              Color(0xFF000000),
            ],
            stops: [0.1, 0.9],
          ),
        ),
        child: Obx(() {
          final loginUser = loginController.loginData.value?.user;
          final batteryData = batteryController.batteryModel.value?.data?.first;
          final robot = batteryData?.robot;

          if (loginUser == null || robot == null) {
            return const Center(
              child: GlassContainer(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    'No data found\nPlease check your connection',
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            );
          }

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 200,
                collapsedHeight: 80,
                pinned: true,
                stretch: true,
                backgroundColor: Colors.transparent,
                flexibleSpace: FlexibleSpaceBar(
                  title: const Text(
                    'Robot & User Info',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.teal.withOpacity(0.3),
                          Colors.transparent,
                        ],
                      ),
                    ),
                    child: const Center(
                      child: Icon(
                        Iconsax.cpu,
                        size: 64,
                        color: Colors.teal,
                      ),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // User Info Section
                      GlassContainer(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Row(
                                children: [
                                  Icon(Iconsax.user,
                                      size: 20, color: Colors.teal),
                                  SizedBox(width: 8),
                                  Text(
                                    "Logged-in User",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              InfoRow(
                                icon: Iconsax.user_tag,
                                label: "Username",
                                value: loginUser.username ?? 'N/A',
                              ),
                              InfoRow(
                                icon: Iconsax.sms,
                                label: "Email",
                                value: loginUser.email ?? 'N/A',
                              ),
                              InfoRow(
                                icon: Iconsax.shield,
                                label: "Role",
                                value: loginUser.roletype ?? 'N/A',
                                isRole: true,
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Robot Info Section
                      GlassContainer(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Row(
                                children: [
                                  Icon(Iconsax.cpu,
                                      size: 20, color: Colors.teal),
                                  SizedBox(width: 8),
                                  Text(
                                    "Robot Information",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),

                              // Battery Status with Visual Indicator
                              BatteryStatusWidget(
                                  batteryLevel: int.parse(robot.batteryStatus ?? "0")),

                              const SizedBox(height: 16),

                              // Grid Layout for Robot Info
                              GridView(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 12,
                                  mainAxisSpacing: 12,
                                  childAspectRatio: 4,
                                ),
                                children: [
                                  InfoChip(
                                    icon: Iconsax.cpu,
                                    label: "Robot Name",
                                    value: robot.roboName ?? 'N/A',
                                  ),
                                  InfoChip(
                                    icon: Iconsax.tag,
                                    label: "Robot ID",
                                    value: robot.roboId ?? 'N/A',
                                  ),
                                  StatusChip(
                                    icon: Iconsax.location,
                                    label: "Position",
                                    value: robot.position ?? 'N/A',
                                    isActive: robot.position != null,
                                  ),
                                  StatusChip(
                                    icon: Iconsax.language_circle,
                                    label: "Language",
                                    value: robot.language ?? 'N/A',
                                    isActive: robot.language != null,
                                  ),
                                  StatusChip(
                                    icon: Iconsax.crown,
                                    label: "Subscription",
                                    value: robot.subscription == true
                                        ? "Active"
                                        : "Inactive",
                                    isActive: robot.subscription == true,
                                  ),
                                  StatusChip(
                                    icon: Iconsax.activity,
                                    label: "Status",
                                    value: robot.activeStatus == true
                                        ? "Online"
                                        : "Offline",
                                    isActive: robot.activeStatus == true,
                                  ),
                                  StatusChip(
                                    icon: Iconsax.flash,
                                    label: "Charging",
                                    value: robot.charging == true
                                        ? "Charging"
                                        : "Not Charging",
                                    isActive: robot.charging == true,
                                  ),
                                  StatusChip(
                                    icon: Icons.home,
                                    label: "Docking",
                                    value: robot.dockingStatus ?? 'N/A',
                                    isActive: robot.dockingStatus != null,
                                  ),
                                ],
                              ),

                              const SizedBox(height: 16),

                              // Advanced Status Indicators
                              const Text(
                                "System Status",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white70,
                                ),
                              ),
                              const SizedBox(height: 12),

                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: [
                                  StatusIndicator(
                                    label: "Navigation",
                                    isActive: robot.readyToNavigate == true,
                                    icon: Icons.navigation,
                                  ),
                                  StatusIndicator(
                                    label: "Motor Brake",
                                    isActive: robot.motorBrakeReleased == true,
                                    icon: Icons.energy_savings_leaf,
                                  ),
                                  StatusIndicator(
                                    label: "Emergency",
                                    isActive: robot.emergencyStop != true,
                                    icon: Icons.warning,
                                    isWarning: true,
                                  ),
                                  StatusIndicator(
                                    label: "Map Enabled",
                                    isActive: robot.map == true,
                                    icon: Icons.map,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}

class GlassContainer extends StatelessWidget {
  final Widget child;
  final double blurStrength;
  final double borderRadius;

  const GlassContainer({
    super.key,
    required this.child,
    this.blurStrength = 10,
    this.borderRadius = 20,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.2),
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(
            sigmaX: blurStrength,
            sigmaY: blurStrength,
          ),
          child: child,
        ),
      ),
    );
  }
}

class InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool isRole;

  const InfoRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.isRole = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.teal.withOpacity(0.8)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    color: isRole ? Colors.teal : Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class BatteryStatusWidget extends StatelessWidget {
  final int batteryLevel;

  const BatteryStatusWidget({super.key, required this.batteryLevel});

  @override
  Widget build(BuildContext context) {
    Color batteryColor;
    if (batteryLevel > 70) {
      batteryColor = Colors.teal;
    } else if (batteryLevel > 30) {
      batteryColor = Colors.orange;
    } else {
      batteryColor = Colors.red;
    }

    return GlassContainer(
      borderRadius: 15,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.battery_full, color: batteryColor),
                    const SizedBox(width: 8),
                    Text(
                      "Battery Level",
                      style: TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Text(
                  "$batteryLevel%",
                  style: TextStyle(
                    color: batteryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Stack(
              children: [
                Container(
                  height: 6,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeOut,
                  height: 6,
                  width:
                      (batteryLevel / 100) * MediaQuery.of(context).size.width -
                          64,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        batteryColor,
                        batteryColor.withOpacity(0.7),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const InfoChip({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      borderRadius: 12,
      blurStrength: 5,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Icon(icon, size:20, color: Colors.teal),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 10,
                    ),
                  ),
                  Text(
                    value,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StatusChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool isActive;

  const StatusChip({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      borderRadius: 12,
      blurStrength: 5,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: isActive ? Colors.teal : Colors.grey,
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 10,
                    ),
                  ),
                  Text(
                    value,
                    style: TextStyle(
                      color: isActive ? Colors.teal : Colors.grey,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StatusIndicator extends StatelessWidget {
  final String label;
  final bool isActive;
  final IconData icon;
  final bool isWarning;

  const StatusIndicator({
    super.key,
    required this.label,
    required this.isActive,
    required this.icon,
    this.isWarning = false,
  });

  @override
  Widget build(BuildContext context) {
    Color color;
    if (isWarning) {
      color = isActive ? Colors.green : Colors.red;
    } else {
      color = isActive ? Colors.teal : Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 4),
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }
}

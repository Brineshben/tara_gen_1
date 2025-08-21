import 'dart:async';
import 'dart:ui';

import 'package:action_slider/action_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ihub/Controller/Login_api_controller.dart';
import 'package:ihub/Controller/RobotresponseApi_controller.dart';
import 'package:ihub/Controller/Volume_Controller.dart';
import 'package:ihub/Controller/battery_Controller.dart';
import 'package:ihub/Service/Api_Service.dart';
import 'package:ihub/Service/url_service.dart';
import 'package:ihub/Utils/api_constant.dart' as ApiService;
import 'package:ihub/Utils/company_logo.dart';
import 'package:ihub/Utils/glassmorphism.dart';
import 'package:ihub/View/Splash/Loading_Splash.dart';
import 'package:ihub/View/welcome/capture_image.dart';
import 'package:ihub/View/welcome/menu.dart';
import 'package:ihub/View/welcome/navigation_charge_tab.dart';
import 'package:lottie/lottie.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool canExit = false;
  Timer? fiveSecTimer;
  Timer? oneSecTimer;
  @override
  void initState() {
    super.initState();
    _hideSystemUI();

    Get.find<BatteryController>().fetchBattery(
        Get.find<UserAuthController>().loginData.value?.user?.id ?? 0, context);

    _fetchUrls();

    Get.find<RobotresponseapiController>().getUrl();

    fiveSecTimer = Timer.periodic(Duration(seconds: 3), (timer) async {
      if (!mounted) {
        timer.cancel();
        return;
      }
      // get robot wifi ip
      ApiService.fetchAndUpdateBaseUrl();

      // fetch robot battery data
      Get.find<BatteryController>().fetchBattery(
          Get.find<UserAuthController>().loginData.value?.user?.id ?? 0,
          context);

      Map<String, dynamic> resp = await ApiServices.loading();
      if (resp['status'] != "ON") {
        fiveSecTimer?.cancel();
        Get.offAll(() => LoadingSplash());
      }
    });

    oneSecTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      Get.find<RobotresponseapiController>().communicationStatus(context);
      Get.find<BatteryController>().checkCharging();
    });
  }

  void _hideSystemUI() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  }

  // @override
  // void dispose() {
  //   fiveSecTimer?.cancel();
  //   oneSecTimer?.cancel();
  //   super.dispose();
  // }

  Future<void> _fetchUrls() async {
    Get.find<RobotresponseapiController>().getUrl();
  }

  bool showVolumeControl = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
          setState(() {
            showVolumeControl = false;
          });
        },
        child: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/bg.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: MediaQuery.of(context).size.width * 0.02,
                ),
                child: Row(
                  children: [
                    Expanded(flex: 2, child: _buildLeftContent()),
                    const Spacer(flex: 1),
                    Expanded(
                      flex: 3,
                      child: Column(
                        children: [
                          GetX<BatteryController>(
                            builder: (batteryController) {
                              final robot = batteryController
                                  .batteryModel.value?.data?.first.robot;

                              return Padding(
                                padding: const EdgeInsets.only(top: 30),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  spacing: 20,
                                  children: [
                                    // Brake Button (show only when motorBrakeReleased == true)
                                    if (robot?.motorBrakeReleased ?? false)
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(16),
                                        child: BackdropFilter(
                                          filter: ImageFilter.blur(
                                              sigmaX: 10, sigmaY: 10),
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20, vertical: 10),
                                            decoration: BoxDecoration(
                                              color:
                                                  Colors.black.withOpacity(0.3),
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                              border: Border.all(
                                                  color: Colors.white
                                                      .withOpacity(0.2)),
                                            ),
                                            child: const Row(
                                              children: [
                                                Icon(Icons.stop,
                                                    color: Colors.white),
                                                SizedBox(width: 8),
                                                Text(
                                                  "Brake",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),

                                    // Emergency Button (show only when emergencyStop == true)
                                    if (robot?.emergencyStop ?? false)
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(16),
                                        child: BackdropFilter(
                                          filter: ImageFilter.blur(
                                              sigmaX: 10, sigmaY: 10),
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20, vertical: 10),
                                            decoration: BoxDecoration(
                                              color:
                                                  Colors.black.withOpacity(0.3),
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                              border: Border.all(
                                                  color: Colors.white
                                                      .withOpacity(0.2)),
                                            ),
                                            child: const Row(
                                              children: [
                                                Icon(Icons.warning,
                                                    color: Colors.white),
                                                SizedBox(width: 8),
                                                Text(
                                                  "Emergency",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),

                                    // Q Value Display
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(16),
                                      child: BackdropFilter(
                                        filter: ImageFilter.blur(
                                            sigmaX: 10, sigmaY: 10),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 10),
                                          decoration: BoxDecoration(
                                            color:
                                                Colors.black.withOpacity(0.3),
                                            borderRadius:
                                                BorderRadius.circular(16),
                                            border: Border.all(
                                                color: Colors.white
                                                    .withOpacity(0.2)),
                                          ),
                                          child: Text(
                                            "Q: ${(robot?.quality ?? 0)}",
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          Expanded(child: _buildGlassmorphicPanel(context)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (showVolumeControl)
              GetX<VolumeController>(
                builder: (columeController) {
                  return Positioned(
                    top: MediaQuery.of(context).size.height * 0.2,
                    right: 20,
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.7,
                      width: 80,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(color: Colors.white30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Expanded(
                              child: RotatedBox(
                                quarterTurns: -1,
                                child: SliderTheme(
                                  data: SliderTheme.of(context).copyWith(
                                    trackHeight: 40,
                                    activeTrackColor: Colors.white.withOpacity(
                                      1,
                                    ),
                                    inactiveTrackColor: Colors.grey.withOpacity(
                                      0.3,
                                    ),
                                    thumbColor: Colors.grey.shade700,
                                    thumbShape: RoundSliderThumbShape(
                                      enabledThumbRadius: 12,
                                    ),
                                    overlayColor: Colors.blueAccent.withOpacity(
                                      0.2,
                                    ),
                                    overlayShape: RoundSliderOverlayShape(
                                      overlayRadius: 28.0,
                                    ),
                                    valueIndicatorColor: Colors.transparent,
                                  ),
                                  child: Slider(
                                    value: columeController.roboVolume.value
                                        .toDouble(),
                                    min: 0,
                                    max: 100,
                                    divisions: 100,
                                    onChanged: (v) => columeController
                                        .roboVolume.value = v.toInt(),
                                    onChangeEnd: (v) =>
                                        Get.find<VolumeController>()
                                            .updatedVolume(
                                                Get.find<BatteryController>()
                                                    .roboId
                                                    .toString(),
                                                v.toInt(),
                                                context),
                                  ),
                                ),
                              ),
                            ),
                            Icon(
                              columeController.roboVolume.value == 0
                                  ? Icons.volume_mute_rounded
                                  : columeController.roboVolume.value > 60
                                      ? Icons.volume_up
                                      : Icons.volume_down,
                              color: Colors.white,
                            ),
                            Text(
                              "${columeController.roboVolume.value.round()}%",
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            Positioned(
              top: 40,
              left: 40,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                spacing: 20,
                children: [
                  const CompnayLogo(),
                  ChildGlasmorphism(
                    borderRadius: 20,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: Obx(
                        () => Row(
                          children: [
                            Icon(
                              Icons.link,
                              color: Colors.white,
                            ),
                            Text(
                              "${Get.find<RobotresponseapiController>().name.value}",
                              style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeftContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'TARA GEN 1',
              style: GoogleFonts.poppins(
                fontSize: MediaQuery.sizeOf(context).height * 0.07,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Discover cutting-edge work from top robotics engineers and designers, ready to bring innovation to your next intelligent machine or automation project.',
              style: GoogleFonts.poppins(fontSize: 12, color: Colors.white70),
            ),
            GetX<RobotresponseapiController>(builder: (controller) {
              return Column(
                children: [
                  SizedBox(height: 50),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (controller.responseData.value.speaking == true)
                        Lottie.asset(
                          "assets/speak.json",
                          height: MediaQuery.sizeOf(context).height * 0.3,
                          fit: BoxFit.contain,
                        ),
                      if (controller.responseData.value.listening == true)
                        Lottie.asset(
                          "assets/Listen.json",
                          height: MediaQuery.sizeOf(context).height * 0.3,
                          fit: BoxFit.contain,
                        ),
                    ],
                  ),
                  if (controller.robotResponseModel.value?.text != null &&
                      controller.robotResponseModel.value?.text != '')
                    Container(
                      width: MediaQuery.of(context).size.width * 0.5,
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black45,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          controller.robotResponseModel.value?.text ?? '',
                          style: TextStyle(fontSize: 12, color: Colors.white),
                        ),
                      ),
                    )
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildGlassmorphicPanel(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 50),
      child: BaseGlassmorphism(
        borderRadius: 30,
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: _menuButton(
                      label: "Battery",
                      onPressed: () {
                      

                            setState(() {
                            showVolumeControl = false;
                          });
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NavigationScreen(
                                selectedTabIndex: 1,
                              ),
                            ),
                          );
                        
                      },
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: _menuButton(
                      icon: "assets/Volume.svg",
                      label: "Volume",
                      onPressed: () {
                        Get.find<VolumeController>().fetchinitialvolume(
                            Get.find<BatteryController>().roboId.toString(),
                            context);

                        if (showVolumeControl) {
                          setState(() {
                            showVolumeControl = false;
                          });
                        } else {
                          setState(() {
                            showVolumeControl = true;
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: _menuButton(
                      icon: "assets/Home.svg",
                      label: "Menu",
                      onPressed: () {
                       
                         setState(() {
                          showVolumeControl = false;
                        });
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MenuScreen()));
                      },
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    flex: 5,
                    child: _menuButton(
                      icon: "assets/selfie.svg",
                      label: "Take a Selfie",
                      onPressed: () {
                         setState(() {
                            showVolumeControl = false;
                          });
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CaptureAndQrPage()));
                        
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            _buildLetsGoButton(context),
          ],
        ),
      ),
    );
  }

  Widget _menuButton({
    String? icon,
    required String label,
    required Function onPressed,
  }) {
    return GetX<BatteryController>(
      builder: (controller) {
        return ChildGlasmorphism(
          borderRadius: 20,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(69, 48, 48, 48),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(vertical: 10),
            ),
            onPressed: () => onPressed(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: icon == null && controller.onDock.value ? 20 : 0,
              children: [
                controller.onDock.value && icon == null
                    ? Image.asset(
                        "assets/zap.png",
                        width: 40,
                        color: Colors.green,
                      )
                    : SizedBox(),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    icon != null
                        ? SvgPicture.asset(
                            icon,
                            color: Colors.white,
                            width: MediaQuery.of(context).size.width * 0.06,
                          )
                        : _buildBatteryWidget(controller.batteryStatus.value),
                    const SizedBox(height: 8),
                    Text(label, style: GoogleFonts.poppins(fontSize: 18)),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBatteryWidget(int percentage) {
    Color getBatteryColor(int percentage) {
      if (percentage <= 20) {
        return Colors.red;
      } else if (percentage <= 60) {
        return Colors.orange;
      } else {
        return Colors.green;
      }
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 80,
          height: 40,
          padding: EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(color: Colors.white, width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Stack(
            children: [
              // Fill color
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    width: (74 * (percentage / 100)).clamp(0, 74),
                    color: getBatteryColor(percentage),
                  ),
                ),
              ),
              // Percentage text
              Center(
                child: Text(
                  '$percentage%',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 5),
        Container(
          width: 4,
          height: 18,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ],
    );
  }

  Widget _buildLetsGoButton(BuildContext context) {
    return ChildGlasmorphism(
      borderRadius: 60,
      child: ActionSlider.standard(
        width: double.infinity,
        height: 90,
        backgroundColor: Colors.white.withOpacity(0.15),
        toggleColor: Colors.white,
        icon: const Icon(
          Icons.arrow_forward,
          color: Color.fromARGB(161, 0, 0, 0),
          size: 40,
        ),
        child: ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [
              Color(0xFFB0B0B0), // light grey
              Color(0xFFB0B0B0), // light grey
              Color(0xFF707070), // medium grey
              Color.fromARGB(255, 89, 89, 89), // dark grey
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ).createShader(bounds),
          child: Text(
            'Navigate',
            style: GoogleFonts.poppins(
              fontSize: 28,
              fontWeight: FontWeight.w600,
              color: Colors.white, // overridden by shader
            ),
          ),
        ),
        action: (controller) async {
          controller.loading();
          await Future.delayed(const Duration(milliseconds: 300));
          controller.success();
          await Future.delayed(const Duration(milliseconds: 400));
          controller.reset();
        
              setState(() {
              showVolumeControl = false;
            });
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NavigationScreen(
                  selectedTabIndex: 0,
                ),
              ),
            );
          
        },
      ),
    );
  }
}

import 'dart:async';
import 'dart:ui';

import 'package:action_slider/action_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ihub/Controller/Login_api_controller.dart';
import 'package:ihub/Controller/Navigate_Controller.dart';
import 'package:ihub/Controller/RobotresponseApi_controller.dart';
import 'package:ihub/Controller/Volume_Controller.dart';
import 'package:ihub/Controller/battery_Controller.dart';
import 'package:ihub/Service/Api_Service.dart';
import 'package:ihub/Utils/api_constant.dart' as ApiService;
import 'package:ihub/Utils/company_logo.dart';
import 'package:ihub/Utils/glassmorphism.dart';
import 'package:ihub/Utils/toast.dart';
import 'package:ihub/Utils/web_view.dart';
import 'package:ihub/View/Splash/Loading_Splash.dart';
import 'package:ihub/View/welcome/animated_navigate_text.dart';
import 'package:ihub/View/welcome/capture_image.dart';
import 'package:ihub/View/welcome/menu.dart';
import 'package:ihub/View/welcome/navigation_charge_tab.dart';
import 'package:ihub/View/welcome/particlesphere%20.dart';

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

    ApiService.fetchAndUpdateBaseUrl();

    Get.find<RobotresponseapiController>().getUrl();

    fiveSecTimer = Timer.periodic(Duration(seconds: 3), (timer) async {
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

  @override
  Widget build(BuildContext context) {
    final sphereKey = GlobalKey<InteractiveParticleSphereState>();

    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
          Get.find<VolumeController>().showVolumeControl.value = false;
        },
        child: Stack(
          children: [
            Container(
              decoration:  BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/bg.png'), // bg
                  // image: AssetImage('assets/myg.jpg'), // myg
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
                    Expanded(flex: 2, child: _buildLeftContent(sphereKey)),
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
                                padding: const EdgeInsets.only(top: 20),
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
                                      borderRadius: BorderRadius.circular(10),
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
                                                BorderRadius.circular(10),
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
            Positioned(
              top: 40,
              left: 40,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                spacing: 20,
                children: [
                  const CompnayLogo(),
                  if (Get.find<RobotresponseapiController>()
                      .name
                      .value
                      .isNotEmpty)
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => InAppWebViewScreen(
                                url: Get.find<RobotresponseapiController>()
                                    .link
                                    .toString()),
                          ),
                        );
                      },
                      child: ChildGlasmorphism(
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
                    ),
                ],
              ),
            ),
            Obx(() {
              final volumeController = Get.find<VolumeController>();
              if (!volumeController.showVolumeControl.value) {
                return const SizedBox.shrink();
              }
              return Positioned(
                top: MediaQuery.of(context).size.height * 0.3,
                right: 14,
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.5,
                  width: 80,
                  child: Column(
                    children: [
                      Expanded(
                        child: RotatedBox(
                          quarterTurns: -1,
                          child: SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              trackHeight: 40,
                              activeTrackColor: Colors.transparent,
                              inactiveTrackColor: Colors.transparent,
                              thumbColor: Colors.grey,
                              thumbShape: RoundSliderThumbShape(
                                enabledThumbRadius: 15
                              ),
                              overlayColor:
                                  Colors.grey.withOpacity(0.2),
                              overlayShape: RoundSliderOverlayShape(
                                overlayRadius: 30,
                              ),
                              valueIndicatorColor: Colors.transparent,
                              trackShape: GradientRectSliderTrackShape(),
                            ),
                            child: Slider(
                              value: volumeController.roboVolume.value
                                  .toDouble(),
                              min: 0,
                              max: 100,
                              divisions: 100,
                              onChanged: (v) {
                                volumeController.roboVolume.value = v.toInt();
                                volumeController.resetTimer();
                              },
                              onChangeEnd: (v) {
                                Get.find<VolumeController>().updatedVolume(
                                  Get.find<BatteryController>()
                                      .roboId
                                      .toString(),
                                  v.toInt(),
                                  context,
                                );
                  
                                volumeController.resetTimer();
                              },
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Icon(
                        volumeController.roboVolume.value == 0
                            ? Icons.volume_mute_rounded
                            : volumeController.roboVolume.value > 60
                                ? Icons.volume_up
                                : Icons.volume_down,
                        color: Colors.white,
                      ),
                      SizedBox(height: 10),
                      Text(
                        "${volumeController.roboVolume.value.round()}%",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            })
          ],
        ),
      ),
    );
  }

  Widget _buildLeftContent(
      GlobalKey<InteractiveParticleSphereState> sphereKey) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 90),
          Text(
            'TARA GEN 1',
            style: GoogleFonts.poppins(
              fontSize: MediaQuery.sizeOf(context).height * 0.07,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            'Discover cutting-edge work from top robotics engineers and designers, ready to bring innovation to your next intelligent machine or automation project.',
            style: GoogleFonts.poppins(fontSize: 12, color: Colors.white70),
          ),
          GetX<RobotresponseapiController>(builder: (controller) {
            return Column(
              children: [
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     if (controller.responseData.value.speaking == false)
                //       Lottie.asset(
                //         "assets/speak.json",
                //         height: MediaQuery.sizeOf(context).height * 0.3,
                //         fit: BoxFit.contain,
                //       ),
                //     if (controller.responseData.value.listening == false)
                //       Lottie.asset(
                //         "assets/Listen.json",
                //         height: MediaQuery.sizeOf(context).height * 0.3,
                //         fit: BoxFit.contain,
                //       ),
                //   ],
                // ),

                Obx(() {
                  final isSpeaking =
                      controller.responseData.value.speaking ?? false;
                  final isListening =
                      controller.responseData.value.listening ?? false;

                  // Trigger after widget is built
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (isSpeaking) {
                      sphereKey.currentState?.speaking();
                    } else if (isListening) {
                      sphereKey.currentState?.listening();
                    }
                  });

                  return Column(
                    children: [
                      SizedBox(height: 30),
                      Text(
                        isSpeaking
                            ? "Speaking..."
                            : isListening
                                ? "Listening..."
                                : "",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      InteractiveParticleSphere(
                        key: sphereKey,
                        size: 300,
                      ),
                    ],
                  );
                }),

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
                        Get.find<VolumeController>().showVolumeControl.value =
                            false;

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

                        if (Get.find<VolumeController>()
                            .showVolumeControl
                            .value) {
                          Get.find<VolumeController>().showVolumeControl.value =
                              false;
                        } else {
                          Get.find<VolumeController>().showVolumeControl.value =
                              true;
                        }

                        Get.find<VolumeController>().showControlWithTimer();
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
                        Get.find<VolumeController>().showVolumeControl.value =
                            false;
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
                        Get.find<VolumeController>().showVolumeControl.value =
                            false;
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
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                icon != null
                    ? SvgPicture.asset(
                        icon,
                        color: Colors.white,
                        width: MediaQuery.of(context).size.width * 0.06,
                      )
                    : BatteryWidget(),
                const SizedBox(height: 8),
                Text(label, style: GoogleFonts.poppins(fontSize: 18)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLetsGoButton(BuildContext context) {
    return GetX<BatteryController>(builder: (batteryController) {
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
            // child: Text(
            //   'Navigate',
            //   style: GoogleFonts.poppins(
            //     fontSize: 28,
            //     fontWeight: FontWeight.w600,
            //     color: Colors.white, // overridden by shader
            //   ),
            // ),
            child: AnimatedTextGradient(
              fontSize: 28,
              text: batteryController.onDock.value ? "Home" : "Navigate",
            ),
          ),
          action: (controller) async {
            controller.loading();
            await Future.delayed(const Duration(milliseconds: 300));
            controller.success();
            await Future.delayed(const Duration(milliseconds: 400));
            controller.reset();

            Get.find<VolumeController>().showVolumeControl.value = false;

            if (batteryController.onDock.value) {
              navigateToHome('home');
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NavigationScreen(
                    selectedTabIndex: 0,
                  ),
                ),
              );
            }
          },
        ),
      );
    });
  }

  void navigateToHome(String name) async {
    try {
      final controller = Get.find<NavigateController>();

      final item = controller.dataList.firstWhere(
        (e) => e?.name?.toLowerCase() == name.toLowerCase(),
        orElse: () => null,
      );

      if (item == null) {
        showTopRightToast(
            message: "$name location not found.", color: Colors.orange);
        return;
      }

      await ApiServices.destination(id: item.id ?? 0);
      await Future.delayed(Duration(seconds: 2));

      final resp = await ApiServices.robotbasestatus();
      final bool status = resp['status'] == true;
      final String message =
          status ? "Heading to ${item.name}" : "Command already received";

      showTopRightToast(
          message: message, color: status ? Colors.green : Colors.orange);
    } catch (e) {
      showTopRightToast(message: "Something went wrong", color: Colors.red);
    }
  }
}

// Custom track shape class to add at the top of your file
class GradientRectSliderTrackShape extends SliderTrackShape
    with BaseSliderTrackShape {
  const GradientRectSliderTrackShape();

  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double trackHeight = sliderTheme.trackHeight!;
    final double trackLeft = offset.dx;
    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight) / 2;
    final double trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }

  @override
  void paint(
    PaintingContext context,
    Offset offset, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required TextDirection textDirection,
    required Offset thumbCenter,
    Offset? secondaryOffset,
    bool isDiscrete = false,
    bool isEnabled = false,
  }) {
    final Rect trackRect = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
    );

    final Canvas canvas = context.canvas;
    final Paint paint = Paint();

    // Create gradient from bottom to top (low to high)
    // Since the slider is rotated, we need to adjust the gradient direction
    paint.shader = LinearGradient(
      begin: Alignment.bottomCenter, // This becomes bottom after rotation
      end: Alignment.centerRight, // This becomes top after rotation
      colors: [
        Colors.black.withOpacity(0.4), // Low volume - red
        Colors.white, // High volume - green
      ],
      stops: const [0.0, 1.0],
    ).createShader(trackRect);

    // Draw the gradient track
    canvas.drawRRect(
      RRect.fromRectAndRadius(trackRect, const Radius.circular(20)),
      paint,
    );

    // Optional: Add a subtle border
    final Paint borderPaint = Paint()
      ..color = Colors.white.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    canvas.drawRRect(
      RRect.fromRectAndRadius(trackRect, const Radius.circular(20)),
      borderPaint,
    );
  }
}

class BatteryWidget extends StatefulWidget {
  const BatteryWidget({
    super.key,
  });

  @override
  State<BatteryWidget> createState() => _BatteryWidgetState();
}

class _BatteryWidgetState extends State<BatteryWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(); // loop animation
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color getBatteryColor(int percentage) {
    if (percentage <= 20) {
      return Colors.red;
    } else if (percentage <= 60) {
      return Colors.orange;
    } else {
      return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetX<BatteryController>(builder: (controller) {
      final color = getBatteryColor(controller.batteryStatus.value);
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 100,
            height: 50,
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(color: Colors.white, width: 2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: AnimatedBuilder(
                      animation: _controller,
                      builder: (context, child) {
                        final fillWidth =
                            (74 * (controller.batteryStatus.value / 100))
                                .clamp(0, 74)
                                .toDouble();
                        // If charging → apply animated gradient
                        return Container(
                          width: fillWidth,
                          decoration: BoxDecoration(
                            color: controller.onDock.value ? null : color,
                            gradient: controller.onDock.value
                                ? LinearGradient(
                                    begin: Alignment(
                                        -1 + _controller.value * 2, 0),
                                    end:
                                        Alignment(1 + _controller.value * 2, 0),
                                    colors: [
                                      color.withOpacity(0.4),
                                      color,
                                      color.withOpacity(0.4),
                                    ],
                                  )
                                : null,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      controller.onDock.value ? Icon(Icons.bolt) : Container(),
                      Text(
                        '${controller.batteryStatus.value}%',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 5),
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
    });
  }
}

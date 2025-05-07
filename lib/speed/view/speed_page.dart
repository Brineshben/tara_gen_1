import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ihub/Controller/Backgroud_controller.dart';
import 'package:ihub/speed/controller/speed_controller.dart';

class SpeedControllerPage extends StatefulWidget {
  const SpeedControllerPage({super.key});

  @override
  _SpeedControllerPageState createState() => _SpeedControllerPageState();
}

class _SpeedControllerPageState extends State<SpeedControllerPage> {
  @override
  void initState() {
    _hideSystemUI();
    Get.find<SpeedController>().fetchSpeed();
    super.initState();
  }

  void _hideSystemUI() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            width: ScreenUtil().screenWidth,
            height: ScreenUtil().screenHeight,
          ),
          GetX<BackgroudController>(
            builder: (BackgroudController controller) {
              return Positioned.fill(
                child: CachedNetworkImage(
                  imageUrl:
                      controller.backgroundModel.value?.backgroundImage ?? "",
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                      Image.asset("assets/images.jpg", fit: BoxFit.cover),
                  errorWidget: (context, url, error) =>
                      Image.asset("assets/images.jpg", fit: BoxFit.cover),
                ),
              );
            },
          ),
          Column(children: [
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 40, bottom: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 60.h,
                      width: 60.h,
                      decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(15).r),
                      child: Icon(
                        Icons.arrow_back_outlined,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "SPEED",
                    style: GoogleFonts.oxygen(
                        color: Colors.white,
                        fontSize: 25.h,
                        fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
          ]),
          Center(
            child: GetX<SpeedController>(
              builder: (SpeedController controller) {
                if (controller.isLoading.value) {
                  return CircularProgressIndicator(color: Colors.white);
                }
                return SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // controller.speed.value <= 0.3
                      //     ? Lottie.asset('assets/slow-speed.json', width: 265)
                      //     : controller.speed.value <= 0.5
                      //     ? Lottie.asset('assets/modarate.json', width: 200)
                      //     : Lottie.asset('assets/fastspeed.json', width: 200),
                      Container(
                        width: MediaQuery.of(context).size.height * 0.3,
                        height: MediaQuery.of(context).size.height * 0.3,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: controller.speed.value <= 0.3
                                ? Colors.green
                                : controller.speed.value <= 0.5
                                    ? Colors.orange
                                    : Colors.red,
                            width: 4,
                          ),
                        ),
                        child: Icon(
                          Icons.speed_outlined,
                          size: MediaQuery.of(context).size.height * 0.2,
                          color: controller.speed.value <= 0.3
                              ? Colors.green
                              : controller.speed.value <= 0.5
                                  ? Colors.orange
                                  : Colors.red,
                        ),
                      ),
                      SizedBox(height: 30),

                      Text(
                        "Speed: ${controller.speed.value.toStringAsFixed(2)}",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: controller.speed.value <= 0.3
                              ? Colors.green
                              : controller.speed.value <= 0.5
                                  ? Colors.orange
                                  : Colors.red,
                        ),
                      ),
                      SizedBox(height: 20),

                      // Plus and Minus buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(10),
                              onTap: () {
                                double newSpeed = controller.speed.value - 0.1;
                                if (newSpeed >= 0.1) {
                                  controller.speed.value = newSpeed;
                                  controller.updateSpeed(newSpeed);
                                  HapticFeedback.mediumImpact();
                                }
                              },
                              child: Ink(
                                width: 200,
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: const EdgeInsets.all(12),
                                child: const Icon(
                                  Icons.remove,
                                  size: 30,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 30),
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(10),
                              onTap: () {
                                double newSpeed = controller.speed.value + 0.1;
                                if (newSpeed <= 0.7) {
                                  controller.speed.value = newSpeed;
                                  controller.updateSpeed(newSpeed);
                                  HapticFeedback.mediumImpact();
                                }
                              },
                              child: Ink(
                                width: 200,
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: const EdgeInsets.all(12),
                                child: const Icon(
                                  Icons.add,
                                  size: 30,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

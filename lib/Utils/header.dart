import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_getx_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ihub/Controller/battery_Controller.dart';
import 'package:ihub/View/Home_Screen/battery_Widget.dart';

class Header extends StatelessWidget {
  final bool isBack;
  final bool isEnableRouter;
  final bool isLanguage;
  final String screenName;
  const Header({
    super.key,
    required this.isBack,
    required this.screenName,
    this.isEnableRouter = true,
    this.isLanguage = true,
  });

  @override
  Widget build(BuildContext context) {
    return GetX<BatteryController>(
      builder: (BatteryController controller) {
        Color? roboColor;
        String? quality;
        bool? brake;
        bool? EmergencyStop;
        if (controller.background.value?.data!.isNotEmpty ?? false) {
          roboColor = controller.background.value?.data?.first.robot?.map !=
                  null
              ? (controller.background.value?.data?.first.robot?.map ?? false)
                  ? Colors.green
                  : Colors.red
              : null;

          quality =
              controller.background.value?.data?.first.robot?.quality ?? "";
          brake = controller
              .background.value?.data?.first.robot?.motorBrakeReleased;

          EmergencyStop =
              controller.background.value?.data?.first.robot?.emergencyStop;
        }
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            isBack
                ? Padding(
                    padding:
                        const EdgeInsets.only(left: 20, top: 30, right: 20),
                    child: Row(
                      children: [
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            borderRadius: BorderRadius.circular(15.r),
                            child: Container(
                              height: 60.h,
                              width: 60.h,
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(15.r),
                              ),
                              child: Icon(Icons.arrow_back_outlined,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Center(
                          child: Text(
                            "$screenName",
                            style: GoogleFonts.poppins(
                                color: controller.foregroundColor.value,
                                fontSize: 25.h,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      ],
                    ),
                  )
                : SizedBox(),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (EmergencyStop ?? false)
                  Container(
                    margin: EdgeInsets.only(left: 1.w, top: 40.h, right: 1.w),
                    child: Center(
                      child: Container(
                        height: MediaQuery.sizeOf(context).height * 0.060,
                        width: MediaQuery.sizeOf(context).width * 0.060,
                        child: SvgPicture.asset(
                          "assets/alert-icon-orange.svg",
                        ),
                      ),
                    ),
                  ),
                if (brake ?? false)
                  Center(
                    child: Container(
                        margin:
                            EdgeInsets.only(left: 10.w, top: 40.h, right: 10.w),
                        height: MediaQuery.sizeOf(context).height * 0.060,
                        width: MediaQuery.sizeOf(context).width * 0.060,
                        child: Image.asset("assets/brake.png",
                            fit: BoxFit.contain)),
                  ),
                Container(
                  margin: EdgeInsets.only(
                    left: 10.w,
                    top: 40.h,
                    right: 10.w,
                  ),
                  decoration: BoxDecoration(
                      color: Color(
                          0xFFFFFFF ^ controller.foregroundColor.value.value),
                      borderRadius: BorderRadius.circular(90.r),
                      border: Border.all(
                        color:
                            controller.foregroundColor.value.withOpacity(0.09),
                      )),
                  width: MediaQuery.sizeOf(context).width * 0.15,
                  height: MediaQuery.sizeOf(context).height * 0.070,
                  child: Center(
                    child: Row(
                      children: [
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 8, top: 8, bottom: 8),
                          child: Container(
                            height: MediaQuery.sizeOf(context).height * 0.060,
                            width: MediaQuery.sizeOf(context).width * 0.060,
                            child: Image.asset("assets/google-maps.png",
                                color: roboColor),
                          ),
                        ),
                        Text(
                          "Q: ${quality ?? 0}",
                          style: GoogleFonts.roboto(
                            color: controller.foregroundColor.value,
                            fontSize: 20.h,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // GetX<BatteryController>(
                //   builder: (BatteryController controller) {
                //     int? batteryLevel;

                //     batteryLevel = int.tryParse(controller.background.value
                //                 ?.data?.first.robot?.batteryStatus ??
                //             "0") ??
                //         0;

                //     print("batettegdshgfcdshuf$batteryLevel");

                //     return BatteryIcon(
                //       batteryLevel: batteryLevel,
                //       color: controller.foregroundColor.value,
                //     );
                //   },
                // ),
              ],
            ),
          ],
        );
      },
    );
  }
}

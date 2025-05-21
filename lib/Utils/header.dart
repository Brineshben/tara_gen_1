import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_getx_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ihub/Controller/battery_Controller.dart';
import 'package:ihub/Utils/web_view.dart';
import 'package:ihub/View/Home_Screen/battery_Widget.dart';
import 'package:ihub/View/Robot_Response/language_list.dart';

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
            Row(
              children: [
                isBack
                    ? Padding(
                        padding: const EdgeInsets.only(left: 20, top: 30),
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
                Container(
                  margin: EdgeInsets.only(
                    left: 10.w,
                    top: 40.h,
                    right: 10.w,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    // color: controller.foregroundColor.value,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
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
                            child: SvgPicture.asset(
                                "assets/reshot-icon-map-marker-KS456ZT2P3.svg",
                                color: roboColor),
                          ),
                        ),
                        Text(
                          "Q: ${quality ?? 0}",
                          style: GoogleFonts.roboto(
                            color: Colors.white,
                            fontSize: 15.h,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
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
                isEnableRouter == false
                    ? Padding(
                        padding: const EdgeInsets.only(top: 30),
                        child: InkWell(
                          onTap: () async {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => InAppWebViewScreen(
                                  url:
                                      'http://192.168.11.2/admin/index.html#/functions/wifi/client?freq=5GHz',
                                ),
                              ),
                            );
                          },
                          child: Center(
                            child: Icon(
                              Icons.router,
                              size: 40,
                              color: controller.foregroundColor.value,
                            ),
                          ),
                        ),
                      )
                    : SizedBox(),
                SizedBox(width: 30),
                isLanguage
                    ? Padding(
                        padding: const EdgeInsets.only(top: 35),
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => LanguageList()),
                            );
                          },
                          child: Image.asset(
                            "assets/translate.png",
                            color: controller.foregroundColor.value,
                            width: 30,
                          ),
                        ),
                      )
                    : SizedBox(),
              ],
            ),
            GetX<BatteryController>(
              builder: (BatteryController controller) {
                int? batteryLevel;

                batteryLevel = int.tryParse(controller.background.value?.data
                            ?.first.robot?.batteryStatus ??
                        "0") ??
                    0;

                print("batettegdshgfcdshuf$batteryLevel");

                return BatteryIcon(
                  batteryLevel: batteryLevel,
                  color: controller.foregroundColor.value,
                );
              },
            ),
          ],
        );
      },
    );
  }
}

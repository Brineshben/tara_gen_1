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
  final bool page;
  final bool isEnableRouter;
  final bool isLanguage;
  final String screenName;
  const Header({
    super.key,
    required this.isBack,
    required this.screenName,
    this.isEnableRouter = true,
    this.isLanguage = true, required this.page,
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
          children: [
            isBack
                ? Row(
                  children: [
                    Padding(
                        padding: const EdgeInsets.only(left: 20, top: 15),
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
                                "$screenName".toUpperCase(),
                                style: GoogleFonts.poppins(
                                    color: controller.foregroundColor.value,
                                    fontSize: 25.h,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                )
                : SizedBox(),
            page==false ?
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(
                    left: 10.w,
                    top: 15.h,
                    right: 5.w,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    // color: controller.foregroundColor.value,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  width: MediaQuery.sizeOf(context).width * 0.11,
                  height: MediaQuery.sizeOf(context).height * 0.060,
                  child: Center(
                    child: Row(
                      children: [
                        Padding(
                          padding:
                          const EdgeInsets.only(left: 5, top: 8, bottom: 8),
                          child: Container(
                            height: MediaQuery.sizeOf(context).height * 0.060,
                            width: MediaQuery.sizeOf(context).width * 0.060,
                            child: Image.asset(
                                "assets/google-maps.png",
                               ),
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
                    margin: EdgeInsets.only(left: 1.w, top: 15.h, right: 1.w),
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
                        EdgeInsets.only(left: 10.w, top: 15.h, right: 10.w),
                        height: MediaQuery.sizeOf(context).height * 0.060,
                        width: MediaQuery.sizeOf(context).width * 0.060,
                        child: Image.asset("assets/brake.png",
                            fit: BoxFit.contain)),
                  ),
                isEnableRouter == false
                    ? Padding(
                  padding: const EdgeInsets.only(top: 15),
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
                    child: Padding(
                      padding:
                      const EdgeInsets.only(left: 5, top: 8, bottom: 8),
                      child: Container(
                        height: MediaQuery.sizeOf(context).height * 0.060,
                        width: MediaQuery.sizeOf(context).width * 0.060,
                        child: Image.asset(
                          "assets/3d-wifi.png",
                        ),
                      ),
                    ),
                  ),
                )
                    : SizedBox(),
                SizedBox(width: 10),
                // isLanguage
                //     ? Padding(
                //   padding: const EdgeInsets.only(top: 15),
                //   child: InkWell(
                //     onTap: () {
                //       Navigator.of(context).push(
                //         MaterialPageRoute(
                //             builder: (context) => LanguageList()),
                //       );
                //     },
                //     child: Padding(
                //       padding:
                //       const EdgeInsets.only(left: 5, top: 8, bottom: 8),
                //       child: Container(
                //         height: MediaQuery.sizeOf(context).height * 0.060,
                //         width: MediaQuery.sizeOf(context).width * 0.060,
                //         child: Image.asset(
                //           "assets/language.png",
                //         ),
                //       ),
                //     ),
                //   ),
                // )
                //     : SizedBox(),
              ],
            ):SizedBox()

          ],
        );
      },
    );
  }
}

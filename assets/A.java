 Container(

                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          bottomRight: Radius.circular(15),
                        ),                      ),
                      width: double.infinity,
                      height: size.height * 0.100,
                      child: Center(
                        child: Row(
                          children: [
                            SizedBox(width: 5.w),

                            CircleAvatar(
                              radius: 35.r,
                              backgroundColor: Colors.black,
                              child: ClipOval(
                                child: Image.asset(
                                  "assets/taraprofile.jpg",

                                  width: 100.w,
                                  height: 100.h,
                                ),
                              ),
                            ),
                            SizedBox(width: 2.w),

                            Expanded(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'POWERED BY',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w300,
                                      fontSize: 12.h,
                                      color: Colors.white,
                                    ),
                                  ),Text(
                                    'IHUB ROBOTICS',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17.h,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            GetX<BatteryController>(
                              builder: (BatteryController controller) {
                                Color? roboColor;
                                // int? batteryLevel;
                                // String? data;
                                String? quality;
                                bool? brake;
                                bool? EmergencyStop;
                                if (controller.background.value?.data!.isNotEmpty ??
                                    false) {
                                  roboColor = controller.background.value?.data?.first
                                      .robot?.map !=
                                      null
                                      ? (controller.background.value?.data?.first.robot
                                      ?.map ??
                                      false)
                                      ? Colors.green
                                      : Colors.red
                                      : null;

                                  // batteryLevel = int.tryParse(controller.background
                                  //     .value?.data?.first.robot?.batteryStatus
                                  //     .toString() ??
                                  //     '0') ??
                                  //     0;
                                  // data = controller.background.value?.data?.first.robot
                                  //     ?.batteryStatus ??
                                  //     "";
                                  quality = controller.background.value?.data?.first
                                      .robot?.quality ??
                                      "";
                                  brake = controller.background.value?.data?.first.robot
                                      ?.motorBrakeReleased;

                                  EmergencyStop = controller.background.value?.data
                                      ?.first.robot?.emergencyStop;
                                }

                                return Row(
                                  children: [
                                    Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => LoadingSplash(),
                                                ));
                                          },
                                          child: Container(
                                            margin: EdgeInsets.only(
                                                left: 10.w, top: 10.h, right: 10.w),
                                            decoration: BoxDecoration(
                                              color: Colors.white.withOpacity(0.2),
                                              borderRadius: BorderRadius.circular(20.r),
                                            ),
                                            width: size.width * 0.15,
                                            height: size.height * 0.060,
                                            child: Center(
                                              child: Row(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.only(
                                                        left: 8, top: 8, bottom: 8),
                                                    child: Container(
                                                      height: size.height * 0.060,
                                                      width: size.width * 0.060,
                                                      child: SvgPicture.asset(
                                                          "assets/reshot-icon-map-marker-KS456ZT2P3.svg",
                                                          color: roboColor),
                                                    ),
                                                  ),
                                                  Text(
                                                    "Q: $quality ",
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
                                        ),
                                        if (EmergencyStop ?? false)
                                          Container(
                                            margin: EdgeInsets.only(
                                                left: 1.w, top: 10.h, right: 1.w),
                                            child: Center(
                                              child: Container(
                                                height: size.height * 0.060,
                                                width: size.width * 0.060,
                                                child: SvgPicture.asset(
                                                  "assets/alert-icon-orange.svg",
                                                ),
                                              ),
                                            ),
                                          ),
                                        if (brake ?? false)
                                          Center(
                                            child: Container(
                                                margin: EdgeInsets.only(
                                                    left: 10.w, top: 10.h, right: 10.w),
                                                height: size.height * 0.060,
                                                width: size.width * 0.060,
                                                child: Image.asset("assets/brake.png",
                                                    fit: BoxFit.contain)),
                                          ),
                                        Padding(
                                          padding: const EdgeInsets.only(top: 10),
                                          child: InkWell(
                                            onTap: () async {
                                              final Uri url = Uri.parse(
                                                'http://192.168.11.2/admin/index.html#/functions/wifi/client?freq=5GHz',
                                              );
                                              await launchUrl(
                                                url,
                                                mode: LaunchMode.inAppWebView,
                                              );
                                            },
                                            child: Icon(
                                              Icons.router,
                                              size: 50,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    GetX<BatteryOfflineController>(
                                      builder: (BatteryOfflineController controller) {
                                        int? batteryLevel;
                                        String? data;

                                        // if (controller.background.value?.rB3
                                        //     ?.batteryStatus?.isNotEmpty ??
                                        //     false) {
                                        data = controller.background.value?.data?.rB3
                                            ?.batteryStatus ??
                                            "0";
                                        batteryLevel = int.tryParse(controller
                                            .background
                                            .value
                                            ?.data
                                            ?.rB3
                                            ?.batteryStatus
                                            .toString() ??
                                            '0') ??
                                            0;
                                        print("batettegdshgfcdshuf$batteryLevel");

                                        // }
                                        return Container(
                                          margin: EdgeInsets.only(
                                              left: 20.w, top: 10.h, right: 10.w),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              Row(
                                                children: [
                                                  BatteryIcon(
                                                    batteryLevel: batteryLevel,
                                                  ), // Updated widget

                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(
                                                    "$data %",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 20.h),
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ihub/Controller/Navigate_Controller.dart';
import 'package:ihub/Service/Api_Service.dart';
import 'package:ihub/Utils/glassmorphism.dart';
import 'package:overlapped_carousel/overlapped_carousel.dart';

class NavigationsSection extends StatefulWidget {
  const NavigationsSection({super.key});

  @override
  State<NavigationsSection> createState() => _NavigationsSectionState();
}

class _NavigationsSectionState extends State<NavigationsSection> {
  final Map<int, String> _statusText = {}; // Store per-item text

  @override
  void initState() {
    super.initState();
    Get.find<NavigateController>().navigateData();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: GetX<NavigateController>(
          builder: (controller) {
            if (controller.isLoading.value) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.white),
              );
            }

            if (controller.dataList.isEmpty) {
              return const Center(
                child: Text(
                  "Oops.. No Data Found",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              );
            }

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: Image.asset("assets/Rectangle 65.png")),

                // Divider
                Container(
                  width: 2,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.grey[600]!,
                        Colors.transparent,
                        Colors.grey[600]!,
                      ],
                    ),
                  ),
                ),
                // Navigation cards
                Expanded(
                  flex: 2,
                  child: GridView.builder(
                    itemCount: controller.dataList.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 15,
                      childAspectRatio: 0.9,
                    ),
                    itemBuilder: (context, index) {
                      final item = controller.dataList[index];
                      final id = item?.id ?? index;
                      final text = _statusText[id] ?? "Tap to navigate";

                      return InkWell(
                        onTap: () async {
                          setState(() {
                            _statusText[id] = "SENDING...";
                          });

                          try {
                            await ApiServices.destination(id: id);
                            await Future.delayed(const Duration(seconds: 1));

                            final resp = await ApiServices.robotbasestatus();
                            final ok = resp['status'] == true;

                            setState(() {
                              _statusText[id] =
                                  ok ? "COMMAND RECEIVED" : "ALREADY RECEIVED";
                            });

                            // Reset to default after 2 seconds
                            Future.delayed(const Duration(seconds: 2), () {
                              if (mounted) {
                                setState(() {
                                  _statusText[id] = "Tap to navigate";
                                });
                              }
                            });
                          } catch (e) {
                            setState(() {
                              _statusText[id] = "FAILED";
                            });

                            Future.delayed(const Duration(seconds: 2), () {
                              if (mounted) {
                                setState(() {
                                  _statusText[id] = "Tap to navigate";
                                });
                              }
                            });
                          }
                        },
                        child: ChildGlasmorphism(
                          borderRadius: 15,
                          borderColor: Colors.grey.withOpacity(0.3),
                          margin: EdgeInsets.zero,
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.location_on,
                                  color: text == "COMMAND RECEIVED"
                                      ? Colors.greenAccent
                                      : Colors.white70,
                                  size: 40,
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  item?.name ?? '',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  text,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: text == "SENDING..."
                                        ? Colors.orangeAccent
                                        : text == "COMMAND RECEIVED"
                                            ? Colors.greenAccent
                                            : text == "FAILED"
                                                ? Colors.redAccent
                                                : Colors.white.withOpacity(0.6),
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}

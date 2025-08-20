import 'package:flutter/material.dart';
import 'package:ihub/Service/Api_Service.dart';
import 'package:ihub/Utils/glassmorphism.dart';
import 'package:ihub/Utils/toast.dart';

class FullTourModeScreen extends StatelessWidget {
  const FullTourModeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width * 0.6,
      height: MediaQuery.sizeOf(context).height * 0.4,
      margin: EdgeInsets.only(top: 100),
      child: ChildGlasmorphism(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  'assets/map.png',
                  width: 180,
                  height: 180,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Full Tour Mode',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Guide the robot through multiple waypoints in order. Add locations like 1 → 2 → 3 → 4 to create a full tour path.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.place_outlined,
                              color: Colors.black87),
                          label: const Text(
                            'Learn more',
                            style: TextStyle(color: Colors.black87),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey.shade300,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 12),
                          ),
                        ),
                        const SizedBox(width: 16),
                        ElevatedButton.icon(
                          onPressed: () async {
                            Map<String, dynamic> resp =
                                await ApiServices.fulltourNavigation(
                                    status: true);

                            if (resp['status'] == "ok") {
                              showTopRightToast(
                                color: Colors.green,
                                context: context,
                                message: "Full tour navigation started successfully",
                              );
                            }
                          },
                          icon: const Icon(Icons.place_outlined,
                              color: Colors.white),
                          label: const Text(
                            'Customize',
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 12),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

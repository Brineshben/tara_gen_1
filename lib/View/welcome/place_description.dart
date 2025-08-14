import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ihub/Controller/Nav_description_controller.dart';
import 'package:ihub/Utils/glassmorphism.dart';
import 'package:shimmer/shimmer.dart';

class PlaceDescription extends StatefulWidget {
  const PlaceDescription({super.key});

  @override
  State<PlaceDescription> createState() => _PlaceDescriptionState();
}

class _PlaceDescriptionState extends State<PlaceDescription> {
  @override
  void initState() {
    Get.find<NavigateDescriptionController>().getNavigation(context);
    super.initState();
  }

  int? selectedIndex;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GetX<NavigateDescriptionController>(
        builder: (NavigateDescriptionController controller) {
          if (controller.isLoading.value) {
            return Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            );
          } else {
            if (controller.dataList.isEmpty) {
              return Center(
                  child: Text(
                "No description found",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ));
            } else {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    if (selectedIndex != null)
                      Expanded(
                        flex: 2,
                        child: GlassmorphismModal(
                          placeName:
                              "${controller.dataList[selectedIndex!]?.name?.toUpperCase()}",
                          index: selectedIndex!,
                          userId: controller.dataList[selectedIndex!]?.id ?? 0,
                        ),
                      ),
                    Expanded(
                      flex: 4,
                      child: GridView.builder(
                        padding: EdgeInsets.symmetric(horizontal: 30),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: selectedIndex != null ? 3 : 4,
                          crossAxisSpacing: 15,
                          mainAxisSpacing: 15,
                          childAspectRatio: 1.6,
                        ),
                        itemCount: controller.isExpandedList.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              setState(() {
                                selectedIndex = index;
                              });
                            },
                            child: ChildGlasmorphism(
                                borderRadius: 10,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Icon(
                                            Icons.edit_outlined,
                                            color: Colors.white,
                                            size: 15,
                                          ),
                                        ],
                                      ),
                                      Spacer(),
                                      Icon(
                                        Icons.location_on,
                                        color: Colors.white,
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        "${controller.dataList[index]?.name?.toUpperCase()}",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Spacer(),
                                    ],
                                  ),
                                )),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            }
          }
        },
      ),
    );
  }
}

class GlassmorphismModal extends StatelessWidget {
  final String placeName;
  final int index;
  final int userId;
  const GlassmorphismModal({
    super.key,
    required this.index,
    required this.placeName,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return GetX<NavigateDescriptionController>(
      builder: (provider) {
        return ChildGlasmorphism(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: SingleChildScrollView(
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Text(
                              'Add place description',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Place',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 12,
                            ),
                          ),
                          SizedBox(height: 5),
                          Container(
                            decoration: BoxDecoration(
                              color: Color(0xFF3A4A4A).withOpacity(0.6),
                              borderRadius: BorderRadius.circular(25),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.2),
                                width: 1,
                              ),
                            ),
                            child: TextField(
                              readOnly: true,
                              controller:
                                  TextEditingController(text: placeName),
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                                fontSize: 16,
                              ),
                              decoration: InputDecoration(
                                hintText: 'Place',
                                hintStyle: TextStyle(
                                  color: Colors.white.withOpacity(0.4),
                                  fontSize: 10,
                                ),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 16,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 15),
                          Text(
                            'Description',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 12,
                            ),
                          ),
                          SizedBox(height: 5),
                          Container(
                            decoration: BoxDecoration(
                              color: Color(0xFF3A4A4A).withOpacity(0.6),
                              borderRadius: BorderRadius.circular(25),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.2),
                                width: 1,
                              ),
                            ),
                            child: TextField(
                              controller:
                                  provider.descriptionControllers[index],
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                                fontSize: 16,
                              ),
                              maxLines: 5,
                              decoration: InputDecoration(
                                hintText: 'Enter description',
                                hintStyle: TextStyle(
                                  color: Colors.white.withOpacity(0.4),
                                  fontSize: 10,
                                ),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 16,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 40),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  provider.submitNavigationUpdate(
                                      description: provider
                                          .descriptionControllers[index].text,
                                      userId: userId,
                                      context: context);
                                },
                                child: ChildGlasmorphism(
                                  borderRadius: 30,
                                  child: SizedBox(
                                    width: 150,
                                    height: 40,
                                    child: ShaderMask(
                                      shaderCallback: (bounds) =>
                                          const LinearGradient(
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                        colors: [
                                          Color.fromARGB(
                                            219,
                                            255,
                                            255,
                                            255,
                                          ),
                                          Color(0xFF999999),
                                        ],
                                      ).createShader(bounds),
                                      child: Center(
                                        child: provider.isSubmitting.value
                                            ? Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              spacing: 10,
                                              children: [
                                                SizedBox(
                                                    width: 20,
                                                    height: 20,
                                                    child:
                                                        CircularProgressIndicator(
                                                      strokeWidth: 2,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                   Text(
                                                    'Submiting...',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                              ],
                                            )
                                            : Text(
                                                'Submit',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

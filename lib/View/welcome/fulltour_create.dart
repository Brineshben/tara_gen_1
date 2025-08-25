// import 'dart:ui';

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:ihub/Service/Api_Service.dart';
// import 'package:ihub/Utils/glassmorphism.dart';
// import 'package:ihub/Utils/toast.dart';

// import '../../Controller/FulltourController.dart';
// import '../../Model/Navigate_model.dart';
// import '../../Utils/popups.dart';

// class FullTourCreateScreen extends StatefulWidget {
//   @override
//   _FullTourCreateScreenState createState() => _FullTourCreateScreenState();
// }

// class _FullTourCreateScreenState extends State<FullTourCreateScreen> {
//   @override
//   void initState() {
//     Get.find<FullTourControllerNew>().fetchFullTourData();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           Container(
//             decoration: const BoxDecoration(
//               image: DecorationImage(
//                 image: AssetImage('assets/bg.png'),
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),
//           Container(
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 begin: Alignment.topCenter,
//                 end: Alignment.bottomCenter,
//                 colors: [
//                   Color(0xFF608878).withOpacity(0.2), // light green
//                   Color(0xFF18221E).withOpacity(0.2), // dark green
//                 ],
//               ),
//             ),
//             child: BackdropFilter(
//               filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
//               child: Container(color: Colors.transparent),
//             ),
//           ),
//           Column(
//             children: [
//               Padding(
//                 padding: const EdgeInsets.only(left: 20, top: 20),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: [
//                         Container(
//                           width: 50,
//                           height: 50,
//                           margin: const EdgeInsets.only(left: 20),
//                           decoration: BoxDecoration(
//                             color: Colors.grey[600]?.withOpacity(0.8),
//                             shape: BoxShape.circle,
//                           ),
//                           child: IconButton(
//                             onPressed: () {
//                               Navigator.pop(context);
//                             },
//                             icon: const Icon(
//                               Icons.arrow_back_ios,
//                               color: Colors.white,
//                               size: 20,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     GestureDetector(
//                         onTap: () async {
//                           try {
//                             List<NavigationData> selectedData =
//                                 Get.find<FullTourControllerNew>()
//                                     .newDataNavigation;
//                             List<int> dataz = [];
//                             for (var element in selectedData) {
//                               int parsedId = element.id ?? 0;
//                               dataz.add(parsedId);
//                             }
//                             Map<String, dynamic> resp =
//                                 await ApiServices.navigationSubmit(
//                                     navigationData: dataz);

//                             if (resp['status'] == "ok") {
//                               FocusManager.instance.primaryFocus?.unfocus();

//                               showTopRightToast(color: Colors.green,  message: resp['message'].toString());
//                             } else {

//                               showTopRightToast(
//                                   color: Colors.red,
//                                   
//                                   message: "Something went wrong",
//                               );

//                             }
//                           } catch (e) {
//                             print("${e.toString()}");

//                               showTopRightToast(
//                               color: Colors.red,
//                               
//                               message: "Something went wrong",
//                             );
//                           }
//                         },
//                         child: ChildGlasmorphism(
//                             margin: EdgeInsets.only(right: 20),
//                             child: Padding(
//                               padding: const EdgeInsets.symmetric(
//                                   horizontal: 30, vertical: 10),
//                               child: Text(
//                                 "Create",
//                                 style: TextStyle(color: Colors.white),
//                               ),
//                             )))
//                   ],
//                 ),
//               ),
//               Expanded(
//                 child: Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Row(
//                     children: [
//                       Expanded(
//                         child: Column(
//                           children: [
//                             const SizedBox(height: 30),
//                             Text("DESTINATIONS LIST",
//                                 style: TextStyle(
//                                     fontSize: 20,
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.white)),
//                             const SizedBox(height: 30),
//                             Expanded(
//                               child: Obx(() {
//                                 FullTourControllerNew controller =
//                                     Get.find<FullTourControllerNew>();
//                                 return controller.dataNavigation.isNotEmpty
//                                     ? ListView.builder(
//                                         itemCount:
//                                             controller.dataNavigation.length,
//                                         itemBuilder: (context, index) {
//                                           final item =
//                                               controller.dataNavigation[index];
//                                           return Padding(
//                                             padding: const EdgeInsets.symmetric(
//                                                 vertical: 5, horizontal: 15),
//                                             child: InkWell(
//                                               onTap: () {
//                                                 controller.addData(item);
//                                                   showTopRightToast(
//                                                   color: Colors.black,
//                                                   
//                                                   message:
//                                                       "${item.name} added to selected list",
//                                                 );
//                                               },
//                                               child: ChildGlasmorphism(
//                                                   child: Padding(
//                                                 padding:
//                                                     const EdgeInsets.symmetric(
//                                                         vertical: 10),
//                                                 child: Center(
//                                                   child: Text(
//                                                     item.name ?? "No Name",
//                                                     style: TextStyle(
//                                                         color: Colors.white),
//                                                   ),
//                                                 ),
//                                               )),
//                                             ),
//                                           );
//                                         },
//                                       )
//                                     : const Center(
//                                         child: Text(
//                                           "No Data Found",
//                                           style: TextStyle(color: Colors.white),
//                                         ),
//                                       );
//                               }),
//                             ),
//                           ],
//                         ),
//                       ),
//                       VerticalDivider(
//                           thickness: 0.5, color: Colors.grey, width: 30),
//                       Expanded(
//                         child: Column(
//                           children: [
//                             const SizedBox(height: 30),
//                             Text("SELECTED DESTINATIONS LIST",
//                                 style: TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 20,
//                                   fontWeight: FontWeight.bold,
//                                 )),
//                             const SizedBox(height: 30),
//                             Expanded(
//                               child: Obx(() {
//                                 FullTourControllerNew controller =
//                                     Get.find<FullTourControllerNew>();

//                                 return controller.newDataNavigation.isNotEmpty
//                                     ? ListView.separated(
//                                         separatorBuilder: (context, index) =>
//                                             SizedBox(height: 10),
//                                         itemCount:
//                                             controller.newDataNavigation.length,
//                                         itemBuilder: (context, index) {
//                                           final item = controller
//                                               .newDataNavigation[index];

//                                           return Padding(
//                                             padding: const EdgeInsets.symmetric(
//                                                 vertical: 5, horizontal: 15),
//                                             child: InkWell(
//                                               onTap: () {
//                                                 controller.removeData(item);

//                                                  showTopRightToast(
//                                                   color: Colors.black,
//                                                   
//                                                   message:
//                                                       "${item.name} removed from selected list",
//                                                 );
//                                               },
//                                               child: ChildGlasmorphism(
//                                                   child: Padding(
//                                                 padding:
//                                                     const EdgeInsets.symmetric(
//                                                         vertical: 10, horizontal: 20),
//                                                 child: Row(
//                                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                                   children: [
//                                                     Text(
//                                                         item.name ?? "No Name",
//                                                         style: TextStyle(
//                                                             color: Colors.white)),
//                                                             Icon(Icons.delete_outline, color: Colors.white,)
//                                                   ],
//                                                 ),
//                                               )),
//                                             ),
//                                           );
//                                         },
//                                       )
//                                     : const Center(
//                                         child: Text(
//                                           "No Selected Data Found",
//                                           style: TextStyle(color: Colors.white),
//                                         ),
//                                       );
//                               }),
//                             ),
//                             const SizedBox(height: 30),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ihub/Service/Api_Service.dart';
import 'package:ihub/Utils/glassmorphism.dart';
import 'package:ihub/Utils/toast.dart';

import '../../Controller/FulltourController.dart';
import '../../Model/Navigate_model.dart';

class FullTourCreateScreen extends StatefulWidget {
  @override
  _FullTourCreateScreenState createState() => _FullTourCreateScreenState();
}

class _FullTourCreateScreenState extends State<FullTourCreateScreen> {
  late FullTourControllerNew controller;
  bool _isDragOver = false;
  ScrollController _horizontalScrollController = ScrollController();

  @override
  void initState() {
    controller = Get.find<FullTourControllerNew>();
    controller.fetchFullTourData();
    super.initState();
  }

  @override
  void dispose() {
    _horizontalScrollController.dispose();
    super.dispose();
  }

  void _autoScrollLeft() {
    if (_horizontalScrollController.hasClients) {
      _horizontalScrollController.animateTo(
        _horizontalScrollController.offset - 200,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Widget _buildDragTargetPlaceholder() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          _isDragOver ? Icons.add_location_alt : Icons.drag_indicator,
          size: 40,
          color: _isDragOver ? Colors.green : Colors.white54,
        ),
        SizedBox(height: 8),
        Text(
          _isDragOver ? "Release to add destination" : "Drag destinations here",
          style: TextStyle(
            color: _isDragOver ? Colors.green : Colors.white54,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 4),
        if (!_isDragOver)
          Text(
            "Selected destinations will appear here",
            style: TextStyle(
              color: Colors.white38,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
      ],
    );
  }

  Widget _buildSelectedDestinations() {
    return ListView.separated(
      controller: _horizontalScrollController,
      scrollDirection: Axis.horizontal,
      itemCount: controller.newDataNavigation.length,
      separatorBuilder: (_, __) => SizedBox(width: 15),
      itemBuilder: (context, index) {
        final item = controller.newDataNavigation[index];
        return ChildGlasmorphism(
          child: Container(
            width: 250,
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text(
                    "Position ${index + 1}",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                Spacer(),
                Image.asset(
                  "assets/route.png",
                  width: 90,
                  color: Colors.white,
                ),
                SizedBox(height: 10),
                Text(
                  item.name ?? "",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                Spacer(),
                InkWell(
                  onTap: () {
                    controller.removeData(item);
                    showTopRightToast(
                      color: Colors.black,
                      
                      message: "${item.name} removed",
                    );
                    setState(() {});
                  },
                  child: ChildGlasmorphism(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 80, vertical: 10),
                      child: Text(
                        "Remove",
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/bg.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF608878).withOpacity(0.2),
                  Color(0xFF18221E).withOpacity(0.2),
                ],
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(color: Colors.transparent),
            ),
          ),

          Column(
            children: [
              // Top bar
              Padding(
                padding: const EdgeInsets.only(left: 20, top: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ChildGlasmorphism(
                      borderRadius: 10,
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(10),
                          onTap: () => Navigator.of(context).pop(),
                          child: const Padding(
                            padding: EdgeInsets.all(12),
                            child: Icon(
                              Icons.arrow_back_ios_new,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Create button
                    GestureDetector(
                      onTap: () async {
                        try {
                          List<int> dataz = controller.newDataNavigation
                              .map((e) => e.id ?? 0)
                              .toList();

                          Map<String, dynamic> resp =
                              await ApiServices.navigationSubmit(
                                  navigationData: dataz);

                          if (resp['status'] == "ok") {
                            FocusManager.instance.primaryFocus?.unfocus();
                            Navigator.of(context).pop();

                            showTopRightToast(
                              color: Colors.green,
                              
                              message: resp['message'].toString(),
                            );
                          } else {
                            showTopRightToast(
                              color: Colors.red,
                              
                              message: "Something went wrong",
                            );
                          }
                        } catch (e) {
                          showTopRightToast(
                            color: Colors.red,
                            
                            message: "Something went wrong",
                          );
                        }
                      },
                      child: ChildGlasmorphism(
                        margin: EdgeInsets.only(right: 20),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 10),
                          child: Text("Create Full Tour",
                              style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Main Content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      // LEFT SIDE (Selected list with enhanced DragTarget)
                      Expanded(
                        child: Column(
                          children: [
                            const SizedBox(height: 30),
                            Obx(() => Text(
                                  "SELECTED DESTINATIONS (${controller.newDataNavigation.length})",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                )),
                            const SizedBox(height: 20),
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 50),
                                child: DragTarget<NavigationData>(
                                  onWillAccept: (data) => true,
                                  onAccept: (item) {
                                    controller.addData(item);
                                    showTopRightToast(
                                      color: Colors.green,
                                      
                                      message:
                                          "${item.name} added to selected list",
                                    );
                                    setState(() {
                                      _isDragOver = false;
                                    });

                                    // Auto scroll to the right to show new item
                                    Future.delayed(Duration(milliseconds: 100),
                                        () {
                                      if (_horizontalScrollController
                                          .hasClients) {
                                        _horizontalScrollController.animateTo(
                                          _horizontalScrollController
                                              .position.maxScrollExtent,
                                          duration: Duration(milliseconds: 500),
                                          curve: Curves.easeInOut,
                                        );
                                      }
                                    });
                                  },
                                  onMove: (details) {
                                    if (!_isDragOver) {
                                      setState(() {
                                        _isDragOver = true;
                                      });
                                      _autoScrollLeft();
                                    }
                                  },
                                  onLeave: (data) {
                                    setState(() {
                                      _isDragOver = false;
                                    });
                                  },
                                  builder: (context, candidateData, rejected) {
                                    return AnimatedContainer(
                                      duration: Duration(milliseconds: 200),
                                      height: 180,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: _isDragOver
                                            ? Colors.green.withOpacity(0.1)
                                            : Colors.transparent,
                                      ),
                                      child: controller
                                              .newDataNavigation.isNotEmpty
                                          ? Column(
                                              children: [
                                                if (_isDragOver)
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 10),
                                                    child: ChildGlasmorphism(
                                                      borderRadius: 10,
                                                      child: Container(
                                                        height: 100,
                                                        child: Center(
                                                          child: Text(
                                                            "Drop here to add to position ${controller.newDataNavigation.length + 1}",
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.green,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                Expanded(
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                          child:
                                                              _buildSelectedDestinations()),
                                                      if (_isDragOver)
                                                        Container(
                                                          width: 250,
                                                          margin:
                                                              EdgeInsets.only(
                                                                  left: 15),
                                                          child:
                                                              ChildGlasmorphism(
                                                            child: Container(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(16),
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Icon(
                                                                    Icons
                                                                        .add_circle_outline,
                                                                    size: 50,
                                                                    color: Colors
                                                                        .green,
                                                                  ),
                                                                  SizedBox(
                                                                      height:
                                                                          10),
                                                                  Text(
                                                                    "Drop Here",
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .green,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          18,
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    "Position ${controller.newDataNavigation.length + 1}",
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .green
                                                                          .withOpacity(
                                                                              0.7),
                                                                      fontSize:
                                                                          12,
                                                                    ),
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
                                            )
                                          : Center(
                                              child:
                                                  _buildDragTargetPlaceholder()),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      VerticalDivider(
                          thickness: 0.5, color: Colors.grey, width: 30),

                      // RIGHT SIDE (GridView with draggable items - unchanged)
                      Expanded(
                        child: Column(
                          children: [
                            const SizedBox(height: 30),
                            Obx(() => Text(
                                  "DESTINATIONS LIST (${controller.dataNavigation.length})",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                )),
                            const SizedBox(height: 20),
                            Expanded(
                              child: Obx(() {
                                return controller.dataNavigation.isNotEmpty
                                    ? GridView.builder(
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          mainAxisSpacing: 10,
                                          crossAxisSpacing: 10,
                                          childAspectRatio: 2,
                                        ),
                                        itemCount:
                                            controller.dataNavigation.length,
                                        itemBuilder: (context, index) {
                                          final item =
                                              controller.dataNavigation[index];
                                          return Draggable<NavigationData>(
                                            data: item,
                                            feedback: Material(
                                              color: Colors.transparent,
                                              child: ChildGlasmorphism(
                                                borderRadius: 10,
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 80,
                                                      vertical: 20),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Image.asset(
                                                        "assets/route.png",
                                                        width: 50,
                                                        color: Colors.white,
                                                      ),
                                                      SizedBox(height: 8),
                                                      Text(
                                                        item.name ?? "",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            childWhenDragging: Opacity(
                                              opacity: 0.3,
                                              child: ChildGlasmorphism(
                                                borderRadius: 10,
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 50,
                                                      vertical: 20),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Image.asset(
                                                        "assets/route.png",
                                                        width: 50,
                                                        color: Colors.white,
                                                      ),
                                                      SizedBox(height: 8),
                                                      Text(
                                                        item.name ?? "",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            child: ChildGlasmorphism(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Image.asset(
                                                    "assets/route.png",
                                                    width: 50,
                                                    color: Colors.white,
                                                  ),
                                                  SizedBox(height: 8),
                                                  Text(
                                                    item.name ?? "",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      )
                                    : Center(
                                        child: Text("No Data Found",
                                            style:
                                                TextStyle(color: Colors.white)),
                                      );
                              }),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

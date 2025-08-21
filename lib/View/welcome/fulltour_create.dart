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

//                               showTopRightToast(color: Colors.green, context: context, message: resp['message'].toString());
//                             } else {

//                               showTopRightToast(
//                                   color: Colors.red,
//                                   context: context,
//                                   message: "Something went wrong",
//                               );

//                             }
//                           } catch (e) {
//                             print("${e.toString()}");

//                               showTopRightToast(
//                               color: Colors.red,
//                               context: context,
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
//                                                   context: context,
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
//                                                   context: context,
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

  @override
  void initState() {
    controller = Get.find<FullTourControllerNew>();
    controller.fetchFullTourData();
    super.initState();
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
                    // Back button
                    Container(
                      width: 50,
                      height: 50,
                      margin: const EdgeInsets.only(left: 20),
                      decoration: BoxDecoration(
                        color: Colors.grey[600]?.withOpacity(0.8),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back_ios,
                            color: Colors.white, size: 20),
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
                            showTopRightToast(
                              color: Colors.green,
                              context: context,
                              message: resp['message'].toString(),
                            );
                          } else {
                            showTopRightToast(
                              color: Colors.red,
                              context: context,
                              message: "Something went wrong",
                            );
                          }
                        } catch (e) {
                          showTopRightToast(
                            color: Colors.red,
                            context: context,
                            message: "Something went wrong",
                          );
                        }
                      },
                      child: ChildGlasmorphism(
                        margin: EdgeInsets.only(right: 20),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 10),
                          child: Text("Create",
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
                      // LEFT SIDE (Selected list with DragTarget)
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
                                child: DragTarget<NavigationData>(
                              onAccept: (item) {
                                controller.addData(item);
                                showTopRightToast(
                                  color: Colors.black,
                                  context: context,
                                  message:
                                      "${item.name} added to selected list",
                                );
                              },
                              builder: (context, candidateData, rejected) {
                                return controller.newDataNavigation.isNotEmpty
                                    ? ListView.separated(
                                        itemCount:
                                            controller.newDataNavigation.length,
                                        separatorBuilder: (_, __) =>
                                            SizedBox(height: 10),
                                        itemBuilder: (context, index) {
                                          final item = controller
                                              .newDataNavigation[index];
                                          return ChildGlasmorphism(
                                            child: ListTile(
                                              title: Text(item.name ?? "",
                                                  style: TextStyle(
                                                      color: Colors.white)),
                                              trailing: IconButton(
                                                icon: Icon(Icons.delete_outline,
                                                    color: Colors.white),
                                                onPressed: () {
                                                  controller.removeData(item);
                                                  showTopRightToast(
                                                    color: Colors.black,
                                                    context: context,
                                                    message:
                                                        "${item.name} removed",
                                                  );

                                                  setState(() {
                                                    controller.newDataNavigation.remove(item);
                                                  });
                                                },
                                              ),
                                            ),
                                          );
                                        },
                                      )
                                    : Center(
                                        child: Text("Drag items here",
                                            style: TextStyle(
                                                color: Colors.white54)),
                                      );
                              },
                            )),
                          ],
                        ),
                      ),

                      VerticalDivider(
                          thickness: 0.5, color: Colors.grey, width: 30),

                      // RIGHT SIDE (GridView with draggable items)
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
                                          childAspectRatio: 3,
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
                                                child: Padding(
                                                  padding: EdgeInsets.all(10),
                                                  child: Text(item.name ?? "",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                ),
                                              ),
                                            ),
                                            childWhenDragging: Opacity(
                                                opacity: 0.3,
                                                child: ChildGlasmorphism(
                                                  child: Center(
                                                    child: Text(item.name ?? "",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white)),
                                                  ),
                                                )),
                                            child: ChildGlasmorphism(
                                              child: Center(
                                                child: Text(item.name ?? "",
                                                    style: TextStyle(
                                                        color: Colors.white)),
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

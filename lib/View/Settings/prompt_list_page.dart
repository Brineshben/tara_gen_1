import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:ihub/Controller/Backgroud_controller.dart';
import 'package:ihub/Controller/prompt_controller.dart';
import 'package:ihub/Service/Api_Service.dart';
import 'package:ihub/Utils/colors.dart';
import 'package:ihub/Utils/header.dart';
import 'package:ihub/View/Settings/add_system_promt.dart';

class PromptListPage extends StatefulWidget {
  const PromptListPage({Key? key}) : super(key: key);

  @override
  State<PromptListPage> createState() => _PromptListPageState();
}

class _PromptListPageState extends State<PromptListPage> {
  final controller = Get.find<PromptController>();

  @override
  void initState() {
    super.initState();
    Get.find<PromptController>().fetchPrompt();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            GetX<BackgroudController>(
              builder: (BackgroudController controller) {
                return Positioned.fill(
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      CachedNetworkImage(
                        imageUrl:
                            controller.backgroundModel.value?.backgroundImage ??
                                "",
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Image.asset(
                            controller.defaultIMage,
                            fit: BoxFit.cover),
                        errorWidget: (context, url, error) => Image.asset(
                            controller.defaultIMage,
                            fit: BoxFit.cover),
                      ),
                      BackdropFilter(
                        filter: ImageFilter.blur(
                            sigmaX: 10.0, sigmaY: 10.0), // Adjust blur strength
                        child: Container(
                          color: Colors.black.withOpacity(
                              0), // Required for BackdropFilter to work
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            Center(
              child: GetX<PromptController>(
                builder: (controller) {
                  if (controller.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final command_prompt = controller.promptresponce?["data"]
                          ["command_prompt"] ??
                      '';

                  // final command_prompt = controller.promptresponce != null &&
                  //         controller.promptresponce!["data"] != null &&
                  //         controller.promptresponce!["data"]
                  //                 ["command_prompt"] !=
                  //             null
                  //     ? controller.promptresponce!["data"]["command_prompt"]
                  //     : '';

                  if (command_prompt.isEmpty) {
                    return const Center(
                      child: Text(
                        'No prompt found',
                        style: TextStyle(color: Colors.red),
                      ),
                    );
                  }

                  // return Padding(
                  //     padding: const EdgeInsets.only(top: 100),
                  //     child: Card(
                  //       color: Colors.white.withOpacity(0.8),
                  //       margin: const EdgeInsets.symmetric(
                  //           horizontal: 16, vertical: 8),
                  //       child: ListTile(
                  //         onTap: () {
                  //           // Get.dialog(
                  //           //   AlertDialog(
                  //           //     shape: const RoundedRectangleBorder(
                  //           //       borderRadius:
                  //           //           BorderRadius.all(Radius.circular(20.0)),
                  //           //     ),
                  //           //     title: Column(
                  //           //       children: [
                  //           //         Icon(
                  //           //           Icons.warning,
                  //           //           color: Colors.red,
                  //           //           size: 50.h,
                  //           //         ),
                  //           //       ],
                  //           //     ),
                  //           //     content: Text(
                  //           //       'Are you sure you want to edit or delete this prompt?',
                  //           //       textAlign: TextAlign.center,
                  //           //       style: TextStyle(fontSize: 16.h),
                  //           //     ),
                  //           //     actionsAlignment: MainAxisAlignment.center,
                  //           //     actions: [
                  //           //       // Cancel Button
                  //           //       OutlinedButton(
                  //           //         onPressed: () {
                  //           //           Navigator.of(context).pop();
                  //           //         },
                  //           //         style: OutlinedButton.styleFrom(
                  //           //           side: BorderSide(color: Colors.black),
                  //           //         ),
                  //           //         child: Text(
                  //           //           "Cancel",
                  //           //           style: TextStyle(
                  //           //             color: Colors.black,
                  //           //             fontSize: 16.h,
                  //           //           ),
                  //           //         ),
                  //           //       ),

                  //           //       // Edit Button
                  //           //       OutlinedButton(
                  //           //         onPressed: () {
                  //           //           Navigator.of(context).pop();

                  //           //           Navigator.push(
                  //           //               context,
                  //           //               MaterialPageRoute(
                  //           //                   builder: (context) =>
                  //           //                       AddSystemPrompt(
                  //           //                         id: item.id.toString(),
                  //           //                         isEdit: true,
                  //           //                         prompt:
                  //           //                             item.commandPrompt ??
                  //           //                                 '',
                  //           //                       )));
                  //           //         },
                  //           //         style: OutlinedButton.styleFrom(
                  //           //           side: BorderSide(color: Colors.blue),
                  //           //         ),
                  //           //         child: Text(
                  //           //           "Edit",
                  //           //           style: TextStyle(
                  //           //             color: Colors.blue,
                  //           //             fontSize: 16.h,
                  //           //           ),
                  //           //         ),
                  //           //       ),

                  //           //       // Delete Button
                  //           //       FilledButton(
                  //           //         onPressed: () async {
                  //           //           Navigator.of(context).pop();

                  //           //           // final response =
                  //           //           //     await ApiServices.deletePrompt(
                  //           //           //         item.id ?? 0);

                  //           //           // if (response['status'] == "ok") {
                  //           //           //   // Get.snackbar(
                  //           //           //   //   margin: EdgeInsets.all(20),
                  //           //           //   //   "Success",
                  //           //           //   //   response['message'] ??
                  //           //           //   //       "Prompt deleted successfully",
                  //           //           //   //   backgroundColor: Colors.green,
                  //           //           //   //   colorText: Colors.white,
                  //           //           //   //   snackPosition: SnackPosition.TOP,
                  //           //           //   //   duration: Duration(seconds: 3),
                  //           //           //   // );
                  //           //           //   Get.find<PromptController>()
                  //           //           //       .fetchPrompt();
                  //           //           // } else {
                  //           //           //   Get.snackbar(
                  //           //           //     margin: EdgeInsets.all(20),
                  //           //           //     "Error",
                  //           //           //     response['message'] ??
                  //           //           //         "Something went wrong",
                  //           //           //     backgroundColor: Colors.red,
                  //           //           //     colorText: Colors.white,
                  //           //           //     snackPosition: SnackPosition.TOP,
                  //           //           //   );
                  //           //           // }
                  //           //         },
                  //           //         style: ButtonStyle(
                  //           //           backgroundColor: WidgetStateProperty.all(
                  //           //               ColorUtils.userdetailcolor),
                  //           //         ),
                  //           //         child: Text(
                  //           //           "Delete",
                  //           //           style: TextStyle(
                  //           //               color: Colors.white, fontSize: 16.h),
                  //           //         ),
                  //           //       ),
                  //           //     ],
                  //           //   ),
                  //           // );
                  //         },

                  //       ),
                  //     ));
                  return Text(
                    command_prompt,
                  );
                },
              ),
            ),
            Column(
              children: [
                Header(
                  isBack: true,
                  screenName: "BEHAVIOR PROTOCOL LIST",
                ),
              ],
            ),
          ],
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(15.r),
                  onTap: () async {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddSystemPrompt(
                                  id: '',
                                  isEdit: false,
                                  prompt: '',
                                )));
                  },
                  child: Ink(
                    width: 100,
                    height: 130,
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15.r),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.asset("assets/more.png"),
                        SizedBox(height: 5),
                        Text(
                          "ADD BEHAVIOR",
                          style: TextStyle(
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "PROTOCOL",
                          style: TextStyle(
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

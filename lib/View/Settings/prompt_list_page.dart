import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ihub/Controller/Backgroud_controller.dart';
import 'package:ihub/Controller/prompt_controller.dart';
import 'package:ihub/Service/Api_Service.dart';
import 'package:ihub/Utils/colors.dart';
import 'package:ihub/Utils/header.dart';
import 'package:ihub/View/Settings/system_promt_add_page.dart';

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
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.white,
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AddSystemPrompt(
                          id: '',
                          isEdit: false,
                          prompt: '',
                        )));
          },
          child: Icon(Icons.add, color: Colors.black), // icon color
        ),
        body: Stack(
          children: [
            GetX<BackgroudController>(
              builder: (BackgroudController controller) {
                return Positioned.fill(
                  child: CachedNetworkImage(
                    imageUrl:
                        controller.backgroundModel.value?.backgroundImage ?? "",
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        Image.asset(controller.defaultIMage, fit: BoxFit.cover),
                    errorWidget: (context, url, error) =>
                        Image.asset(controller.defaultIMage, fit: BoxFit.cover),
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

                  final dataList = controller.promptModel.value?.data ?? [];

                  if (dataList.isEmpty) {
                    return const Center(
                      child: Text(
                        'No prompt found',
                        style: TextStyle(color: Colors.black),
                      ),
                    );
                  }

                  return Padding(
                    padding: const EdgeInsets.only(top: 100),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: ListView.builder(
                        itemCount: dataList.length,
                        itemBuilder: (context, index) {
                          final item = dataList[index];
                          return Card(
                            color: Colors.white.withOpacity(0.8),
                            margin: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            child: ListTile(
                              onTap: () {
                                Get.dialog(
                                  barrierDismissible: false,
                                  AlertDialog(
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20.0)),
                                    ),
                                    title: Column(
                                      children: [
                                        Icon(
                                          Icons.warning,
                                          color: Colors.red,
                                          size: 50.h,
                                        ),
                                      ],
                                    ),
                                    content: Text(
                                      'Are you sure you want to edit or delete this prompt?',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 16.h),
                                    ),
                                    actionsAlignment: MainAxisAlignment.center,
                                    actions: [
                                      // Cancel Button
                                      OutlinedButton(
                                        onPressed: () {
                                          Get.back();
                                        },
                                        style: OutlinedButton.styleFrom(
                                          side: BorderSide(color: Colors.black),
                                        ),
                                        child: Text(
                                          "Cancel",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16.h,
                                          ),
                                        ),
                                      ),

                                      // Edit Button
                                      OutlinedButton(
                                        onPressed: () {
                                          Get.back();

                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      AddSystemPrompt(
                                                        id: item.id.toString(),
                                                        isEdit: true,
                                                        prompt:
                                                            item.commandPrompt ??
                                                                '',
                                                      )));
                                        },
                                        style: OutlinedButton.styleFrom(
                                          side: BorderSide(color: Colors.blue),
                                        ),
                                        child: Text(
                                          "Edit",
                                          style: TextStyle(
                                            color: Colors.blue,
                                            fontSize: 16.h,
                                          ),
                                        ),
                                      ),

                                      // Delete Button
                                      FilledButton(
                                        onPressed: () async {
                                          final response =
                                              await ApiServices.deletePrompt(
                                                  item.id ?? 0);
                                          print(response);

                                          Get.back();
                                          if (response['status'] == "ok") {
                                            Get.snackbar(
                                              margin: EdgeInsets.all(20),
                                              "Success",
                                              response['message'] ??
                                                  "Prompt deleted successfully",
                                              backgroundColor: Colors.green,
                                              colorText: Colors.white,
                                              snackPosition: SnackPosition.TOP,
                                              duration: Duration(seconds: 3),
                                            );
                                            Get.find<PromptController>()
                                                .fetchPrompt();
                                          } else {
                                            Get.snackbar(
                                              margin: EdgeInsets.all(20),
                                              "Error",
                                              response['message'] ??
                                                  "Something went wrong",
                                              backgroundColor: Colors.red,
                                              colorText: Colors.white,
                                              snackPosition: SnackPosition.TOP,
                                            );
                                          }
                                        },
                                        style: ButtonStyle(
                                          backgroundColor:
                                              WidgetStateProperty.all(
                                                  ColorUtils.userdetailcolor),
                                        ),
                                        child: Text(
                                          "Delete",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16.h),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              title:
                                  Text(item.commandPrompt ?? 'No Description'),
                            ),
                          );
                        },
                      ),
                    ),
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
      ),
    );
  }
}

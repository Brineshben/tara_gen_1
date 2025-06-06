import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ihub/Controller/Backgroud_controller.dart';
import 'package:ihub/Controller/prompt_controller.dart';
import 'package:ihub/Utils/header.dart';
import 'package:ihub/View/Settings/add_system_promt.dart';
import 'package:ihub/View/Settings/question_answer_list.dart';

class PromptListPage extends StatefulWidget {
  const PromptListPage({Key? key}) : super(key: key);

  @override
  State<PromptListPage> createState() => _PromptListPageState();
}

class _PromptListPageState extends State<PromptListPage> {
  final PromptController controller = Get.find<PromptController>();

  @override
  void initState() {
    super.initState();
    controller.fetchPrompt();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            // Background with blur
            GetX<BackgroudController>(
              builder: (bgController) {
                final imageUrl =
                    bgController.backgroundModel.value?.backgroundImage ??
                        bgController.defaultIMage;
                return Positioned.fill(
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      CachedNetworkImage(
                        imageUrl: imageUrl,
                        fit: BoxFit.cover,
                        placeholder: (_, __) => Image.asset(
                            bgController.defaultIMage,
                            fit: BoxFit.cover),
                        errorWidget: (_, __, ___) => Image.asset(
                            bgController.defaultIMage,
                            fit: BoxFit.cover),
                      ),
                      BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(color: Colors.black.withOpacity(0)),
                      ),
                    ],
                  ),
                );
              },
            ),

            // Prompt or Add button
            Center(
              child: GetX<PromptController>(
                builder: (controller) {
                  if (controller.isLoading.value) {
                    return const CircularProgressIndicator();
                  }

                  final data = controller.promptresponce?["data"];
                  final commandPrompt =
                      data?["command_prompt"]?.toString() ?? '';

                  if (commandPrompt.isEmpty) {
                    return ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const PromptInputScreen(
                              id: '',
                              initialPrompt: '',
                              isEdit: false,
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.add),
                      label: const Text("Add Behavior Protocol"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 15),
                      ),
                    );
                  }

                  return Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Stack(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.6,
                          padding: const EdgeInsets.only(
                              left: 20, top: 60, bottom: 20, right: 20),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Text(
                            commandPrompt,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.justify,
                          ),
                        ),
                        Positioned(
                          top: 10,
                          right: 20,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _optionButton(
                                icon: Icons.edit,
                                label: "Edit",
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => PromptInputScreen(
                                        id: data['id'].toString(),
                                        initialPrompt: commandPrompt,
                                        isEdit: true,
                                      ),
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(width: 10),
                              _optionButton(
                                icon: Icons.question_answer,
                                label: "Q&A",
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => QuestionAnswerListScreen(
                                        promptId: data['id'].toString(),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            ),

            // Header
            Column(
              children: [
                const Header(
                  isBack: true,
                  screenName: "BEHAVIOR PROTOCOL",
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _optionButton(
      {required IconData icon,
      required String label,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.7),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 16),
            const SizedBox(width: 4),
            Text(label,
                style: const TextStyle(color: Colors.white, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}

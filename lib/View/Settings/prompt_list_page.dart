import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ihub/Controller/prompt_controller.dart';
import 'package:ihub/Utils/glassmorphism.dart';
import 'package:ihub/View/Settings/question_answer_list.dart';

class PromptListPage extends StatefulWidget {
  const PromptListPage({Key? key}) : super(key: key);

  @override
  State<PromptListPage> createState() => _PromptListPageState();
}

class _PromptListPageState extends State<PromptListPage>
    with TickerProviderStateMixin {
  final PromptController controller = Get.find<PromptController>();
  final TextEditingController _promptController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  bool isEditing = false;
  bool isAdding = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    controller.fetchPrompt();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(-0.3, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    _promptController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _startEditing(String currentPrompt) {
    setState(() {
      isEditing = true;
      isAdding = false;
      _promptController.text = currentPrompt;
    });
    _animationController.forward();
    // Auto-focus with slight delay for smooth animation
    Future.delayed(const Duration(milliseconds: 100), () {
      _focusNode.requestFocus();
    });
  }

  void _startAdding() {
    setState(() {
      isAdding = true;
      isEditing = false;
      _promptController.clear();
    });
    _animationController.forward();
    Future.delayed(const Duration(milliseconds: 100), () {
      _focusNode.requestFocus();
    });
  }

  void _cancelEditing() {
    _animationController.reverse().then((_) {
      setState(() {
        isEditing = false;
        isAdding = false;
        _promptController.clear();
      });
    });
  }

  void _savePrompt() {
    if (_promptController.text.trim().isEmpty) return;

    final data = controller.promptresponce?["data"];

    if (isAdding) {
      // Call add prompt method
      controller.addPrompt(prompt: _promptController.text.trim(), context: context);
    } else {
      // Call edit prompt method
      controller.editPrompt(
        id: data['id'].toString(),
        prompt: _promptController.text.trim(),
        context: context
      );
    }

    _animationController.reverse().then((_) {
      setState(() {
        isEditing = false;
        isAdding = false;
        _promptController.clear();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
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
                    Color(0xFF608878).withOpacity(0.2), // light green
                    Color(0xFF18221E).withOpacity(0.2), // dark green
                  ],
                ),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(color: Colors.transparent),
              ),
            ),
            // Main Content
            Center(
              child: GetX<PromptController>(
                builder: (controller) {
                  if (controller.isLoading.value) {
                    return CircularProgressIndicator(
                      strokeWidth: 3,
                      color: Colors.white,
                    );
                  }

                  final data = controller.promptresponce?["data"];
                  final commandPrompt =
                      data?["command_prompt"]?.toString() ?? '';

                  if (commandPrompt.isEmpty && !isAdding) {
                    return _buildEmptyState();
                  }

                  return _buildMainContent(commandPrompt, data);
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(left: 30, top: 30),
              child: Row(
                children: [
                  ChildGlasmorphism(
                      borderRadius: 40,
                      child: InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                              size: 20,
                            ),
                          ))),
                  const SizedBox(width: 10),
                  const Text(
                    'BEHAVIOR PROTOCOL',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return ChildGlasmorphism(
      child: Container(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.psychology_outlined,
                size: 40,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "No Behavior Protocol Set",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Define how your AI assistant should behave",
              style: TextStyle(
                fontSize: 14,
                color: Colors.white60,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            _buildGradientButton(
              onPressed: _startAdding,
              icon: Icons.add_outlined,
              label: "Create Protocol",
              isPrimary: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainContent(String commandPrompt, dynamic data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // LEFT PANEL - Edit Form (animated)
          if (isEditing || isAdding)
            Expanded(
              child: SlideTransition(
                position: _slideAnimation,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: _buildEditPanel(),
                ),
              ),
            ),

          if (isEditing || isAdding) const SizedBox(width: 20),

          // RIGHT PANEL - View
          Expanded(
            flex: (isEditing || isAdding) ? 2 : 1,
            child: _buildViewPanel(commandPrompt, data),
          ),
        ],
      ),
    );
  }

  Widget _buildEditPanel() {
    return ChildGlasmorphism(
      child: Container(
        height: 400,
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  isAdding ? Icons.add_circle_outline : Icons.edit_outlined,
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  isAdding ? "Create New Protocol" : "Edit Protocol",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Input field
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: TextField(
                  controller: _promptController,
                  focusNode: _focusNode,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    height: 1.5,
                  ),
                  maxLines: null,
                  expands: true,
                  textAlignVertical: TextAlignVertical.top,
                  decoration: const InputDecoration(
                    hintText:
                        "Define how your AI should behave, respond, and interact...\n\nExample: Act as a professional assistant who provides clear, concise answers with a friendly tone.",
                    hintStyle: TextStyle(
                      color: Colors.white38,
                      fontSize: 14,
                      height: 1.4,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: _buildGradientButton(
                    onPressed: _cancelEditing,
                    icon: Icons.close_rounded,
                    label: "Cancel",
                    isPrimary: false,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildGradientButton(
                    onPressed: _savePrompt,
                    icon: Icons.check_rounded,
                    label: isAdding ? "Create" : "Save",
                    isPrimary: true,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildViewPanel(String commandPrompt, dynamic data) {
    return ChildGlasmorphism(
      child: Container(
        height: 400,
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with actions
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.psychology_outlined,
                      color: Colors.white,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "Current Protocol",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                if (commandPrompt.isNotEmpty && !isEditing && !isAdding)
                  Row(
                    children: [
                      _buildActionChip(
                        icon: Icons.edit_outlined,
                        label: "Edit",
                        onTap: () => _startEditing(commandPrompt),
                      ),
                      const SizedBox(width: 8),
                      _buildActionChip(
                        icon: Icons.question_answer_outlined,
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
              ],
            ),

            const SizedBox(height: 40),
            Text(
              commandPrompt,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Colors.white,
                height: 1.6,
              ),
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionChip({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: Colors.white, size: 14),
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGradientButton({
    required VoidCallback onPressed,
    required IconData icon,
    required String label,
    required bool isPrimary,
    bool isFullWidth = false,
  }) {
    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      height: 45,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(12),
          child: ChildGlasmorphism(
            borderRadius: 10,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    icon,
                    color: Colors.white,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    label,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: isPrimary ? FontWeight.w600 : FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

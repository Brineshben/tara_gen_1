import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ihub/Controller/description_controller.dart';
import 'package:ihub/Service/Api_Service.dart';
import 'package:ihub/Utils/glassmorphism.dart';
import 'package:ihub/Utils/toast.dart';

class TimeDescription extends StatefulWidget {
  const TimeDescription({super.key});

  @override
  State<TimeDescription> createState() => _TimeDescriptionState();
}

class _TimeDescriptionState extends State<TimeDescription> {
  final RxInt expandedIndex = (-1).obs;

  bool showEditPanel = false;
  String editTime = '';
  String editDescription = '';
  bool isEdit = false;
  int editId = 0;

  @override
  void initState() {
    super.initState();
    Get.find<DescriptionController>().fetchDescription();
  }

  // Method to show create panel
  void _showCreatePanel() {
    setState(() {
      showEditPanel = true;
      editTime = '';
      editDescription = '';
      isEdit = false;
      editId = 0;
    });
  }

  // Method to show edit panel
  void _showEditPanel(dynamic item) {
    setState(() {
      showEditPanel = true;
      editTime = item.timeOfDay ?? '';
      editDescription = item.description ?? '';
      isEdit = true;
      editId = item.id ?? 0;
    });
  }

  // Method to close panel
  void _closePanel() {
    setState(() {
      showEditPanel = false;
      editTime = '';
      editDescription = '';
      isEdit = false;
      editId = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GetX<DescriptionController>(
        builder: (controller) {
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.white),
            );
          }

          final dataList = controller.descriptionModel.value?.data ?? [];

          return Column(
            children: [
              // Header with Create Button
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 150, vertical: 10.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                  
                    if (!showEditPanel)
                      GestureDetector(
                        onTap: _showCreatePanel,
                        child: ChildGlasmorphism(
                          borderRadius: 12,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.add, color: Colors.white, size: 20),
                                SizedBox(width: 8),
                                Text(
                                  'Create New',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
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

              // Main Content
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: showEditPanel ? 30 : 150),
                  child: Row(
                    spacing: 20,
                    children: [
                      if (showEditPanel)
                        Expanded(
                          flex: 2,
                          child: GlassmorphismModal(
                            time: editTime,
                            description: editDescription,
                            isEdit: isEdit,
                            id: editId,
                            onClose: _closePanel,
                          ),
                        ),
                      Expanded(
                        flex: 4,
                        child: dataList.isEmpty
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.description_outlined,
                                      size: 64,
                                      color: Colors.white.withOpacity(0.5),
                                    ),
                                    SizedBox(height: 16),
                                    Text(
                                      'No descriptions found',
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.7),
                                        fontSize: 18,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      'Click "Create New" to add your first description',
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.5),
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : ListView.separated(
                                padding: EdgeInsets.symmetric(vertical: 10.h),
                                itemCount: dataList.length,
                                separatorBuilder: (_, __) =>
                                    SizedBox(height: 10.h),
                                itemBuilder: (context, index) {
                                  final item = dataList[index];
                                  final isExpanded =
                                      expandedIndex.value == index;

                                  return ChildGlasmorphism(
                                    borderRadius: 10,
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 16.w, vertical: 14.h),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                item.timeOfDayDisplay ??
                                                    'Unknown',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  IconButton(
                                                    icon: Icon(Icons.edit,
                                                        color: Colors.white70),
                                                    onPressed: () =>
                                                        _showEditPanel(item),
                                                  ),
                                                  IconButton(
                                                      icon: Icon(
                                                          Icons.delete_outline,
                                                          color:
                                                              Colors.white70),
                                                      onPressed: () async {
                                                        showDialog(
                                                          context: context,
                                                          builder: (context) {
                                                            return AlertDialog(
                                                              title: Text(
                                                                "Confirm Delete",
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                              content: Text(
                                                                  "Are you sure you want to delete this description?"),
                                                              actions: [
                                                                TextButton(
                                                                  onPressed: () =>
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop(),
                                                                  child: Text(
                                                                    "Cancel",
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .black),
                                                                  ),
                                                                ),
                                                                TextButton(
                                                                  onPressed:
                                                                      () async {
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                    final response =
                                                                        await ApiServices.deleteDescription(
                                                                            item.id ??
                                                                                0);
                                                                    if (response[
                                                                            'status'] ==
                                                                        "ok") {
                                                                      Get.find<
                                                                              DescriptionController>()
                                                                          .fetchDescription();

                                                                      showTopRightToast(
                                                                        color: Colors
                                                                            .green,
                                                                      
                                                                        message:
                                                                            response['message'] ??
                                                                                "Description deleted successfully",
                                                                      );
                                                                    } else {
                                                                      showTopRightToast(
                                                                        color: Colors
                                                                            .red,
                                                                       
                                                                        message:
                                                                            response['message'] ??
                                                                                "Something went wrong while deleting",
                                                                      );
                                                                    }
                                                                  },
                                                                  child: Text(
                                                                    "Delete",
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .red),
                                                                  ),
                                                                ),
                                                              ],
                                                            );
                                                          },
                                                        );
                                                      }),
                                                  IconButton(
                                                    icon: Icon(
                                                      isExpanded
                                                          ? Icons
                                                              .keyboard_arrow_up
                                                          : Icons
                                                              .keyboard_arrow_down,
                                                      color: Colors.white70,
                                                    ),
                                                    onPressed: () {
                                                      expandedIndex.value =
                                                          isExpanded
                                                              ? -1
                                                              : index;
                                                      setState(() {});
                                                    },
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                        // Expanded Content
                                        if (isExpanded)
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 10, horizontal: 15),
                                            child: ChildGlasmorphism(
                                              borderRadius: 10,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10,
                                                        vertical: 8),
                                                child: Text(
                                                  item.description ??
                                                      'No Description',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class GlassmorphismModal extends StatefulWidget {
  final String? time;
  final String description;
  final bool isEdit;
  final int id;
  final VoidCallback? onClose;

  const GlassmorphismModal({
    super.key,
    required this.time,
    required this.description,
    required this.isEdit,
    required this.id,
    this.onClose,
  });

  @override
  State<GlassmorphismModal> createState() => _GlassmorphismModalState();
}

class _GlassmorphismModalState extends State<GlassmorphismModal> {
  final TextEditingController textController = TextEditingController();

  final List<String> _timeOptions = [
    'morning',
    'afternoon',
    'evening',
    'night',
  ];

  String? _selectedTime;

  @override
  void initState() {
    super.initState();
    _selectedTime = widget.time?.isEmpty == true ? null : widget.time;
    textController.text = widget.description;
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant GlassmorphismModal oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.time != widget.time) {
      _selectedTime = widget.time?.isEmpty == true ? null : widget.time;
    }
    if (oldWidget.description != widget.description) {
      textController.text = widget.description;
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Get.find<DescriptionController>();

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
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header with close button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.isEdit
                              ? 'Edit Description'
                              : 'Create New Description',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.close, color: Colors.white70),
                          onPressed: widget.onClose,
                        ),
                      ],
                    ),
                    SizedBox(height: 20),

                    // Time Selection
                    DropdownButtonFormField<String>(
                      value: _selectedTime,
                      dropdownColor: Colors.black,
                      items: _timeOptions.map((time) {
                        return DropdownMenuItem(
                          value: time,
                          child: Text(
                            time[0].toUpperCase() + time.substring(1),
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedTime = value;
                        });
                      },
                      decoration: InputDecoration(
                        labelText: "Select Time of Day",
                        labelStyle: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                      ),
                    ),
                    SizedBox(height: 15),

                    // Description Input
                    Text(
                      'Description',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 12,
                      ),
                    ),
                    SizedBox(height: 5),
                    ChildGlasmorphism(
                      borderRadius: 10,
                      child: TextField(
                        controller: textController,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 16,
                        ),
                        maxLines: 5,
                        decoration: InputDecoration(
                          hintText: 'Enter description',
                          hintStyle: TextStyle(
                            color: Colors.white.withOpacity(0.4),
                            fontSize: 13,
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

                    // Action Buttons
                    Row(
                      spacing: 20,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Cancel Button
                        GestureDetector(
                          onTap: widget.onClose,
                          child: Container(
                            width: 100,
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                  color: Colors.white.withOpacity(0.3)),
                            ),
                            child: Center(
                              child: Text(
                                'Cancel',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.7),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),

                        // Submit Button
                        GestureDetector(
                          onTap: () {
                            if (_selectedTime == null ||
                                _selectedTime!.isEmpty) {
                              showTopRightToast(
                                color: Colors.orange,
                                message: "Please select a time of day",
                              );
                              return;
                            }
                            if (textController.text.trim().isEmpty) {
                              showTopRightToast(
                                color: Colors.orange,
                                message: "Please enter a description",
                              );
                              return;
                            }

                            if (widget.isEdit) {
                              provider.editDescription(
                                  description: textController.text.trim(),
                                  time: _selectedTime ?? '',
                                  id: widget.id.toString(),
                                  context: context);
                            } else {
                              provider.submitDescription(
                                  description: textController.text.trim(),
                                  time: _selectedTime ?? '',
                                  context: context);
                            }
                          },
                          child: ChildGlasmorphism(
                            borderRadius: 15,
                            child: SizedBox(
                              width: 150,
                              height: 40,
                              child: ShaderMask(
                                shaderCallback: (bounds) =>
                                    const LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [
                                    Color.fromARGB(219, 255, 255, 255),
                                    Color(0xFF999999),
                                  ],
                                ).createShader(bounds),
                                child: Obx(
                                  () => Center(
                                    child: provider.submiting.value
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
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
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          )
                                        : Text(
                                            widget.isEdit ? 'Update' : 'Create',
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
    );
  }
}

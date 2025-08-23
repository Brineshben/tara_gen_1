import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ihub/Controller/RobotresponseApi_controller.dart';
import 'package:ihub/Service/url_service.dart';
import 'package:ihub/Utils/glassmorphism.dart';
import 'package:ihub/Utils/toast.dart';

import '../../Utils/colors.dart';

class WebLink extends StatefulWidget {
  const WebLink({Key? key}) : super(key: key);

  @override
  State<WebLink> createState() => _WebLinkState();
}

class _WebLinkState extends State<WebLink> with TickerProviderStateMixin {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _urlController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  late AnimationController _slideController;
  late AnimationController _fadeController;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _hideSystemUI();
    getData();
  }

  getData() async {
    setState(() => _isLoading = true);
    try {
      final Map<String, dynamic> response = await UrlService.getUrls();
      print('web_url ${response}');
      _urlController.text = response['data']['url'] ?? '';
      _nameController.text = response['data']['name'] ?? '';
    } catch (e) {
      print('Error loading data: $e');
      showTopRightToast(
          context: context, message: "Error loading data", color: Colors.red);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _hideSystemUI() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  }

  @override
  void dispose() {
    _slideController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.black,
          resizeToAvoidBottomInset: false,
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
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF608878).withOpacity(0.15),
                      Color(0xFF18221E).withOpacity(0.25),
                      Color(0xFF0D1512).withOpacity(0.35),
                    ],
                  ),
                ),
              ),
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                child: Container(color: Colors.transparent),
              ),

              _buildForm(),

              // Loading overlay
              if (_isLoading) _buildLoadingOverlay(),

              // Back Button + Title
              Padding(
                padding: const EdgeInsets.only(left: 30, top: 30),
                child: Row(
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
                    const SizedBox(width: 10),
                    const Text(
                      'WEB LINK',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 200, vertical: 200),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildInputField(
                controller: _nameController,
                label: 'Display Name',
                icon: Icons.label_outline,
                maxLength: 30,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a display name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 24.h),
              _buildInputField(
                controller: _urlController,
                label: 'Website URL',
                icon: Icons.link_outlined,
                keyboardType: TextInputType.url,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a URL';
                  }
                  return null;
                },
              ),
              SizedBox(height: 40.h),
              _buildActionButton(
                label: _nameController.text.isNotEmpty
                    ? "Update Link"
                    : 'Create Link',
                icon: Icons.add_link,
                onPressed: _handleCreate,
                isPrimary: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int? maxLength,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: Colors.white.withOpacity(0.15),
          width: 1,
        ),
      ),
      child: TextFormField(
        controller: controller,
       style: GoogleFonts.poppins(fontSize: 16, color: Colors.white),
        keyboardType: keyboardType,
        maxLength: maxLength,
        validator: validator,
        decoration: InputDecoration(
          hintText: label,
           hintStyle: const TextStyle(color: Colors.white70),
          prefixIcon: Icon(
            icon,
            color: Colors.white,
            size: 20,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.r),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.r),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.r),
            borderSide: BorderSide(
              color: ColorUtils.userdetailcolor,
              width: 2,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.r),
            borderSide: BorderSide(
              color: Colors.red.withOpacity(0.8),
              width: 2,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.r),
            borderSide: BorderSide(
              color: Colors.red,
              width: 2,
            ),
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 16.h,
          ),
          counterText: '',
        ),
      ),
    );
  }


  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
    bool isPrimary = false,
  }) {
    return ChildGlasmorphism(
      borderRadius: 10,
      child: SizedBox(
        width: 200,
        height: 50,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(16.r),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: Colors.white, // white icon on glass
                size: 20,
              ),
              SizedBox(width: 10),
              Text(
                label,
                style: GoogleFonts.oxygen(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingOverlay() {
    return Center(
      child: Column(
        spacing: 10,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: Colors.white,
          ),
          Text(
            'Loading...',
            style: GoogleFonts.oxygen(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleCreate() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      Map<String, dynamic> response = await UrlService.addUrl(
        name: _nameController.text,
        urlpage: _urlController.text,
      );

      print('addurlresponse$response');

      if (response['status'] == 'ok') {
        showTopRightToast(
            context: context,
            message: "URL added successfully",
            color: Colors.green);

        Get.find<RobotresponseapiController>().getUrl();
      } else {
        String errorMessage = "Something went wrong";

        if (response.containsKey("url")) {
          errorMessage = response["url"][0];
        } else if (response.containsKey("name")) {
          errorMessage = response["name"][0];
        } else if (response.containsKey("message")) {
          errorMessage = response["message"];
        }

        showTopRightToast(
            context: context, message: errorMessage, color: Colors.red);
      }
    } catch (e) {
      showTopRightToast(
          context: context,
          message: "Network error. Please try again.",
          color: Colors.red);
    } finally {
      setState(() => _isLoading = false);
    }
  }
}

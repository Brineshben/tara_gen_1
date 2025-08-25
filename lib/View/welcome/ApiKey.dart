import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ihub/Controller/battery_Controller.dart';
import 'package:ihub/Utils/colors.dart';
import 'package:ihub/Utils/glassmorphism.dart';
import 'package:ihub/Utils/toast.dart';

import '../../Service/Api_Service.dart';

class ApiKey extends StatefulWidget {
  const ApiKey({Key? key}) : super(key: key);

  @override
  State<ApiKey> createState() => _ApiKeyState();
}

class _ApiKeyState extends State<ApiKey> {
  final _formKey = GlobalKey<FormState>();
  final _apiKeyCtrl = TextEditingController();
  final _apiKeyConfirmCtrl = TextEditingController();

  bool isLoading = false;
  bool _obscure = true;

  @override
  void initState() {
    super.initState();
    _hideSystemUI();
  }

  void _hideSystemUI() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  }

  @override
  void dispose() {
    _apiKeyCtrl.dispose();
    _apiKeyConfirmCtrl.dispose();
    super.dispose();
  }

  String? _validateKey(String? val) {
    final v = (val ?? '').trim();
    if (v.isEmpty) return 'Please enter a new API key';
    // Tighten this to your format — here we require 24–128 visible chars w/o spaces
    final reg = RegExp(r'^[A-Za-z0-9_\-\.~:/+=]{24,128}$');
    if (!reg.hasMatch(v)) {
      return 'Invalid format. Use 24–128 chars: A–Z, a–z, 0–9, _-.~:/+= (no spaces)';
    }
    return null;
  }

  Future<bool> _verifyAdminPin(BuildContext context) async {
    final pinCtrl = TextEditingController();
    final confirmWordCtrl = TextEditingController();
    bool acknowledged = false;

    final ok = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        final viewInsets = MediaQuery.of(context).viewInsets;
        return Padding(
          padding: EdgeInsets.only(bottom: viewInsets.bottom),
          child: ChildGlasmorphism(
            child: Container(
              padding: EdgeInsets.all(16.w),
              child: StatefulBuilder(
                builder: (context, setModalState) {
                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.warning_amber_rounded,
                                color: Colors.redAccent),
                            SizedBox(width: 8),
                            Text(
                              'Danger Zone: Rotate API Key',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.redAccent,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Updating this key may immediately change robot behavior, interrupt commands, '
                          'or revoke access for existing clients. Proceed only if you understand the impact.',
                          style: GoogleFonts.poppins(
                              fontSize: 12, color: Colors.white70),
                        ),
                        SizedBox(height: 16),
                        CheckboxListTile(
                          value: acknowledged,
                          activeColor: Colors.green,
                          onChanged: (v) =>
                              setModalState(() => acknowledged = v ?? false),
                          controlAffinity: ListTileControlAffinity.leading,
                          title: Text(
                            'I understand the risks and want to continue',
                            style: GoogleFonts.poppins(color: Colors.white),
                          ),
                          contentPadding: EdgeInsets.zero,
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Type UPDATE to continue',
                          style: GoogleFonts.poppins(
                              fontSize: 12, color: Colors.white70),
                        ),
                        TextField(
                          controller: confirmWordCtrl,
                          textCapitalization: TextCapitalization.characters,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'[A-Za-z]')),
                          ],
                          decoration: _fieldDecoration('UPDATE'),
                          style: const TextStyle(color: Colors.white),
                        ),
                        SizedBox(height: 12),
                        Text(
                          'Admin PIN',
                          style: GoogleFonts.poppins(
                              fontSize: 12, color: Colors.white70),
                        ),
                        TextField(
                          controller: pinCtrl,
                          obscureText: true,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(6),
                          ],
                          decoration: _fieldDecoration('Enter 6-digit PIN'),
                          style: const TextStyle(color: Colors.white),
                        ),
                        SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: Text('CANCEL',
                                  style: TextStyle(color: Colors.white)),
                            ),
                            SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: () async {
                                final wordOk =
                                    confirmWordCtrl.text.trim().toUpperCase() ==
                                        'UPDATE';
                                if (!acknowledged ||
                                    !wordOk ||
                                    pinCtrl.text.length != 6) {
                                  showTopRightToast(
                                    message: !acknowledged
                                        ? 'Please acknowledge the risks.'
                                        : (!wordOk
                                            ? 'Please type UPDATE to continue.'
                                            : 'PIN must be 6 digits.'),
                                    color: Colors.red,
                                  );
                                  return;
                                }
                                final pinValid =
                                    await _mockVerifyPin(pinCtrl.text);
                                if (!pinValid) {
                                  showTopRightToast(
                                    message: 'Invalid admin PIN.',
                                    color: Colors.red,
                                  );
                                  return;
                                }
                                Navigator.pop(context, true);
                              },
                              child: Text(
                                'CONFIRM',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );

    pinCtrl.dispose();
    confirmWordCtrl.dispose();
    return ok ?? false;
  }

  // Stub — wire this to your Auth service
  Future<bool> _mockVerifyPin(String pin) async {
    await Future.delayed(const Duration(milliseconds: 250));
    return pin == '200300';
  }

  InputDecoration _fieldDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.white38),
      contentPadding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),
      border: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(10)).r),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.blue, width: 1),
        borderRadius: const BorderRadius.all(Radius.circular(10)).r,
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.blue, width: 1),
        borderRadius: const BorderRadius.all(Radius.circular(10)).r,
      ),
      fillColor: Colors.blueGrey[900],
      filled: true,
    );
  }

  Future<void> _handleSubmit(Size size) async {
    if (!_formKey.currentState!.validate()) return;

    // Check confirm match
    final keyA = _apiKeyCtrl.text.trim();
    final keyB = _apiKeyConfirmCtrl.text.trim();
    if (keyA != keyB) {
      showTopRightToast(
        message: 'Keys do not match.',
        color: Colors.red,
      );
      return;
    }

    // Confirm in danger sheet + admin PIN
    final confirmed = await _verifyAdminPin(context);
    if (!confirmed) return;

    setState(() => isLoading = true);
    FocusManager.instance.primaryFocus?.unfocus();

    try {
      final resp = await ApiServices.ApiKey(Data: keyA);
      if (resp['status'] == 'ok') {
        if (mounted) {
          Navigator.of(context).pop();
          showTopRightToast(
            message: '${resp['message']}',
            color: Colors.green,
          );
        }
      } else {
        showTopRightToast(
          message: (resp['message']?.toString().isNotEmpty ?? false)
              ? resp['message'].toString()
              : 'Something went wrong.',
          color: Colors.red,
        );
      }
    } catch (e) {
      showTopRightToast(
        message: 'Network/API error: $e',
        color: Colors.red,
      );
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // Background
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/bg.png'), fit: BoxFit.cover),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(0xFF608878).withOpacity(0.2),
                  const Color(0xFF18221E).withOpacity(0.2),
                ],
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(color: Colors.transparent),
            ),
          ),

          // Content
          SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 100),
                child: Column(
                  children: [
                    GetX<BatteryController>(
                      builder: (controller) {
                        return Container(
                          margin: EdgeInsets.only(
                              left: 40.w, right: 40.w, top: 50.w, bottom: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'NEW API KEY',
                                style: TextStyle(
                                  fontSize: 25.h,
                                  fontWeight: FontWeight.bold,
                                  color: controller.foregroundColor.value,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                
                    // Danger banner
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 40.w),
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.red.withOpacity(0.5)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.dangerous, color: Colors.redAccent),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Changing the API key immediately affects robot control clients. '
                              'Ensure the robot is in a safe state before proceeding.',
                              style: GoogleFonts.poppins(
                                  color: Colors.red[200], fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),
                
                    // Key fields
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 40.w),
                      child: Column(
                        children: [
                          _buildInputField(
                            controller: _apiKeyCtrl,
                            validator: _validateKey,
                            obscure: _obscure,
                            hint: 'Enter new API key',
                            suffixIcon: IconButton(
                              onPressed: () =>
                                  setState(() => _obscure = !_obscure),
                              icon: Icon(
                                _obscure
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(height: 12),
                          _buildInputField(
                            controller: _apiKeyConfirmCtrl,
                            validator: _validateKey,
                            obscure: _obscure,
                            hint: 'Re-enter new API key',
                            suffixIcon: IconButton(
                              onPressed: () =>
                                  setState(() => _obscure = !_obscure),
                              icon: Icon(
                                _obscure
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),
                
                    // Submit
                    InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: isLoading ? null : () => _handleSubmit(size),
                      child: ChildGlasmorphism(
                        borderRadius: 10,
                        child: Container(
                          width: size.width * 0.22,
                          height: 50,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Center(
                            child: isLoading
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const SizedBox(
                                        width: 25,
                                        height: 25,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2,
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Text(
                                        'UPDATING…',
                                        style: GoogleFonts.poppins(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  )
                                : Text(
                                    'SUBMIT',
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),

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
                  'API KEY',
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
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hint,
    String? Function(String?)? validator,
    bool obscure = false,
    Widget? suffixIcon,
    int? maxLength,
    TextInputType? keyboardType,
    IconData? icon,
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
        obscureText: obscure,
        style: GoogleFonts.poppins(fontSize: 16, color: Colors.white),
        keyboardType: keyboardType,
        maxLength: maxLength,
        validator: validator,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white70),
          prefixIcon: icon != null
              ? Icon(icon, color: Colors.white, size: 20)
              : null,
          suffixIcon: suffixIcon,
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
            borderSide: const BorderSide(
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
}

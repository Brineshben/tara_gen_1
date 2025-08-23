import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ihub/Utils/glassmorphism.dart';
import 'package:ihub/Utils/toast.dart';

import '../../Controller/Login_api_controller.dart';
import '../../Utils/colors.dart';
import '../../Utils/popups.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true;

  @override
  void initState() {
    _hideSystemUI();
    super.initState();
  }

  void _hideSystemUI() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(children: [
        // Background with gradient overlay
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/bg.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.3),
                  Colors.black.withOpacity(0.6),
                ],
              ),
            ),
          ),
        ),

        // Animated floating particles
        ...List.generate(
          6,
          (index) => Positioned(
            left: (index * 100.0 + 50) % size.width,
            top: (index * 150.0 + 100) % size.height,
            child: Container(
              width: 4,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),

        // Main login content
        Center(
          child: Container(
            width: size.width * 0.9,
            padding: EdgeInsets.symmetric(horizontal: 100),
            child: BaseGlassmorphism(
              margin: EdgeInsets.all(20),
              padding: EdgeInsetsGeometry.symmetric(horizontal: 30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 30.h),

                  // Welcome Text
                  Text(
                    'Welcome Back',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  Text(
                    'Sign in to continue',
                    style: GoogleFonts.poppins(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                    ),
                  ),

                  SizedBox(height: 40.h),

                  // Username Field
                  _buildInputField(
                    controller: _usernameController,
                    label: 'Username',
                    icon: Icons.person_outline,
                    textInputAction: TextInputAction.done,
                  ),

                  SizedBox(height: 20.h),

                  // Password Field
                  _buildInputField(
                    controller: _passwordController,
                    label: 'Password',
                    icon: Icons.lock_outline,
                    isPassword: true,
                    textInputAction: TextInputAction.done,
                  ),

                  SizedBox(height: 15.h),

                  SizedBox(height: 30.h),

                  // Login Button
                  GetX<UserAuthController>(
                    builder: (authcontroller) {
                      return _buildLoginButton(authcontroller, size);
                    },
                  ),

                  SizedBox(height: 70.h),
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPassword = false,
    TextInputAction? textInputAction,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white.withOpacity(0.1),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
        ),
      ),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword ? _obscureText : false,
        textInputAction: textInputAction,
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 14,
        ),
        cursorColor: ColorUtils.userdetailcolor,
        decoration: InputDecoration(
           hintStyle: const TextStyle(color: Colors.white70),
          prefixIcon: Icon(
            icon,
            color: ColorUtils.userdetailcolor,
            size: 20,
          ),
          suffixIcon: isPassword
              ? GestureDetector(
                  onTap: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                  child: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility,
                    color: Colors.white.withOpacity(0.6),
                    size: 20,
                  ),
                )
              : null,
          hintText: label,
          labelStyle: GoogleFonts.poppins(
            color: Colors.white.withOpacity(0.7),
            fontSize: 14,
          ),
          floatingLabelStyle: GoogleFonts.poppins(
            color: ColorUtils.userdetailcolor,
            fontSize: 12,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
              color: ColorUtils.userdetailcolor,
              width: 2,
            ),
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton(UserAuthController authcontroller, Size size) {
    return Container(
      width: 200,
      height: 55,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: LinearGradient(
          colors: [
            ColorUtils.userdetailcolor,
            ColorUtils.userdetailcolor.withOpacity(0.8),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: ColorUtils.userdetailcolor.withOpacity(0.4),
            blurRadius: 15,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: authcontroller.isLoading.value
              ? null
              : () async {
                  final user = _usernameController.text.trim();
                  final psw = _passwordController.text.trim();

                  if (user.isEmpty) {
                    showTopRightToast(
                        color: Colors.red,
                        message: "Please enter your username.",
                        context: context);
                    return;
                  }

                  if (psw.isEmpty) {
                    showTopRightToast(
                        color: Colors.red,
                        message: "Please enter your password.",
                        context: context);

                    return;
                  }

                  authcontroller.login(
                    username: user,
                    password: psw,
                    context: context,
                  );
                },
          child: Center(
            child: authcontroller.isLoading.value
                ? SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "LOGIN",
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                        size: 18,
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

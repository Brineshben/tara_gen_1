
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ihub/Controller/RobotresponseApi_controller.dart';
import 'package:ihub/Controller/battery_Controller.dart';

import '../../Controller/Login_api_controller.dart';
import '../../Model/login_model.dart';
import '../../Service/check_connectivity.dart';
import '../../Service/sharedPreference.dart';
import '../../Utils/colors.dart';
import '../../Utils/popups.dart';
import '../Robot_Response/homepage.dart';

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
    initialize();
    super.initState();
  }

  void _hideSystemUI() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  }

  Future<void> initialize() async {
    LoginModel? loginApi = await SharedPrefs().getLoginData();

    Get.find<RobotresponseapiController>().getUrl();

    print("loginsgaredpreferencedata ${loginApi?.user?.id}");
    if (loginApi != null) {
      await Get.find<UserAuthController>().getUserLoginSaved(loginApi);
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => Homepage()),
          (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.black,
          resizeToAvoidBottomInset: false,
          body: Stack(
            children: [
              Positioned.fill(child: Image.asset("assets/bg.png")),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                child: SingleChildScrollView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  child:
                      GetX<BatteryController>(builder: (batteryController) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 30.w, vertical: 5.h),
                          child: Text(
                            'Hello !',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 30.h,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 30.w, vertical: 2.h),
                          child: Text(
                            'Sign in to your account',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 13.h,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: 5.h),
                
                        /// Username Field
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 30.w, vertical: 2.h),
                          child: TextFormField(
                            cursorColor: ColorUtils.userdetailcolor,
                            controller: _usernameController,
                            textInputAction: TextInputAction.done,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: ColorUtils.userdetailcolor,
                                    width: 2),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: ColorUtils.userdetailcolor),
                              ),
                              labelText: 'USERNAME',
                              labelStyle: TextStyle(
                                  color: ColorUtils.userdetailcolor,
                                  fontSize: 16.h),
                            ),
                          ),
                        ),
                
                        /// Password Field
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 30.w, vertical: 5.h),
                          child: TextFormField(
                                style: TextStyle(color: Colors.white),
                            cursorColor: ColorUtils.userdetailcolor,
                            textInputAction: TextInputAction.done,
                            obscureText: _obscureText,
                            controller: _passwordController,
                            decoration: InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: ColorUtils.userdetailcolor,
                                    width: 2),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: ColorUtils.userdetailcolor),
                              ),
                              labelText: 'PASSWORD',
                              labelStyle: TextStyle(
                                  color: ColorUtils.userdetailcolor,
                                  fontSize: 16.h),
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _obscureText = !_obscureText;
                                  });
                                },
                                child: Icon(
                                  _obscureText
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color:
                                      batteryController.foregroundColor.value,
                                ),
                              ),
                            ),
                          ),
                        ),
                
                        SizedBox(height: 50.h),
                
                        GetX<UserAuthController>(builder: (authcontroller) {
                          return Center(
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                splashColor: Colors.white,
                                highlightColor: Colors.white.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(20.r),
                                onTap: () async {
                                  checkInternet2(
                                    context: context,
                                    function: () async {
                                      final user =
                                          _usernameController.text.trim();
                                      final psw =
                                          _passwordController.text.trim();
                
                                      if (user.isEmpty) {
                                        ProductAppPopUps.submit(
                                          title: "FAILED",
                                          message:
                                              "Please enter your username.",
                                          actionName: "Close",
                                          iconData: Icons.error_outline,
                                          iconColor: Colors.red,
                                        );
                                        return;
                                      }
                
                                      if (psw.isEmpty) {
                                        ProductAppPopUps.submit(
                                          title: "FAILED",
                                          message:
                                              "Please enter your password.",
                                          actionName: "Close",
                                          iconData: Icons.error_outline,
                                          iconColor: Colors.red,
                                        );
                                        return;
                                      }
                
                                      authcontroller.login(
                                        username: user,
                                        password: psw,
                                        context: context,
                                      );
                                    },
                                  );
                                },
                                // child: buildInfoCard(size, 'LOGIN'),
                                child: Container(
                                  width: size.width * 0.20,
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 20),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: Colors.white,
                                    border: Border.all(color: Colors.blue),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.shade400,
                                        spreadRadius: 1,
                                        blurRadius: 5,
                                      ),
                                    ],
                                  ),
                                  height: 55,
                                  child: Center(
                                    child: authcontroller.isLoading.value
                                        ? CircularProgressIndicator(
                                            color: Colors.black,
                                          )
                                        : Text(
                                            "LOGIN",
                                            style: GoogleFonts.poppins(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      ],
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> checkInternet2(
    {required BuildContext context, required Function() function}) async {
  bool connected = await CheckConnectivity().check();
  print("internect connection is $connected");
  if (connected) {
    function();
  } else {
    ProductAppPopUps.submit(
      title: "Warning",
      message:
          "No internet connection. Please check your network and try again.",
      actionName: "Close",
      iconData: Icons.info_outline,
      iconColor: Colors.red,
    );
  }
}

Future<void> checkInternet1({
  required BuildContext context,
  required Function() function,
  required Function() function2,
}) async {
  bool connected = await CheckConnectivity().check();
  print("internect connection is $connected");
  if (connected) {
    function();
  } else {
    function2();
    Get.snackbar(
      'Alert', // Title
      'Network Error, Proceed it on offline Mode', // Message
      snackPosition: SnackPosition.BOTTOM,
      // Position (TOP or BOTTOM)
      backgroundColor: Colors.blueGrey,
      colorText: Colors.white,
      borderRadius: 10,
      margin: EdgeInsets.all(10),
      duration: Duration(seconds: 3),
      // Auto dismiss time
      icon: Icon(Icons.check_circle, color: Colors.white),
    );
  }
}

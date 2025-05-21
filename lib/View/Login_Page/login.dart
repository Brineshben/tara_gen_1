import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ihub/Controller/RobotresponseApi_controller.dart';
import 'package:lottie/lottie.dart';

import '../../Controller/Login_api_controller.dart';
import '../../Model/login_model.dart';
import '../../Service/check_connectivity.dart';
import '../../Service/sharedPreference.dart';
import '../../Utils/colors.dart';
import '../../Utils/popups.dart';
import '../Robot_Response/homepage.dart';
import '../Settings/settings.dart';

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
    // initialize();
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
          MaterialPageRoute(builder: (context) => const Homepage()),
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
              Positioned.fill(
                child: Center(
                  child: SizedBox(
                    width: size.width * 0.5,
                    height: size.width * 0.5,
                    child: Lottie.asset(
                      "assets/loginimage.json",
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          keyboardDismissBehavior:
                              ScrollViewKeyboardDismissBehavior.onDrag,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 30.w, vertical: 5.h),
                                child: Text(
                                  'Hello !',
                                  style: GoogleFonts.roboto(
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
                                  style: GoogleFonts.roboto(
                                    color: Colors.grey,
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
                                  textInputAction: TextInputAction.next,
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
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              /// Forgot Password
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10.w, vertical: 5.h),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    InkWell(
                                      onTap: () {},
                                      child: Text(
                                        "Forgot Password?",
                                        style: TextStyle(
                                          fontSize: 15.h,
                                          color: Colors.blue[900],
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              SizedBox(height: 50.h),

                              /// Login Button
                              Center(
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    splashColor: Colors.white,
                                    highlightColor:
                                        Colors.white.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(20.r),
                                    onTap: () async {
                                      checkInternet2(
                                        context: context,
                                        function: () async {
                                          String user =
                                              _usernameController.text.trim();
                                          String psw =
                                              _passwordController.text.trim();
                                          if (user.isNotEmpty) {
                                            if (psw.isNotEmpty) {
                                              await Get.find<
                                                      UserAuthController>()
                                                  .fetchUserData(
                                                      username: user,
                                                      password: psw);
                                              if (Get.find<UserAuthController>()
                                                  .isLoaded
                                                  .value) {
                                                print(
                                                    "User ID: ${Get.find<UserAuthController>().loginData.value?.user?.id ?? 0}");

                                                Navigator.pushReplacement(
                                                  context,
                                                  PageRouteBuilder(
                                                    transitionDuration:
                                                        Duration(
                                                            milliseconds: 300),
                                                    pageBuilder: (context,
                                                            animation,
                                                            secondaryAnimation) =>
                                                        Homepage(),
                                                    transitionsBuilder:
                                                        (context,
                                                            animation,
                                                            secondaryAnimation,
                                                            child) {
                                                      return FadeTransition(
                                                          opacity: animation,
                                                          child: child);
                                                    },
                                                  ),
                                                );

                                                ProductAppPopUps.submit(
                                                  title: "SUCCESS",
                                                  message: "Login successful",
                                                  actionName: "Close",
                                                  iconData: Icons.done,
                                                  iconColor: Colors.green,
                                                );
                                              }
                                            } else {
                                              ProductAppPopUps.submit(
                                                title: "FAILED",
                                                message:
                                                    "Please Enter your Password.",
                                                actionName: "Close",
                                                iconData: Icons.error_outline,
                                                iconColor: Colors.red,
                                              );
                                            }
                                          } else {
                                            ProductAppPopUps.submit(
                                              title: "FAILED",
                                              message:
                                                  "Please Enter Your Username.",
                                              actionName: "Close",
                                              iconData: Icons.error_outline,
                                              iconColor: Colors.red,
                                            );
                                          }
                                        },
                                      );
                                    },
                                    child: buildInfoCard(size, 'LOGIN'),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
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

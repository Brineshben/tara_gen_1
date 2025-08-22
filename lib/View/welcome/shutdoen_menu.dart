import 'package:flutter/material.dart';
import 'package:ihub/Service/Api_Service.dart';
import 'package:ihub/Service/sharedPreference.dart';
import 'package:ihub/Utils/glassmorphism.dart';
import 'package:ihub/Utils/toast.dart';
import 'package:ihub/View/welcome/login.dart' as login_page;
import 'package:ihub/View/Splash/Loading_Splash.dart';

class ShutdoenMenu extends StatefulWidget {
  const ShutdoenMenu({super.key});

  @override
  State<ShutdoenMenu> createState() => _ShutdoenMenuState();
}

class _ShutdoenMenuState extends State<ShutdoenMenu> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.45,
          padding: EdgeInsets.only(top: 100),
          child: Row(
            spacing: 20,
            children: [
              Expanded(
                child: InkWell(
                  onTap: () async {
                    final confirmRestart = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        backgroundColor: Colors.white,
                        title: Text(
                          'Restart Robot',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        content: Text(
                          'Are you sure you want to restart the robot?',
                          style: TextStyle(fontSize: 16, color: Colors.black54),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: Text('Cancel',
                                style: TextStyle(
                                    fontSize: 14, color: Colors.black)),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.orange,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text('Restart'),
                          ),
                        ],
                      ),
                    );

                    if (confirmRestart == true) {
                      Map<String, dynamic> resp =
                          await ApiServices.restart(true)
                              .timeout(Duration(seconds: 3));
                      if (resp['message'] == "Reboot status updated") {
                        setState(() {
                          isLoading = true;
                        });
                        Future.delayed(Duration(seconds: 4), () {
                          setState(() {});
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => LoadingSplash()),
                              (_) => false);
                        });
                      }
                    }
                  },
                  child: ChildGlasmorphism(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/restart.png',
                           width: 80,
                          color: Colors.white,
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Restart",
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () async {
                    final shouldTurnOff = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        backgroundColor: Colors.white,
                        title: Text(
                          'Power Off',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.black87,
                          ),
                        ),
                        content: Text(
                          'Are you sure you want to turn off the robot?',
                          style: TextStyle(fontSize: 16, color: Colors.black54),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.grey[700],
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                            ),
                            child:
                                Text('Cancel', style: TextStyle(fontSize: 14)),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.redAccent,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text('Turn Off',
                                style: TextStyle(fontSize: 14)),
                          ),
                        ],
                      ),
                    );

                    if (shouldTurnOff == true) {
                      try {
                        Map<String, dynamic> resp = await ApiServices.poweroff()
                            .timeout(Duration(seconds: 3));

                        if (resp['message'] == "Robot turned OFF") {
                          setState(() {
                            isLoading = true;
                          });
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => LoadingSplash()),
                              (_) => false);

                          Future.delayed(Duration(seconds: 4), () {
                            setState(() {});
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) => LoadingSplash()),
                                (_) => false);
                          });
                        }
                      } catch (e) {
                        showTopRightToast(
                            color: Colors.red,
                            context: context,
                            message: "Something went wrong");
                      }
                    }
                  },
                  child: ChildGlasmorphism(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/power.png",
                          width: 80,
                          color: Colors.white,
                        ),
                        SizedBox(height: 8),
                        Text("Power Off",
                            style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        backgroundColor: Colors.white,
                        title: Text(
                          'Logout App',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.black87,
                          ),
                        ),
                        content: Text(
                          'Are you sure you want to logout the app?',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black54,
                          ),
                        ),
                        actionsPadding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.grey[700],
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                            ),
                            child: Text(
                              'Cancel',
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                          TextButton(
                            onPressed: () async {
                              await SharedPrefs().removeLoginData();
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        login_page.LoginPage()),
                                (route) => false,
                              );
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.redAccent,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              'Logout',
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  child: ChildGlasmorphism(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/logout.png",
                            width: 80,
                          color: Colors.white,
                        ),
                        SizedBox(height: 8),
                        Text("Logout", style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (isLoading)
          Positioned(
            left: 0,
            right: 0,
            child: const Center(
              child: SizedBox(
                width: 200,
                height: 70,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    border: Border.fromBorderSide(
                        BorderSide(color: Colors.blueGrey)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 25,
                        height: 25,
                        child: CircularProgressIndicator(
                          color: Colors.black,
                          strokeWidth: 3,
                        ),
                      ),
                      SizedBox(width: 10),
                      Text(
                        "Loading...",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

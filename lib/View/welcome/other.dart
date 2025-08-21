import 'package:flutter/material.dart';
import 'package:ihub/Utils/glassmorphism.dart';
import 'package:ihub/Utils/web_view.dart';
import 'package:ihub/View/welcome/ApiKey.dart';
import 'package:ihub/View/welcome/add_url.dart';
import 'package:ihub/View/welcome/speed.dart';

class OtherSettings extends StatelessWidget {
  const OtherSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: MediaQuery.of(context).size.height * 0.3,
      width: MediaQuery.of(context).size.width * 0.7,
      padding: EdgeInsets.only(top: 50, bottom: 50),
      child: Column(
        spacing: 20,
        children: [
          Expanded(
            child: Row(
              spacing: 20,
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => ApiKey()));
                    },
                    child: ChildGlasmorphism(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/cryptography.png",
                            width: 90,
                            color: Colors.white,
                          ),
                          SizedBox(height: 8),
                          Text("API KEY",
                              style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SpeedControllerPage()));
                    },
                    child: ChildGlasmorphism(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/speed.png',
                            color: Colors.white,
                            width: 90,
                          ),
                          SizedBox(height: 8),
                          Text(
                            "Speed",
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => InAppWebViewScreen(
                            url:
                                'http://192.168.11.2/admin/index.html#/functions/wifi/client?freq=5GHz',
                          ),
                        ),
                      );
                    },
                    child: ChildGlasmorphism(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/3d-wifi.png",
                            width: 90,
                            color: Colors.white,
                          ),
                          SizedBox(height: 8),
                          Text("ROUTER SETTINGS",
                              style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              spacing: 20,
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => WebLink()));
                    },
                    child: ChildGlasmorphism(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/webLink.png",
                            width: 90,
                            color: Colors.white,
                          ),
                          SizedBox(height: 8),
                          Text("WEB LINK",
                              style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(child: SizedBox()),
                Expanded(child: SizedBox()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

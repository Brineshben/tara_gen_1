import 'package:flutter/material.dart';
import 'package:ihub/Utils/glassmorphism.dart';
import 'package:ihub/Utils/web_view.dart';
import 'package:ihub/View/Settings/ApiKey.dart';
import 'package:ihub/View/Settings/prompt_list_page.dart';
import 'package:ihub/View/welcome/description_option.dart';
import 'package:ihub/View/welcome/speed.dart';

import '../language/view/language_screen.dart';

class Behaviour extends StatelessWidget {
  const Behaviour({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      width: MediaQuery.of(context).size.width * 0.7,
      padding: EdgeInsets.only(top:50, bottom: 50),
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DescriptionScreen(),
                        ),
                      );
                    },
                    child: ChildGlasmorphism(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/square-pen.png",
                            width: 90,
                          ),
                          SizedBox(height: 8),
                          Text(
                            "Description",
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
                              builder: (context) => PromptListPage()));
                    },
                    child: ChildGlasmorphism(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/rotate-cw.png",
                            width: 90,
                          ),
                          SizedBox(height: 8),
                          Text("Protocol", style: TextStyle(color: Colors.white)),
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
                              builder: (context) => LanguageList()));
                    },
                    child: ChildGlasmorphism(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/translate.png",
                            width: 90,
                            color: Colors.white,
                          ),
                          SizedBox(height: 8),
                          Text("Language", style: TextStyle(color: Colors.white)),
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
                          Text("API KEY", style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                  ),
                ),
                 Expanded(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>SpeedControllerPage()));
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
        ],
      ),
    );
  }
}

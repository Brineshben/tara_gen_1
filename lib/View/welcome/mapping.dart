import 'package:flutter/material.dart';
import 'package:ihub/Utils/glassmorphism.dart';
import 'package:ihub/View/Settings/upload_Document.dart';
import 'package:ihub/View/welcome/Fulltour_dart.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class Mapping extends StatelessWidget {
  const Mapping({super.key});

  void openAnotherApp() async {
    const packageName = "com.slamtec.robostudio";
    final Uri androidUri = Uri.parse(
      "intent://#Intent;package=$packageName;end;",
    );
    try {
      if (await canLaunchUrl(Uri.parse("android-app://$packageName"))) {
        await launchUrl(Uri.parse("android-app://$packageName"));
        return;
      }

      if (await canLaunchUrl(androidUri)) {
        await launchUrl(androidUri);
        return;
      }

      Share.share("Hello from App A!");

      // Open Play Store if the app is not installed
      await launchUrl(
        Uri.parse(
          "https://play.google.com/store/apps/details?id=$packageName",
        ),
        mode: LaunchMode.externalApplication,
      );
    } catch (e) {
      print("Error launching app: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 50, bottom: 50, left: 50, right: 50),
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
                              builder: (context) => FullTourCreateScreen()));
                    },
                    child: ChildGlasmorphism(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/square-pen.png',
                            width: 90,
                          ),
                          SizedBox(height: 8),
                          Text(
                            "Add full tour",
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
                              builder: (context) => FileUploadScreen()));
                      // Navigator.push(context, MaterialPageRoute(builder: (context)=>ManageMap()));
                    },
                    child: ChildGlasmorphism(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/map1.png",
                            width: 90,
                          ),
                          SizedBox(height: 8),
                          Text("Manage map",
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
                      openAnotherApp();
                    },
                    child: ChildGlasmorphism(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/robo.png",
                            width: 90,
                            color: Colors.white,
                          ),
                          SizedBox(height: 8),
                          Text("Mapping",
                              style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                  ),
                ),

                // Cancel Button
                Expanded(child: SizedBox())
              ],
            ),
          ),
        ],
      ),
    );
  }
}

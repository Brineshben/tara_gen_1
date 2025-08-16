import 'package:flutter/material.dart';
import 'package:ihub/Utils/glassmorphism.dart';
import 'package:ihub/View/Settings/prompt_list_page.dart';
import 'package:ihub/View/welcome/description_option.dart';

import '../language/view/language_screen.dart';

class Behaviour extends StatelessWidget {
  const Behaviour({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.4,
      width: MediaQuery.of(context).size.width * 0.7,
      padding: EdgeInsets.only(top: 100),
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
    );
  }
}

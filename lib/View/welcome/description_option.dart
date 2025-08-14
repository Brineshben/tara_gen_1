import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:ihub/View/welcome/fulltour.dart';
import 'package:ihub/View/welcome/header.dart';
import 'package:ihub/View/welcome/place_description.dart';
import 'package:ihub/View/welcome/time_description.dart';

class DescriptionScreen extends StatefulWidget {
  const DescriptionScreen({super.key});

  @override
  State<DescriptionScreen> createState() => _DescriptionScreenState();
}

class _DescriptionScreenState extends State<DescriptionScreen> {
  int selectedTabIndex = 0;
  final List<String> tabs = ['Place description', 'Time description'];

  Widget _getCurrentScreen() {
    Widget screen;

    if (selectedTabIndex == 0) {
      screen = PlaceDescription();
    }  else {
      screen = TimeDescription();
    }
    return screen;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF608878).withOpacity(0.2), // light green
                  Color(0xFF18221E).withOpacity(0.2), // dark green
                ],
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(color: Colors.transparent),
            ),
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      margin: const EdgeInsets.only(left: 20),
                      decoration: BoxDecoration(
                        color: Colors.grey[600]?.withOpacity(0.8),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                    Spacer(),
                    Expanded(
                      flex: 2,
                      child: TabHeaderWidget(
                        onTabSelected: (index) {
                          setState(() {
                            selectedTabIndex = index;
                          });
                        },
                        selectedIndex: selectedTabIndex,
                        tabs: tabs,
                      ),
                    ),
                  ],
                ),
              ),
              _getCurrentScreen(),
            ],
          )
        ],
      ),
    );
  }
}

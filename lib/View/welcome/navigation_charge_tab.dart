import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:ihub/Utils/glassmorphism.dart';
import 'package:ihub/View/battery/view/battery_view.dart';
import 'package:ihub/View/welcome/fulltour_activate.dart';
import 'package:ihub/View/welcome/header.dart';
import 'package:ihub/View/welcome/navigation.dart';

class NavigationScreen extends StatefulWidget {
  final int selectedTabIndex;
  const NavigationScreen({super.key, required this.selectedTabIndex});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  int selectedTabIndex = 0;
  final List<String> tabs = ['Navigate', 'Charging', "Full tour"];

  Widget _getCurrentScreen() {
    Widget screen;

    if (selectedTabIndex == 0) {
      screen = NavigationsSection();
    } else if (selectedTabIndex == 1) {
      screen = BatteryScreen();
    } else {
      screen = FullTourModeScreen();
    }
    return screen;
  }

  @override
  void initState() {
    super.initState();
    selectedTabIndex = widget.selectedTabIndex; // assign passed data here
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
                padding: const EdgeInsets.only(top: 50, bottom: 20, left: 30),
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
                    Spacer(),
                    Expanded(
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

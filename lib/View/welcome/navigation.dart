import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:ihub/View/battery/view/battery_view.dart';
import 'package:ihub/View/welcome/header.dart';
import 'package:ihub/View/welcome/navigate.dart';

class NavigationScreen extends StatefulWidget {
  final int selectedTabIndex;
  const NavigationScreen({super.key, required this.selectedTabIndex});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  int selectedTabIndex = 0;
  final List<String> tabs = ['Navigate', 'Charging'];

  Widget _getCurrentScreen() {
    Widget screen;

    if (selectedTabIndex == 0) {
      screen = NavigationsSection();
    } else {
      screen = BatteryScreen();
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
                padding: const EdgeInsets.only(top: 50, bottom: 20),
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
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 20,
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

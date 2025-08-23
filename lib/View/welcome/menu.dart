import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:ihub/Utils/glassmorphism.dart';
import 'package:ihub/View/welcome/behaviour.dart';
import 'package:ihub/View/welcome/header.dart';
import 'package:ihub/View/welcome/mapping.dart';
import 'package:ihub/View/welcome/other.dart';
import 'package:ihub/View/welcome/shutdoen_menu.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  int selectedTabIndex = 0;
  final List<String> tabs = ['Behaviour', 'Map', "Shutdown", "Other"];
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: selectedTabIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onTabChanged(int index) {
    setState(() {
      selectedTabIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// Background image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/bg.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          /// Blur overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(0xFF608878).withOpacity(0.2),
                  const Color(0xFF18221E).withOpacity(0.2),
                ],
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(color: Colors.transparent),
            ),
          ),

          /// Content
          Column(
            children: [
              /// Top header with back + tabs
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
                   SizedBox(width: 400),

                    /// Tab header
                    Expanded(
                      child: TabHeaderWidget(
                        onTabSelected: _onTabChanged,
                        selectedIndex: selectedTabIndex,
                        tabs: tabs,
                      ),
                    ),
                  ],
                ),
              ),

              /// PageView for horizontal swipe
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 100),
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        selectedTabIndex = index;
                      });
                    },
                    children: const [
                      Behaviour(),
                      Mapping(),
                      ShutdoenMenu(),
                      OtherSettings()
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

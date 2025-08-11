import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:ihub/Utils/glassmorphism.dart';
import 'package:ihub/View/battery/view/battery_view.dart';
import 'package:ihub/View/welcome/fulltour.dart';
import 'package:ihub/View/welcome/header.dart';
import 'package:overlapped_carousel/overlapped_carousel.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  int selectedTabIndex = 0;
  final List<String> tabs = ['Navigate', 'Charging', 'Fulltour'];

  Widget _getCurrentScreen() {
    Widget screen;
    switch (selectedTabIndex) {
      case 0:
        screen = NavigationsSection();
        break;
      case 1:
        screen = BatteryScreen();
        break;
      case 2:
        screen = FullTourModeScreen();
        break;
      default:
        screen = NavigationsSection();
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

class NavigationsSection extends StatelessWidget {
  const NavigationsSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
                child: OverlappedCarousel(
              widgets: [
                Container(
                  color: Colors.red,
                ),
                Container(
                  color: Colors.white,
                ),
                Container(
                  color: Colors.teal,
                ),
                Container(
                  color: Colors.orange,
                ),
              ],
              currentIndex: 2,
              onClicked: (index) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("You clicked at $index"),
                  ),
                );
              },
              obscure: 0.4,
              skewAngle: 0.25,
            )),

            Container(
              width: 2,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.grey[600]!,
                    Colors.transparent,
                    Colors.grey[600]!,
                  ],
                ),
              ),
            ),

            // Right panel - Dynamic content based on selected tab
            Expanded(
                flex: 2,
                child: GridView.builder(
                  itemCount: 6,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    childAspectRatio: 0.9,
                  ),
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        // Handle navigation card tap
                      },
                      borderRadius: BorderRadius.circular(15),
                      child: ChildGlasmorphism(
                        borderRadius: 15,
                        borderColor: Colors.grey.withOpacity(0.3),
                        margin: EdgeInsets.zero,
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Navigation arrow icon
                              Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: const Icon(
                                  Icons.navigation,
                                  color: Colors.white70,
                                  size: 16,
                                ),
                              ),
                              const Spacer(),

                              // Hospital bed icon
                              const Icon(
                                Icons.bed,
                                color: Colors.white70,
                                size: 40,
                              ),
                              const SizedBox(height: 10),

                              // Hospital text
                              const Text(
                                'Hospital',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 4),

                              // Department text
                              Text(
                                'Cardio department',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white.withOpacity(0.6),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                )),
          ],
        ),
      ),
    );
  }
}

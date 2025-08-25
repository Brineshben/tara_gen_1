import 'package:flutter/material.dart';
import 'package:ihub/Utils/glassmorphism.dart';
// In your mode_container.dart file
class ModeCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color iconColor;
  final bool comingSoon;
  final bool teachingModeStatus;
  final VoidCallback onSelect;

  const ModeCard({
    super.key,
    required this.title,
    required this.icon,
    this.iconColor = Colors.white,
    this.comingSoon = false,
    this.teachingModeStatus = false,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSelect,
      child: ChildGlasmorphism(
        borderRadius: 16,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: [
                Icon(icon, size: 60, color: iconColor),
                if (teachingModeStatus && title == "Teaching Mode")
                  Positioned(
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.check,
                          size: 16, color: Colors.white),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            if (comingSoon)
              const Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Text(
                  "Coming Soon",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';

class ModeCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String imageUrl;
  final bool comingSoon;
  final File? pdfFile;
  final VoidCallback onSelect;
  final VoidCallback? onView;
  final VoidCallback? onUpload;

  const ModeCard({
    super.key,
    required this.title,
    required this.imageUrl,
    this.subtitle,
    this.comingSoon = false,
    this.pdfFile,
    required this.onSelect,
    this.onView,
    this.onUpload,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onSelect();
      },
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              image: DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  comingSoon
                      ? Colors.black.withOpacity(0.3)
                      : Colors.white.withOpacity(0.4),
                  BlendMode.darken,
                ),
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.all(14),
                child: comingSoon
                    ? null
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              shadows: [
                                Shadow(
                                  color: Colors.black.withOpacity(0.9),
                                  offset: Offset(1, 1),
                                  blurRadius: 3,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            pdfFile != null
                                ? pdfFile!.path.split('/').last
                                : "No PDF Selected",
                            style: TextStyle(
                              color: pdfFile != null
                                  ? Colors.greenAccent
                                  : Colors.white70,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Spacer(),
                          Row(
                            children: [
                              Expanded(
                                child: buildGlassButton(
                                  label: 'View',
                                  icon: Icons.picture_as_pdf,
                                  onTap: onView,
                                ),
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                child: buildGlassButton(
                                  label: 'Upload',
                                  icon: Icons.upload_file,
                                  onTap: onUpload,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
              ),
            ),
          ),
          if (comingSoon)
            Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "$title\nComing Soon",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      height: 1.5,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget buildGlassButton({
    required String label,
    required IconData icon,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.white30),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: Colors.white, size: 18),
                SizedBox(width: 6),
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

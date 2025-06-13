// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';

// class RhomboidContainer extends StatelessWidget {
//   final double width;
//   final double height;
//   final Color color;
//   final Widget? child;

//   const RhomboidContainer({
//     super.key,
//     this.width = 200,
//     this.height = 100,
//     this.color = Colors.blue,
//     this.child,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return ClipPath(
//       clipper: RhomboidClipper(),
//       child: Container(
//         width: width,
//         height: height,
//         color: color,
//         alignment: Alignment.center,
//         child: child,
//       ),
//     );
//   }
// }

// class RhomboidClipper extends CustomClipper<Path> {
//   @override
//   Path getClip(Size size) {
//     Path path = Path();
//     path.moveTo(size.width * 0.2, 0); // Top-left shifted
//     path.lineTo(size.width, 0); // Top-right
//     path.lineTo(size.width * 0.8, size.height); // Bottom-right shifted
//     path.lineTo(0, size.height); // Bottom-left
//     path.close();
//     return path;
//   }

//   @override
//   bool shouldReclip(CustomClipper<Path> oldClipper) => false;
// }

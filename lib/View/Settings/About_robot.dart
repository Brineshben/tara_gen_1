

// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:ihub/Utils/header.dart';


// class AboutRobot extends StatelessWidget {
//   const AboutRobot({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final Size size = MediaQuery.of(context).size;

//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: Column(
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Padding(
//                 padding: const EdgeInsets.only(left: 20, top: 30),
//                 child: Row(
//                   children: [
//                     GestureDetector(
//                       onTap: () {
//                         Navigator.pop(context);
//                       },
//                       child: Container(
//                         height: 60.h,
//                         width: 60.h,
//                         decoration: BoxDecoration(
//                             color: Colors.white.withOpacity(0.2),
//                             borderRadius: BorderRadius.circular(15).r),
//                         child: Icon(
//                           Icons.arrow_back_outlined,
//                           color: Colors.grey,
//                         ),
//                       ),
//                     ),
//                     SizedBox(width: 10),
//                     Center(
//                       child: Text(
//                         "TARA",
//                         style: GoogleFonts.oxygen(
//                             color: Colors.white,
//                             fontSize: 25.h,
//                             fontWeight: FontWeight.w700),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(top: 40),
//                 child: Text(
//                   "Version: 1.0.1",
//                   style: GoogleFonts.podkova(
//                       color: Colors.white,
//                       fontSize: 20,
//                       fontWeight: FontWeight.w500),
//                 ),
//               ),
//               Column(
//                 children: [
//                   Header(
//                     isBack: true,
//                     screenName: "",
//                   ),
//                 ],
//               ),
//             ],
//           ),
//           Expanded(
//             child: ModelViewer(
//               backgroundColor: Colors.black,
//               src: 'assets/mold.glb',
//               alt: 'A 3D model of an astronaut',
//               ar: true,
//               autoRotate: true,
//               disableZoom: false,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

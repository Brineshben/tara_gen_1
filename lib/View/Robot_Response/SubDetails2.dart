import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Utils/colors.dart';

class Subdetails2 extends StatefulWidget {
  const Subdetails2({Key? key}) : super(key: key);

  @override
  State<Subdetails2> createState() => _Subdetails2State();
}

class _Subdetails2State extends State<Subdetails2> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.8,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.blueGrey[900],
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Colors.blueAccent, width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  blurRadius: 10,
                  spreadRadius: 2,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "VIEW DETAILS",
                  style: GoogleFonts.orbitron(
                      color: Colors.blueAccent,
                      fontSize: 30.h,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),

                // Scrollable Container
                Expanded(
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildInfoRow("NAME", ""),
                        SizedBox(height: 5),
                        buildInfoRow("ID", ""),
                        SizedBox(height: 5),
                        buildInfoRow("GENDER", ""),
                        SizedBox(height: 5),
                        buildInfoRow("PURPOSE", ""),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),

                // OK Button
                GestureDetector(
                  onTap: () {
                    // Navigator.pushReplacement(
                    //     context,
                    //     MaterialPageRoute(
                    //       builder: (context) => RobotResponse(),
                    //     ));
                  },
                  child: Center(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            ColorUtils.userdetailcolor,
                            ColorUtils.userdetailcolor
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      width: 150.w,
                      height: 60.h,
                      child: Center(
                        child: Text(
                          'OK',
                          style: GoogleFonts.orbitron(
                              color: Colors.white,
                              fontSize: 20.h,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget buildInfoRow(String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 30),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 100.w,
              child: Text(
                label,
                style: GoogleFonts.orbitron(
                    color: Colors.blueAccent,
                    fontSize: 20.h,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Text(
              ":  ",
              style: GoogleFonts.orbitron(
                  color: Colors.white,
                  fontSize: 20.h,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
        Expanded(
          // Ensures that the value text takes available space
          child: Text(
            value.toUpperCase(),
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
            ),
            overflow: TextOverflow.visible, // Allows text to wrap
            softWrap: true,
          ),
        ),
      ],
    ),
  );
}

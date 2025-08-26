import 'package:flutter/material.dart';
import 'package:ihub/Utils/glassmorphism.dart';
import 'package:ihub/View/welcome/robotinfo.dart';

class CompnayLogo extends StatelessWidget {
  const CompnayLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onLongPress: () {

        Navigator.push(context, MaterialPageRoute(builder: (context)=> RobotInfo()));
      },
      child: BaseGlassmorphism(
        borderRadius: 40,
        padding: EdgeInsetsGeometry.all(0),
        child: Container(
          width: 200,
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.2),
            borderRadius: BorderRadius.circular(40),        
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.black,
                child: ClipOval(child: Image.asset("assets/bg_logo.png",)),
              ),
              SizedBox(width: 5),
              Stack(
                children: [
                  Image.asset("assets/compnay_logo.png", width: 130,color: Colors.white,),
                  Positioned(
                    top: 6,
                    left: 7,
                    child: Text(
                      "POWERED BY",
                      style: TextStyle(
                        fontSize: 5,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

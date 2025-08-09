import 'package:flutter/material.dart';

class CompnayLogo extends StatelessWidget {
  const CompnayLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(40),
        border: Border.all(color: Colors.blue),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade700,
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.black,
            child: ClipOval(child: Image.asset("assets/taraLogo.png")),
          ),
          SizedBox(width: 5),
          Stack(
            children: [
              Image.asset("assets/text_logo_ihub.png", width: 130),
              Positioned(
                top: 6,
                left: 7,
                child: Text(
                  "POWERED BY",
                  style: TextStyle(
                    fontSize: 5,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
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

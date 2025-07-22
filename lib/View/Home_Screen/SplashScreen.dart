import 'package:flutter/material.dart';


class Splash extends StatelessWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    Size size= MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: SizedBox(
            width:size.width*0.5,
            height: size.width*0.5,
            child: Image.asset("assets/splash.jpg"),
          ),
        )
    );
  }
}

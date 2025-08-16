
import 'package:flutter/material.dart';
import 'package:ihub/Utils/glassmorphism.dart';
import 'package:ihub/View/Settings/upload_Document.dart';
import 'package:ihub/View/welcome/Fulltour_dart.dart';

class Mapping extends StatelessWidget {
  const Mapping({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
     height: MediaQuery.of(context).size.height * 0.4,
      width: MediaQuery.of(context).size.width * 0.5,
      padding: EdgeInsets.only(top: 100),
      child: Row(
        spacing: 20,
        children: [
          Expanded(
            child: InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>FullTourCreateScreen()));
              },
              child: ChildGlasmorphism(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:  [
                   Image.asset('assets/square-pen.png', width: 90,),
                    SizedBox(height: 8),
                    Text(
                      "Add full tour",
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=> FileUploadScreen()));
                // Navigator.push(context, MaterialPageRoute(builder: (context)=>ManageMap()));
              },
              child: ChildGlasmorphism(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset("assets/map1.png", width: 90,),
                    SizedBox(height: 8),
                    Text("Manage map", style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

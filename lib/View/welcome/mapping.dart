
import 'package:flutter/material.dart';
import 'package:ihub/Utils/glassmorphism.dart';
import 'package:ihub/View/Robot_Response/Fulltour_dart.dart';
import 'package:ihub/View/Settings/upload_Document.dart';
import 'package:ihub/View/welcome/manage_map.dart';

class Mapping extends StatelessWidget {
  const Mapping({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.5,
        child: Padding( 
          padding: const EdgeInsets.symmetric(horizontal: 100),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 20,
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>ListAnimationdData()));
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
        ),
      ),
    );
  }
}

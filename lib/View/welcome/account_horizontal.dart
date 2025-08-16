import 'package:flutter/material.dart';
import 'package:ihub/View/welcome/capture_image.dart';

class AccountIconRow extends StatefulWidget {
  @override
  _AccountIconRowState createState() => _AccountIconRowState();
}

class _AccountIconRowState extends State<AccountIconRow> {
  bool _isExpanded = false;

  final List<Map<String, dynamic>> _icons = [
    {'icon': Icons.camera, 'label': 'Capture Image'},
    // {'icon': Icons.settings, 'label': 'Settings'},
    {'icon': Icons.logout, 'label': 'Logout'},
    {'icon': Icons.restart_alt, 'label': 'Restart'},
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          },
          child: CircleAvatar(
           radius: 25,
            backgroundColor: Colors.black,
            child: Icon(
              Icons.account_circle,
              size: 30,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(width: 10),
        AnimatedContainer(
          duration: Duration(milliseconds: 300),
          width: _isExpanded ? (_icons.length * 60).toDouble() : 0,
          height: 80,
          child: ListView(
            scrollDirection: Axis.horizontal,
            physics: NeverScrollableScrollPhysics(),
            children: _isExpanded
                ? _icons.map((item) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>CaptureAndQrPage()));
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          spacing: 5,
                          children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.grey[800],
                              child: Icon(item['icon'], color: Colors.white),
                            ),
                            Text(
                              item['label'],
                              style: TextStyle(color: Colors.white, fontSize: 10),
                            )
                          ],
                        ),
                      ),
                    );
                  }).toList()
                : [],
          ),
        ),
      ],
    );
  }
}

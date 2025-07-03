import 'package:flutter/material.dart';

class QuietStateBox extends StatelessWidget {
  final String title;
  final String subtitle;

  const QuietStateBox({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        SizedBox(height: 70),
        Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Colors.white,
              ),
              padding: EdgeInsets.symmetric(vertical: 25, horizontal: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset('assets/noData.png', height: 400),
                  SizedBox(height: 50),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25,color: Colors.black),
                  ),
                  SizedBox(height: 10),
                  Text(
                    subtitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15, letterSpacing: 1.1,color: Colors.black),
                  ),
                  SizedBox(height: 65),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

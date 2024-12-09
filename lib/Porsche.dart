import 'package:flutter/material.dart';
import 'package:porsche/Login.dart';

class Porsche extends StatefulWidget {
  const Porsche({Key? key}) : super(key: key);

  @override
  State<Porsche> createState() => _PorscheState();
}

class _PorscheState extends State<Porsche> {
  void _onScreenTapped() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Login()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: _onScreenTapped,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Image.asset(
                    "assets/porsche.png",
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(height: 40),
                      Text(
                        "AUTOIFOM",
                        style: TextStyle(color: Colors.white, fontSize: 25),
                      ),
                      SizedBox(height: 50),
                      Center(
                        child: Image.asset("assets/ICONE.png"),
                      ),
                      Text(
                        "PORSCHE",
                        style: TextStyle(color: Colors.white, fontSize: 50),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


import 'package:flutter/material.dart';

class RequestHeader extends StatelessWidget {
  const RequestHeader({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      height: size.height * 0.2,
      color: Colors.white,
      child: Stack(
        children: [
          Positioned(
            left: 10,
            bottom: 0,
            child: Container(
              height: size.height * 0.17,
              child: Image(
                image: AssetImage("assets/Images/requestHome.png"),
              ),
            ),
          ),
          Positioned(
            right: 30,
            top: size.height * 0.07,
            child: Container(
              height: size.height * 0.2,
              child: Column(
                children: const [
                  Text(
                    "GetiT",
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 47,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 2,
                    ),
                  ),
                  Text(
                    "La Dunga yrr!",
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

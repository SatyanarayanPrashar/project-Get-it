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
          Positioned(left: 0, top: 20, child: CollegeFlag()),
          Positioned(
            left: 50,
            bottom: 0,
            child: Container(
              height: size.height * 0.12,
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

class CollegeFlag extends StatefulWidget {
  const CollegeFlag({
    super.key,
  });

  @override
  State<CollegeFlag> createState() => _CollegeFlagState();
}

class _CollegeFlagState extends State<CollegeFlag>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  Animation? _expandAnimation;
  bool animeComplete = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1700),
      vsync: this,
    );

    _expandAnimation = Tween(begin: 0.1, end: 265.0).animate(_controller);

    _controller.forward();

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          animeComplete = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.43,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Color(0xff17056EAC),
            blurRadius: 10,
            spreadRadius: 3,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (BuildContext context, _) {
                return Container(
                  height: 25,
                  width: _expandAnimation?.value,
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 207, 241, 250),
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 7, right: 7),
                    child: Center(
                      child: Text(
                        "NMIT, Bengaluru",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 13.7,
                            color: Colors.black.withOpacity(0.6)),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

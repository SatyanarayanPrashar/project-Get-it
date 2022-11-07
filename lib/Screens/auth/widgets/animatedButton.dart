import 'package:flutter/material.dart';

class Button extends StatefulWidget {
  const Button({super.key, required this.buttonText});

  @override
  State<Button> createState() => _ButtonState();
  final String buttonText;
}

class _ButtonState extends State<Button> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  Animation? _expandAnimation;
  bool animeComplete = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 700),
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
      width: double.infinity,
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
        // fit: StackFit.expand,
        children: [
          Positioned(
            left: 62,
            top: 5,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (BuildContext context, _) {
                return Container(
                  height: 100,
                  width: _expandAnimation?.value,
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 236, 250, 249),
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                  child: animeComplete
                      ? Padding(
                          padding: const EdgeInsets.only(left: 60.0, right: 20),
                          child: Center(
                            child: Text(
                              widget.buttonText,
                              // overflow: TextOverflow.clip,
                              style: TextStyle(
                                  fontSize: 14.7,
                                  color: Colors.black.withOpacity(0.7)),
                            ),
                          ),
                        )
                      : null,
                );
              },
            ),
          ),
          Positioned(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(200),
              child: Container(
                height: 110,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 215, 252, 250),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xff17056EAC),
                      blurRadius: 10,
                      spreadRadius: 3,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: const Image(
                  image: AssetImage("assets/Icons/googleButton.png"),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

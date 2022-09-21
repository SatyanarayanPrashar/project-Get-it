import 'package:flutter/material.dart';
import 'package:get_it/Screens/auth/widgets/otpVerify.dart';
import 'package:get_it/Screens/auth/widgets/phoneAuth.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final controller = ScrollController();

    void scrolldown() {
      final double end = controller.position.maxScrollExtent / 2.2;
      controller.animateTo(end,
          duration: const Duration(milliseconds: 700),
          curve: Curves.easeInOutCubic);
    }

    void scrolltoOtp() {
      print("step1");
      final double further = controller.position.maxScrollExtent;
      controller.animateTo(further,
          duration: const Duration(milliseconds: 700),
          curve: Curves.easeInOutCubic);
    }

    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.9),
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        controller: controller,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: size.height * 0.8),
            Padding(
              padding: const EdgeInsets.only(left: 17, right: 17),
              child: InkWell(
                onTap: () {
                  // Authentication here
                  print("tapped");

                  scrolldown();
                },
                child: const Button(
                    buttonText:
                        "For seamless one-tap logins, please use your Google account to continue."),
              ),
            ),
            SizedBox(height: size.height * 0.08),
            PhoneAuth(),
            SizedBox(height: size.height * 0.08),
            OtpVerify(),
          ],
        ),
      ),
    );
  }
}

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
    return SizedBox(
      width: size.width,
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
                              style: TextStyle(fontSize: 14.7),
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
                color: const Color.fromARGB(255, 215, 252, 250),
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

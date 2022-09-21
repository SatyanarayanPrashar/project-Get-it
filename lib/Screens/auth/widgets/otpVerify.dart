import 'package:flutter/material.dart';

class OtpVerify extends StatefulWidget {
  const OtpVerify({super.key});

  @override
  State<OtpVerify> createState() => _OtpVerifyState();
}

class _OtpVerifyState extends State<OtpVerify> {
  TextEditingController otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: size.height * 0.35,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromARGB(255, 236, 250, 249)
                        .withOpacity(0.3),
                    spreadRadius: 7,
                    blurRadius: 7,
                  )
                ]),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 50, left: 10),
                  child: Text("Enter the OTP"),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: otpController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        hintText: "phone number",
                        prefixText: "+91 "),
                  ),
                ),
                // const Padding(
                //   padding: EdgeInsets.all(8.0),
                //   child: Text("You will reciece a 6-digit OTP on your number"),
                // ),
                const SizedBox(height: 24),
                Center(
                  child: OutlinedButton(
                    onPressed: () {
                      //
                    },
                    style: OutlinedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 236, 250, 249),
                      elevation: 2,
                      shadowColor: Colors.white,
                      shape: StadiumBorder(),
                    ),
                    child: const SizedBox(
                      height: 45,
                      width: 120,
                      child: Center(
                        child: Text(
                          "Done",
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        const SizedBox(height: 270),
      ],
    );
  }
}

import 'package:flutter/material.dart';

Future<void> showConfirmationDialog(
    {required BuildContext context,
    required String message,
    required VoidCallback? onPress}) async {
  Size size = MediaQuery.of(context).size;
  showDialog(
      context: context,
      builder: (context) => Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Container(
              margin: EdgeInsets.only(
                left: 0.05 * size.width,
                right: 0.05 * size.width,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 0.015 * size.height,
                  ),
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 0.02 * size.height),
                  ),
                  SizedBox(
                    height: 0.015 * size.height,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MaterialButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          "No",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 0.018 * size.height),
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        color: Colors.blue,
                      ),
                      SizedBox(
                        width: 0.05 * size.width,
                      ),
                      MaterialButton(
                        onPressed: onPress,
                        child: Text(
                          "Yes",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 0.018 * size.height),
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        color: Colors.blue,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 0.015 * size.height,
                  )
                ],
              ),
            ),
          ));
}

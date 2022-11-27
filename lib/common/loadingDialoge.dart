import 'package:flutter/material.dart';

class UIHelper {
  static void showLoadingDialog(BuildContext context, String? title) {
    AlertDialog screenloadingDialog = AlertDialog(
      elevation: 0,
      backgroundColor: Colors.grey.shade200.withOpacity(0.7),
      content: Container(
        // color: Colors.grey.shade200.withOpacity(0.5),
        alignment: FractionalOffset.center,
        height: 127,
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            const SizedBox(height: 27),
            Text(title ?? "loading")
          ],
        ),
      ),
    );

    showDialog(
        context: context,
        // barrierDismissible: false,
        barrierColor: Colors.transparent,
        builder: (context) {
          return screenloadingDialog;
        });
  }
}

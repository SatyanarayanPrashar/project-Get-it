import 'package:flutter/material.dart';
import 'package:get_it/common/loadingDialoge.dart';

class NotifPage extends StatelessWidget {
  const NotifPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: InkWell(
            onTap: () {
              UIHelper.showLoadingDialog(context, "Logging in...");
            },
            child: Text("Notifications")),
      ),
    );
  }
}

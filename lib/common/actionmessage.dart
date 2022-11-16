import 'package:flutter/material.dart';

class Actionmessage extends StatelessWidget {
  const Actionmessage({super.key, required this.message, this.icoN});
  final String message;
  final IconData? icoN;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      margin: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 211, 231, 244),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color.fromARGB(255, 173, 173, 173),
            blurRadius: 5,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              message,
              overflow: TextOverflow.clip,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black.withOpacity(0.7)),
            ),
            Icon(icoN)
          ],
        ),
      ),
    );
  }
}

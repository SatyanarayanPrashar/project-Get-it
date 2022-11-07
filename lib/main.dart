import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_it/Screens/HomePage/home.dart';
import 'package:get_it/Screens/auth/LoginPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xffFBFCFE),
        appBarTheme: AppBarTheme(elevation: 3),
      ),
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}

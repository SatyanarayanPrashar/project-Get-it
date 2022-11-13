import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_it/Screens/HomePage/home.dart';
import 'package:get_it/Screens/auth/LoginPage.dart';
import 'package:get_it/Screens/bttomNav.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xffFBFCFE),
        appBarTheme: AppBarTheme(
          elevation: 3,
          backgroundColor: Color(0xffFBFCFE),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: (FirebaseAuth.instance.currentUser != null)
          ? bottomNav()
          : LoginPage(),
    );
  }
}

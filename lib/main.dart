import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_it/Screens/auth/LoginPage.dart';
import 'package:get_it/Screens/bttomNav.dart';
import 'package:get_it/models/firebaseHelper.dart';
import 'package:get_it/models/localStorage.dart';
import 'package:get_it/models/userModel.dart';
import 'package:get_it/services/firebaseHelperService.dart';
import 'package:get_it/services/firebaseRequestServices.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

var uuid = Uuid();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  String? currentCollege = await LocalStorage.getCollege();
  User? currentUser = FirebaseAuth.instance.currentUser;

  if (currentUser != null) {
    if (currentCollege != null) {
      UserModel? thisUserModel = await FirebaseHelper.getUserModelById(
          currentUser.uid, currentCollege);
      if (thisUserModel != null) {
        runApp(
          MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (_) => RequestServices()),
              ChangeNotifierProvider(create: (_) => HelperService()),
            ],
            child: MyAppLogged(
                userModel: thisUserModel, firebaseUser: currentUser),
          ),
        );
      }
    }
  } else {
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => RequestServices()),
          ChangeNotifierProvider(create: (_) => HelperService()),
        ],
        child: const MyApp(),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xffFBFCFE),
        appBarTheme: AppBarTheme(
          elevation: 3,
          backgroundColor: Color(0xffFBFCFE),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}

class MyAppLogged extends StatelessWidget {
  final UserModel userModel;
  final User firebaseUser;

  const MyAppLogged(
      {super.key, required this.userModel, required this.firebaseUser});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          scaffoldBackgroundColor: Color(0xffFBFCFE),
          appBarTheme: AppBarTheme(
            elevation: 3,
            backgroundColor: Color(0xffFBFCFE),
          ),
        ),
        debugShowCheckedModeBanner: false,
        home: bottomNav(userModel: userModel, firebaseUser: firebaseUser));
  }
}

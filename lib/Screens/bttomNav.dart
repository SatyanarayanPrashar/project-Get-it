import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/Screens/ChatsPage.dart';
import 'package:get_it/Screens/HomePage/home.dart';
import 'package:get_it/Screens/NotifiPage.dart';
import 'package:get_it/Screens/profilescreens/ProfilePage.dart';
import 'package:get_it/models/userModel.dart';

class bottomNav extends StatefulWidget {
  final UserModel userModel;
  final User? firebaseUser;

  const bottomNav(
      {super.key, required this.userModel, required this.firebaseUser});

  @override
  State<bottomNav> createState() => _bottomNavState();
}

class _bottomNavState extends State<bottomNav> {
  @override
  int index = 0;
  late List<Widget> screens = [
    HomePage(
      userModel: widget.userModel,
    ),
    ChatPage(),
    NotifPage(),
    ProfilePage(
      userModel: widget.userModel,
    ),
  ];
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 10,
        unselectedFontSize: 10,
        unselectedIconTheme:
            IconThemeData(color: Colors.black.withOpacity(0.38)),
        unselectedLabelStyle: TextStyle(color: Colors.black.withOpacity(0.38)),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            activeIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            activeIcon: Icon(Icons.chat_bubble),
            icon: Icon(Icons.chat_bubble_outline_outlined),
            label: 'Chats',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_none_rounded),
            activeIcon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        onTap: (index) {
          setState(() {
            this.index = index;
          });
        },
        unselectedItemColor: Colors.black.withOpacity(0.38),
        selectedItemColor: Color(0xff008FE4),
        showUnselectedLabels: true,
        currentIndex: index,
      ),
      body: screens[index],
    );
  }
}

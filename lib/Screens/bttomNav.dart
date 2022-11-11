import 'package:flutter/material.dart';
import 'package:get_it/Screens/ChatsPage.dart';
import 'package:get_it/Screens/HomePage/home.dart';
import 'package:get_it/Screens/NotifiPage.dart';
import 'package:get_it/Screens/auth/SetProfilePage.dart';
import 'package:get_it/Screens/profilescreens/ProfilePage.dart';

class bottomNav extends StatefulWidget {
  const bottomNav({super.key});

  @override
  State<bottomNav> createState() => _bottomNavState();
}

class _bottomNavState extends State<bottomNav> {
  int index = 0;
  final screens = [
    HomePage(),
    ChatPage(),
    NotifPage(),
    ProfilePage(),
  ];

  @override
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

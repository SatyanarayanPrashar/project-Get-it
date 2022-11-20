import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/Screens/HomePage/HelpersScreen.dart';
import 'package:get_it/Screens/HomePage/RequestScreen.dart';
import 'package:get_it/Screens/HomePage/header.dart';
import 'package:get_it/models/userModel.dart';

class HomePage extends StatefulWidget {
  const HomePage(
      {super.key, required this.userModel, required this.firebaseUser});
  final UserModel userModel;
  final User firebaseUser;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      color: Color(0xffFBFCFE),
      child: SafeArea(
        child: DefaultTabController(
          length: 2,
          child: Scaffold(
            backgroundColor: Color(0xffFBFCFE),
            body: Container(
              child: NestedScrollView(
                floatHeaderSlivers: true,
                headerSliverBuilder: (context, innerBoxIsScrolled) {
                  return <Widget>[
                    SliverAppBar(
                      automaticallyImplyLeading: false,
                      collapsedHeight: 0,
                      expandedHeight: size.height * 0.2,
                      toolbarHeight: 0,
                      flexibleSpace: RequestHeader(
                        userModel: widget.userModel,
                      ),
                    ),
                    SliverPersistentHeader(
                      delegate: _SliverAppBarDelegate(
                        const TabBar(
                          unselectedLabelColor: Colors.grey,
                          unselectedLabelStyle:
                              TextStyle(fontWeight: FontWeight.w400),
                          labelColor: Colors.blue,
                          labelStyle: TextStyle(fontWeight: FontWeight.bold),
                          tabs: [
                            Tab(child: Text("Requests")),
                            Tab(child: Text("Helpers")),
                          ],
                        ),
                      ),
                      pinned: true,
                    ),
                  ];
                },
                body: TabBarView(
                  children: [
                    RequestScreen(
                      userModel: widget.userModel,
                      isOnHomepage: true,
                      firebaseUser: widget.firebaseUser,
                    ),
                    HelpersScreen(
                      userModel: widget.userModel,
                      firebaseUser: widget.firebaseUser,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height * 1.5;
  @override
  double get maxExtent => _tabBar.preferredSize.height * 1.5;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Column(
      children: [
        Container(
          color: Color(0xffFBFCFE),
          child: Padding(
            padding: const EdgeInsets.only(top: 7),
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey.withOpacity(0.6),
                ),
                width: 50,
                height: 5,
              ),
            ),
          ),
        ),
        Container(
          color: Color(0xffFBFCFE),
          child: _tabBar,
        ),
      ],
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}

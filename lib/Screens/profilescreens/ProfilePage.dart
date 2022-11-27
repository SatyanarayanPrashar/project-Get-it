import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/Screens/HomePage/RequestScreen.dart';
import 'package:get_it/Screens/HomePage/header.dart';
import 'package:get_it/Screens/profilescreens/aboutTab.dart';
import 'package:get_it/models/userModel.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage(
      {super.key, required this.userModel, required this.firebaseUser});
  final UserModel userModel;
  final User firebaseUser;

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
            body: SizedBox(
              child: NestedScrollView(
                floatHeaderSlivers: true,
                headerSliverBuilder: (context, innerBoxIsScrolled) {
                  return <Widget>[
                    SliverAppBar(
                        automaticallyImplyLeading: false,
                        collapsedHeight: 0,
                        expandedHeight: size.height * 0.2,
                        toolbarHeight: 0,
                        flexibleSpace: RequestHeader(userModel: userModel)),
                    SliverPersistentHeader(
                      delegate: _SliverAppBarDelegate(
                        const TabBar(
                          unselectedLabelColor: Colors.grey,
                          unselectedLabelStyle:
                              TextStyle(fontWeight: FontWeight.w400),
                          labelColor: Colors.blue,
                          labelStyle: TextStyle(fontWeight: FontWeight.bold),
                          tabs: [
                            Tab(child: Text("Profie")),
                            Tab(child: Text("Requests")),
                          ],
                        ),
                      ),
                      pinned: true,
                    ),
                  ];
                },
                body: TabBarView(
                  children: [
                    AboutTab(
                      userModel: userModel,
                      firebaseUser: firebaseUser,
                    ),
                    RequestScreen(
                      userModel: userModel,
                      firebaseUser: firebaseUser,
                      isOnHomepage: false,
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

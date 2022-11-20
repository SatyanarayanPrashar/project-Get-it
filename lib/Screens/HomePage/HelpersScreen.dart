import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/Screens/insiderScreens/HelperForm.dart';
import 'package:get_it/models/helperModel.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:get_it/models/userModel.dart';
import 'package:slide_to_act/slide_to_act.dart';

class HelpersScreen extends StatefulWidget {
  const HelpersScreen(
      {super.key, required this.userModel, required this.firebaseUser});
  final UserModel userModel;
  final User firebaseUser;

  @override
  State<HelpersScreen> createState() => _HelpersScreenState();
}

class _HelpersScreenState extends State<HelpersScreen> {
  late Future<QuerySnapshot> helperList;
  @override
  void initState() {
    super.initState();
    helperList = fetchHelpers();
  }

  Future<QuerySnapshot> fetchHelpers() async {
    final QuerySnapshot data = await FirebaseFirestore.instance
        .collection("College")
        .doc(widget.userModel.college)
        .collection("helpers")
        .orderBy("requestedOn", descending: true)
        .get();
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return HelperFormPage(
              userModel: widget.userModel,
              firebaseUser: widget.firebaseUser,
            );
          }));
        },
        backgroundColor: Colors.blue,
        child: Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16),
        child: FutureBuilder<QuerySnapshot>(
            future: helperList,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  QuerySnapshot requestSnapshot =
                      snapshot.data as QuerySnapshot;
                  return RefreshIndicator(
                    onRefresh: () async {
                      setState(() {
                        helperList = fetchHelpers();
                      });
                    },
                    child: ListView.builder(
                      itemCount: requestSnapshot.docs.length,
                      itemBuilder: (context, index) {
                        HelperModel currentHelper = HelperModel.fromMap(
                            requestSnapshot.docs[index].data()
                                as Map<String, dynamic>);

                        return Column(
                          children: [
                            HelperTile(
                              requestedon:
                                  currentHelper.requestedOn ?? DateTime.now(),
                              avilableon: currentHelper.helpOn ?? "NA :(",
                              helperName: currentHelper.helpBy ?? "NA:(",
                              helperUid: currentHelper.helperUid ?? "",
                              note: currentHelper.note,
                            ),
                            index == requestSnapshot.docs.length - 1
                                ? const Padding(
                                    padding: EdgeInsets.only(bottom: 11),
                                    child: Text("No more requests avialable"),
                                  )
                                : Container(),
                          ],
                        );
                      },
                    ),
                  );
                } else if (snapshot.hasError) {
                  return const Center(
                    child: Text("somthing went wrong :("),
                  );
                } else {
                  return const Center(
                    child: Text("YOu have not requested anything yet:("),
                  );
                }
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            }),
      ),
    );
  }
}

class HelperTile extends StatelessWidget {
  const HelperTile(
      {super.key,
      this.isUserHelper,
      this.helperName,
      required this.requestedon,
      this.note,
      this.avilableon,
      required this.helperUid});
  final bool? isUserHelper;
  final String? helperName;
  final String? helperUid;
  final DateTime requestedon;
  final String? note;
  final String? avilableon;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      margin: EdgeInsets.only(bottom: 7),
      width: size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Avatar , about and options
              const CircleAvatar(
                radius: 20,
                backgroundImage: AssetImage("assets/Images/praposalHome.png"),
              ),
              const SizedBox(
                width: 7,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    helperName ?? "NA:(",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    requestedon != null ? timeago.format(requestedon) : "NA :(",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 9,
                    ),
                  ),
                ],
              ),
            ],
          ),
          note != "" // if any note attached
              ? Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: ExpandableText(
                    note ?? "",
                    style: TextStyle(fontSize: 13),
                    expandText: "more",
                    collapseText: "show less",
                    maxLines: 2,
                    linkColor: Colors.black.withOpacity(0.3),
                    linkStyle: TextStyle(decoration: TextDecoration.underline),
                  ),
                )
              : Container(),
          Container(
            margin: EdgeInsets.only(top: 11, bottom: 11),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    width: size.width,
                    padding: EdgeInsets.all(11),
                    decoration: BoxDecoration(
                      color: Color(0xffA6BBDE).withOpacity(0.2),
                      border: Border.all(color: Color(0xffEAEAEA)),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    margin: EdgeInsets.only(right: 11),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Available on:",
                          style: TextStyle(fontSize: 11),
                        ),
                        Text(avilableon ?? "NA:("),
                      ],
                    ),
                  ),
                ),
                true
                    ? Flexible(
                        child: SlideAction(
                          onSubmit: () {
                            // Navigator.push(context,
                            //     MaterialPageRoute(
                            //         builder: (context) {
                            //   return RequestDetailPage();
                            // }));
                          },
                          outerColor: Colors.blue,
                          submittedIcon:
                              Icon(Icons.handshake, color: Colors.white),
                          animationDuration: Duration(milliseconds: 170),
                          height: 50,
                          sliderButtonIconSize: 17,
                          sliderButtonIconPadding: 11,
                          text: "ask for help",
                          textStyle: TextStyle(
                              fontSize: 12,
                              color: Colors.white.withOpacity(0.7)),
                        ),
                      )
                    : Container(),
              ],
            ),
          ),
          Divider(
            color: Color(0xffEAEAEA),
            thickness: 1,
          ),
        ],
      ),
    );
  }
}

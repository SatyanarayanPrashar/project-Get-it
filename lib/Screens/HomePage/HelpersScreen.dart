import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/Screens/insiderScreens/HelperForm.dart';
import 'package:get_it/Screens/insiderScreens/RequestFormPage.dart';
import 'package:get_it/common/actionmessage.dart';
import 'package:get_it/common/bottomSheet.dart';
import 'package:get_it/common/bottomsheetItem.dart';
import 'package:get_it/common/custom_confirmation_dialog.dart';
import 'package:get_it/models/helperModel.dart';
import 'package:get_it/services/firebaseHelperService.dart';
import 'package:provider/provider.dart';
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          widget.userModel.profileComplete ?? true
              ? Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return HelperFormPage(
                    userModel: widget.userModel,
                    firebaseUser: widget.firebaseUser,
                  );
                }))
              : ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Actionmessage(
                    message: 'Please Complete your profile!',
                  ),
                  duration: Duration(seconds: 2),
                  behavior: SnackBarBehavior.floating,
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                ));
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
      body: Consumer<HelperService>(
        builder: (context, helperNotifier, child) => Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: FutureBuilder<QuerySnapshot>(
              future: helperNotifier.fetchHelpers(widget.userModel),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    QuerySnapshot requestSnapshot =
                        snapshot.data as QuerySnapshot;
                    return RefreshIndicator(
                      onRefresh: () async {
                        setState(() {
                          // helperNotifier.fetchHelpers(widget.userModel);
                        });
                      },
                      child: requestSnapshot.docs.length == 0
                          ? Column(
                              children: [
                                Row(),
                                Container(
                                  height: 250,
                                  width: 250,
                                  decoration: const BoxDecoration(
                                    image: DecorationImage(
                                      image:
                                          AssetImage("assets/Images/auth.jpg"),
                                    ),
                                  ),
                                ),
                                Text("No Helpers Yet!")
                              ],
                            )
                          : ListView.builder(
                              itemCount: requestSnapshot.docs.length,
                              itemBuilder: (context, index) {
                                HelperModel currentHelper = HelperModel.fromMap(
                                    requestSnapshot.docs[index].data()
                                        as Map<String, dynamic>);

                                return Column(
                                  children: [
                                    HelperTile(
                                      userModel: widget.userModel,
                                      firebaseUser: widget.firebaseUser,
                                      requestedon: currentHelper.requestedOn ??
                                          DateTime.now(),
                                      avilableon:
                                          currentHelper.helpOn ?? "NA :(",
                                      helperName: currentHelper.helpBy,
                                      helperUid: currentHelper.helperUid ?? "",
                                      note: currentHelper.note,
                                      profilepic:
                                          currentHelper.helperProfilePic,
                                      helpId: currentHelper.helpUid ?? "",
                                    ),
                                    index == requestSnapshot.docs.length - 1
                                        ? const Padding(
                                            padding:
                                                EdgeInsets.only(bottom: 11),
                                            child: Text(
                                                "No more requests avialable"),
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
                      child: Text("You have not requested anything yet:("),
                    );
                  }
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }),
        ),
      ),
    );
  }
}

class HelperTile extends StatefulWidget {
  const HelperTile(
      {super.key,
      this.isUserHelper,
      this.helperName,
      required this.requestedon,
      this.note,
      this.avilableon,
      required this.helperUid,
      required this.userModel,
      required this.firebaseUser,
      this.profilepic,
      required this.helpId});

  final UserModel userModel;
  final User firebaseUser;
  final bool? isUserHelper;
  final String? helperName;
  final String? helperUid;
  final DateTime requestedon;
  final String? profilepic;
  final String? note;
  final String? avilableon;
  final String helpId;

  @override
  State<HelperTile> createState() => _HelperTileState();
}

class _HelperTileState extends State<HelperTile> {
  void deletehelp() async {
    FirebaseFirestore.instance
        .collection("College")
        .doc(widget.userModel.college)
        .collection("requests")
        .doc(widget.helpId)
        .delete()
        .then((value) {
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      margin: const EdgeInsets.only(bottom: 7),
      width: size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Avatar , about and options
              CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(widget.profilepic ?? ""),
              ),
              const SizedBox(
                width: 7,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.helperName ?? "NA:(",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    widget.requestedon != null
                        ? timeago.format(widget.requestedon)
                        : "NA :(",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 9,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              IconButton(
                onPressed: () {
                  //
                  showModalBottomSheet(
                    context: context,
                    backgroundColor: Colors.transparent,
                    builder: (context) => CustomBottomSheet(
                      height: size.height * 0.2,
                      childern: widget.helperUid == widget.userModel.uid
                          ? [
                              BottomSheetItems(
                                onTap: () async {
                                  //
                                },
                                title: "Share",
                              ),
                              BottomSheetItems(
                                onTap: () async {
                                  showConfirmationDialog(
                                      context: context,
                                      message:
                                          "Are you sure you want to delete this request?",
                                      onPress: () {
                                        deletehelp();
                                      });
                                },
                                title: "Delete",
                              ),
                            ]
                          : [
                              BottomSheetItems(
                                onTap: () {
                                  //
                                },
                                title: "Share",
                              ),
                            ],
                    ),
                  );
                },
                icon: Icon(
                  Icons.more_vert,
                  size: 21,
                  color: Colors.black.withOpacity(0.6),
                ),
              )
            ],
          ),
          widget.note != "" // if any note attached
              ? Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: ExpandableText(
                    widget.note ?? "",
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
                        Text(widget.avilableon ?? "NA:("),
                      ],
                    ),
                  ),
                ),
                widget.helperUid != widget.userModel.uid
                    ? Flexible(
                        child: SlideAction(
                          onSubmit: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return RequestForm(
                                userModel: widget.userModel,
                                firebaseUser: widget.firebaseUser,
                                isitPersonalised: true,
                                helperUid: widget.helperUid ?? "",
                              );
                            }));
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

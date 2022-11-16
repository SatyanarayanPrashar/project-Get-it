import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:get_it/Screens/insiderScreens/RequestDetailsPage.dart';
import 'package:get_it/Screens/insiderScreens/RequestFormPage.dart';
import 'package:get_it/common/bottomSheet.dart';
import 'package:get_it/common/bottomsheetItem.dart';
import 'package:get_it/models/requestModel.dart';
import 'package:get_it/models/userModel.dart';
import 'package:slide_to_act/slide_to_act.dart';
import 'package:timeago/timeago.dart' as timeago;

class RequestScreen extends StatefulWidget {
  RequestScreen(
      {super.key, required this.userModel, required this.isOnHomepage});
  final UserModel userModel;
  final bool isOnHomepage;

  @override
  State<RequestScreen> createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen> {
  late Future<QuerySnapshot> requestList;

  @override
  void initState() {
    super.initState();
    requestList = fetchRequests();
  }

  Future<QuerySnapshot> fetchRequests() async {
    final QuerySnapshot data = widget.isOnHomepage
        ? await FirebaseFirestore.instance
            .collection("College")
            .doc(widget.userModel.college)
            .collection("requests")
            .orderBy("requestedOn", descending: true)
            .get()
        : await FirebaseFirestore.instance
            .collection("College")
            .doc(widget.userModel.college)
            .collection("requests")
            .where("requestedby", isEqualTo: widget.userModel.fullname)
            .get();

    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return RequestForm(userModel: widget.userModel);
          }));
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16),
        child: FutureBuilder<QuerySnapshot>(
          future: requestList,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                QuerySnapshot requestSnapshot = snapshot.data as QuerySnapshot;
                return RefreshIndicator(
                  onRefresh: () async {
                    setState(() {
                      requestList = fetchRequests();
                    });
                  },
                  child: ListView.builder(
                    itemCount: requestSnapshot.docs.length,
                    itemBuilder: (context, index) {
                      RequestModel currentRequest = RequestModel.fromMap(
                          requestSnapshot.docs[index].data()
                              as Map<String, dynamic>);

                      return Column(
                        children: [
                          RequestTile(
                            requestedby: currentRequest.requestedBy,
                            note: currentRequest.note,
                            one: currentRequest.one,
                            oneQuantity: currentRequest.oneQuantity,
                            two: currentRequest.two,
                            twoQuantity: currentRequest.twoQuantity,
                            three: currentRequest.three,
                            threeQuantity: currentRequest.threeQuantity,
                            getitBy: currentRequest.getby,
                            price: currentRequest.price,
                            requestedon:
                                currentRequest.requestedOn ?? DateTime.now(),
                          ),
                          index == requestSnapshot.docs.length - 1
                              ? Text("No more requests avialable")
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
          },
        ),
      ),
    );
  }
}

class RequestTile extends StatefulWidget {
  final bool? isUserPost;
  final String? requestedby;
  final DateTime requestedon;
  final String? one;
  final String? oneQuantity;
  final String? two;
  final String? twoQuantity;
  final String? three;
  final String? threeQuantity;
  final String? getitBy;
  final String? price;
  final String? note;

  const RequestTile(
      {super.key,
      this.isUserPost,
      this.requestedby,
      required this.requestedon,
      this.one,
      this.oneQuantity,
      this.two,
      this.twoQuantity,
      this.three,
      this.threeQuantity,
      this.getitBy,
      this.price,
      this.note});

  @override
  State<RequestTile> createState() => _RequestTileState();
}

class _RequestTileState extends State<RequestTile> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return RequestDetailPage();
        }));
      },
      child: Container(
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
                      widget.requestedby ?? "NA :(",
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      widget.requestedon != null
                          ? timeago.format(widget.requestedon)
                          : "NA :(",
                      style: const TextStyle(
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
                        childern: widget.isUserPost ?? false
                            ? [
                                BottomSheetItems(
                                  onTap: () {
                                    //
                                  },
                                  title: "Share",
                                ),
                                BottomSheetItems(
                                  onTap: () {
                                    //
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
            widget.note != ""
                ? Padding(
                    padding: const EdgeInsets.only(top: 7),
                    child: ExpandableText(
                      widget.note ?? "",
                      style: const TextStyle(fontSize: 14),
                      expandText: "more",
                      collapseText: "show less",
                      maxLines: 2,
                      linkColor: Colors.black.withOpacity(0.3),
                      linkStyle:
                          const TextStyle(decoration: TextDecoration.underline),
                    ),
                  )
                : Container(),
            Container(
              margin: EdgeInsets.only(top: 11, bottom: 11),
              child: Row(
                children: [
                  Flexible(
                    child: Container(
                      // height: 107,
                      width: size.width * 0.57,
                      decoration: BoxDecoration(
                        color: Color(0xffA6BBDE).withOpacity(0.2),
                        border: Border.all(color: Color(0xffEAEAEA)),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.all(7),
                            margin: EdgeInsets.only(bottom: 4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Container(
                                    child: Text(widget.one ?? "",
                                        overflow: TextOverflow.clip),
                                  ),
                                ),
                                Text(widget.oneQuantity ?? ""),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(7),
                            margin: EdgeInsets.only(bottom: 4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Container(
                                    child: Text(widget.two ?? "",
                                        overflow: TextOverflow.clip),
                                  ),
                                ),
                                Text(widget.twoQuantity ?? ""),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(7),
                            margin: const EdgeInsets.only(bottom: 4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Container(
                                    child: Text(widget.three ?? "",
                                        overflow: TextOverflow.clip),
                                  ),
                                ),
                                // Spacer(),
                                Text(widget.threeQuantity ?? ""),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.all(7),
                            width: size.width,
                            decoration: BoxDecoration(
                              color: Color(0xffA6BBDE).withOpacity(0.2),
                              border: Border.all(color: Color(0xffEAEAEA)),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            margin: EdgeInsets.only(left: 11),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "GetiT by: ${widget.getitBy ?? ""}",
                                  style: TextStyle(fontSize: 11),
                                ),
                                Text(
                                  "Price: ${widget.price ?? ""}",
                                  style: TextStyle(fontSize: 11),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(11, 7, 0, 0),
                            width: size.width * 0.57,
                            child: SlideAction(
                              onSubmit: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return RequestDetailPage();
                                }));
                              },
                              outerColor: Colors.blue,
                              submittedIcon:
                                  Icon(Icons.handshake, color: Colors.white),
                              animationDuration: Duration(milliseconds: 170),
                              height: 50,
                              sliderButtonIconSize: 17,
                              sliderButtonIconPadding: 11,
                              text: "help",
                              textStyle: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white.withOpacity(0.7)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(
              color: Color(0xffEAEAEA),
              thickness: 1,
            ),
          ],
        ),
      ),
    );
  }
}

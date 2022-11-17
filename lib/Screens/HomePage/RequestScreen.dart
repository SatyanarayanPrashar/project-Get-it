import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_it/Screens/HomePage/requestTile.dart';
import 'package:get_it/Screens/insiderScreens/RequestFormPage.dart';
import 'package:get_it/models/requestModel.dart';
import 'package:get_it/models/userModel.dart';

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
                            requestUid: currentRequest.requestUid,
                            isUserPost: currentRequest.requestedBy ==
                                widget.userModel.fullname,
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
                            refresh: () {
                              print("refresh presed");
                              setState(() {
                                print("refresh in process");
                                requestList = fetchRequests();
                                print("refreshed");
                              });
                            },
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
          },
        ),
      ),
    );
  }
}

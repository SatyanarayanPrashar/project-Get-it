import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/Screens/HomePage/requestTile.dart';
import 'package:get_it/Screens/insiderScreens/RequestFormPage.dart';
import 'package:get_it/models/requestModel.dart';
import 'package:get_it/models/userModel.dart';
import 'package:get_it/services/firebaseRequestServices.dart';
import 'package:provider/provider.dart';

class RequestScreen extends StatefulWidget {
  RequestScreen(
      {super.key,
      required this.userModel,
      required this.isOnHomepage,
      required this.firebaseUser});
  final UserModel userModel;
  final bool isOnHomepage;
  final User firebaseUser;

  @override
  State<RequestScreen> createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return RequestForm(
              userModel: widget.userModel,
              firebaseUser: widget.firebaseUser,
              helperUid: "No helper required",
            );
          }));
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
      body: Consumer<RequestServices>(
        builder: (context, requestNotifier, child) => Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: FutureBuilder<QuerySnapshot>(
            future: requestNotifier.fetchRequests(
                widget.isOnHomepage, widget.userModel),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  QuerySnapshot requestSnapshot =
                      snapshot.data as QuerySnapshot;
                  return RefreshIndicator(
                    onRefresh: () async {
                      setState(() {
                        // requestNotifier.fetchRequests(true, widget.userModel);
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
                                    image: AssetImage("assets/Images/auth.jpg"),
                                  ),
                                ),
                              ),
                              Text("No requests Yet!")
                            ],
                          )
                        : ListView.builder(
                            itemCount: requestSnapshot.docs.length,
                            itemBuilder: (context, index) {
                              RequestModel currentRequest =
                                  RequestModel.fromMap(
                                      requestSnapshot.docs[index].data()
                                          as Map<String, dynamic>);

                              return Column(
                                children: [
                                  RequestTile(
                                    tileLocation: "homepg",
                                    requestid: currentRequest.requestid,
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
                                    requestedon: currentRequest.requestedOn ??
                                        DateTime.now(),
                                    loggedUserModel: widget.userModel,
                                    firebaseUser: widget.firebaseUser,
                                    profilePic:
                                        currentRequest.requesterProfilePic,
                                  ),
                                  index == requestSnapshot.docs.length - 1
                                      ? const Padding(
                                          padding: EdgeInsets.only(bottom: 11),
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
      ),
    );
  }
}

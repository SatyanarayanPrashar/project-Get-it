import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/Screens/bttomNav.dart';
import 'package:get_it/common/actionmessage.dart';
import 'package:get_it/common/commonTextField.dart';
import 'package:get_it/models/requestModel.dart';
import 'package:get_it/models/userModel.dart';

import '../../main.dart';

class RequestForm extends StatefulWidget {
  const RequestForm({
    super.key,
    required this.userModel,
    required this.firebaseUser,
    this.isitPersonalised,
  });
  final UserModel userModel;
  final User firebaseUser;
  final bool? isitPersonalised;

  @override
  State<RequestForm> createState() => _RequestFormState();
}

class _RequestFormState extends State<RequestForm> {
  TextEditingController getitBycontroller = TextEditingController();
  TextEditingController pricecontroller = TextEditingController();
  TextEditingController notecontroller = TextEditingController();

  TextEditingController onecontroller = TextEditingController();
  TextEditingController onequantitycontroller = TextEditingController();

  TextEditingController twocontroller = TextEditingController();
  TextEditingController twoQuantitycontroller = TextEditingController();

  TextEditingController threecontroller = TextEditingController();
  TextEditingController threequantitycontroller = TextEditingController();

  bool sendtohelperonly = false;
  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      sendtohelperonly = widget.isitPersonalised ?? false;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    void createRequest() async {
      String requestUid = uuid.v1();
      if (getitBycontroller.text.isNotEmpty) {
        if (onecontroller.text.isNotEmpty) {
          if (onequantitycontroller.text.isNotEmpty) {
            if (pricecontroller.text.isNotEmpty) {
              RequestModel newRequest = RequestModel(
                requestUid: requestUid,
                getby: getitBycontroller.text,
                requestedBy: widget.userModel.fullname,
                requesterUid: widget.userModel.uid,
                requestedOn: DateTime.now(),
                price: pricecontroller.text,
                note: notecontroller.text.trim(),
                one: onecontroller.text.trim(),
                two: twocontroller.text.trim(),
                three: threecontroller.text.trim(),
                oneQuantity: onequantitycontroller.text.trim(),
                twoQuantity: twoQuantitycontroller.text.trim(),
                threeQuantity: threequantitycontroller.text.trim(),
                status: "pending",
                personalised: sendtohelperonly,
              );
              FirebaseFirestore.instance
                  .collection("College")
                  .doc(widget.userModel.college)
                  .collection("requests")
                  .doc(requestUid)
                  .set(newRequest.toMap())
                  .then((value) {
                FirebaseFirestore.instance
                    .collection("College")
                    .doc(widget.userModel.college)
                    .update({"requestCount": FieldValue.increment(1)});

                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) {
                  return bottomNav(
                    userModel: widget.userModel,
                    firebaseUser: widget.firebaseUser,
                  );
                }));
              });
            } else {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Actionmessage(
                  message: 'Please enter the price you can offer!',
                ),
                duration: Duration(seconds: 2),
                behavior: SnackBarBehavior.floating,
                elevation: 0,
                backgroundColor: Colors.transparent,
              ));
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Actionmessage(
                message: 'Please enter item ones quantity!',
              ),
              duration: Duration(seconds: 2),
              behavior: SnackBarBehavior.floating,
              elevation: 0,
              backgroundColor: Colors.transparent,
            ));
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Actionmessage(
              message: 'Please enter the item 1!',
            ),
            duration: Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
            elevation: 0,
            backgroundColor: Colors.transparent,
          ));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Actionmessage(
            message: 'Please enter get it by!',
          ),
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          elevation: 0,
          backgroundColor: Colors.transparent,
        ));
      }
    }

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black.withOpacity(0.6)),
        title: Text(
          "GetiT",
          style: TextStyle(color: Colors.black.withOpacity(0.6)),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const SizedBox(height: 20),
              commonTextField(
                inputcontroller: getitBycontroller,
                title: "Get it by",
                hint: "Enter date or time",
                enableToolTip: true,
                tiptool:
                    "Enter the Date or time by when you want to recive the requested items. :D",
              ),
              commonTextField(
                inputcontroller: notecontroller,
                title: "Note",
                hint: "Add a note",
                enableToolTip: true,
                tiptool: "You can add a note for the helper :D",
              ),
              Row(
                children: [
                  Expanded(
                    child: commonTextField(
                      inputcontroller: onecontroller,
                      title: "Requested Items",
                      hint: "item 1",
                      enableToolTip: true,
                      tiptool:
                          "Enter the price you are willing to pay for the requested items. :D",
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 11),
                    child: commonTextField(
                      inputcontroller: onequantitycontroller,
                      title: "Quatity:",
                      hint: "quantity",
                      length: size.width * 0.3,
                      enableToolTip: true,
                      tiptool: "eg. 1kg, 1 dozen, 10 pieces :D",
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: commonTextField(
                      inputcontroller: twocontroller,
                      hint: "item 2",
                      enableToolTip: true,
                      disabletitle: true,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 11),
                    child: commonTextField(
                      inputcontroller: twoQuantitycontroller,
                      hint: "quantity",
                      length: size.width * 0.3,
                      disabletitle: true,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: commonTextField(
                      inputcontroller: threecontroller,
                      hint: "item 2",
                      disabletitle: true,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 11),
                    child: commonTextField(
                      inputcontroller: threequantitycontroller,
                      hint: "quantity",
                      length: size.width * 0.3,
                      disabletitle: true,
                    ),
                  ),
                ],
              ),
              commonTextField(
                inputcontroller: pricecontroller,
                title: "Price:",
                hint: "Enter total Price",
                enableToolTip: true,
                tiptool:
                    "Enter the price you are willing to pay for the requested items. :D",
              ),
              widget.isitPersonalised ?? false
                  ? Row(
                      children: [
                        const Text(
                          "Send request on global too",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Color(0xff385585)),
                        ),
                        Checkbox(
                          value: !sendtohelperonly,
                          onChanged: (value) {
                            setState(() {
                              sendtohelperonly = !sendtohelperonly;
                            });
                          },
                        ),
                      ],
                    )
                  : Container(),
              InkWell(
                onTap: () {
                  createRequest();
                },
                child: Container(
                  width: size.width,
                  height: 45,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                      child: Text(
                    "Done",
                    style: TextStyle(color: Colors.white),
                  )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

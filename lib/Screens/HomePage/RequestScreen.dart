import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:get_it/Screens/insiderScreens/RequestDetailsPage.dart';
import 'package:get_it/common/bottomSheet.dart';
import 'package:get_it/common/bottomsheetItem.dart';
import 'package:slide_to_act/slide_to_act.dart';
import 'package:slider_button/slider_button.dart';

class RequestScreen extends StatelessWidget {
  const RequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16),
        child: ListView.builder(
          physics: BouncingScrollPhysics(),
          itemCount: 10,
          itemBuilder: (context, index) => RequestTile(isUserPost: false),
        ),
      ),
    );
  }
}

class RequestTile extends StatefulWidget {
  final bool? isUserPost;

  const RequestTile({super.key, this.isUserPost});

  @override
  State<RequestTile> createState() => _RequestTileState();
}

class _RequestTileState extends State<RequestTile> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
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
                children: const [
                  Text(
                    "Anupam",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    "18 minutes ago",
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
                      height: size.height * 0.25,
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
          Padding(
            padding: const EdgeInsets.only(top: 7),
            child: ExpandableText(
              "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam lobortis dignissim tortor. Nunc a suscipit libero. Aliquam convallis tellus sit amet rutrum tristique Lorem ipsum dolor sit amet, consectetur adipiscing elit. Lorem ipsum dolor sit amet, consectetur adipiscing elit..",
              style: TextStyle(fontSize: 14),
              expandText: "more",
              collapseText: "show less",
              maxLines: 2,
              linkColor: Colors.black.withOpacity(0.3),
              linkStyle: TextStyle(decoration: TextDecoration.underline),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 11, bottom: 11),
            child: Row(
              children: [
                Flexible(
                  child: Container(
                    height: 107,
                    width: size.width * 0.57,
                    decoration: BoxDecoration(
                      color: Color(0xffA6BBDE).withOpacity(0.2),
                      border: Border.all(color: Color(0xffEAEAEA)),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    alignment: Alignment.center,
                    child: Center(
                      child: ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: 1,
                        itemBuilder: (context, index) {
                          return Container(
                            padding: EdgeInsets.all(7),
                            margin: EdgeInsets.only(bottom: 4),
                            child: Row(
                              children: [
                                Text("Apple"),
                                Spacer(),
                                Text("1 kg"),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 107,
                    child: Column(
                      children: [
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 11, vertical: 4),
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
                                "GetiT by:",
                                style: TextStyle(fontSize: 11),
                              ),
                              Text("11 December"),
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
          Divider(
            color: Color(0xffEAEAEA),
            thickness: 1,
          ),
        ],
      ),
    );
  }
}

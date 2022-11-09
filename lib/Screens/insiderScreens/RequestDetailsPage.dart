import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:get_it/Screens/HomePage/RequestScreen.dart';
import 'package:slide_to_act/slide_to_act.dart';
import 'package:slider_button/slider_button.dart';

class RequestDetailPage extends StatelessWidget {
  const RequestDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black.withOpacity(0.6)),
        title: Text(
          "GetiT",
          style: TextStyle(color: Colors.black.withOpacity(0.6)),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: 3,
                itemBuilder: (context, index) {
                  return index == 0
                      ? RequestTile()
                      : Container(
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
                                    backgroundImage: AssetImage(
                                        "assets/Images/praposalHome.png"),
                                  ),
                                  const SizedBox(
                                    width: 7,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                ],
                              ),
                              ExpandableText(
                                "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam lobortis dignissim tortor. Nunc a suscipit libero. Aliquam convallis tellus sit amet rutrum tristique Lorem ipsum dolor sit amet, consectetur adipiscing elit. Lorem ipsum dolor sit amet, consectetur adipiscing elit..",
                                style: TextStyle(fontSize: 14),
                                expandText: "more",
                                collapseText: "show less",
                                maxLines: 1,
                                linkColor: Colors.black.withOpacity(0.3),
                                linkStyle: TextStyle(
                                    decoration: TextDecoration.underline),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 11, bottom: 11),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        width: size.width,
                                        padding: EdgeInsets.all(11),
                                        decoration: BoxDecoration(
                                          color: Color(0xffA6BBDE)
                                              .withOpacity(0.2),
                                          border: Border.all(
                                              color: Color(0xffEAEAEA)),
                                          borderRadius:
                                              BorderRadius.circular(14),
                                        ),
                                        margin: EdgeInsets.only(right: 11),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text("Time:"),
                                            Text("12:30 pm"),
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
                                              submittedIcon: Icon(
                                                  Icons.handshake,
                                                  color: Colors.white),
                                              animationDuration:
                                                  Duration(milliseconds: 170),
                                              height: 50,
                                              sliderButtonIconSize: 17,
                                              sliderButtonIconPadding: 11,
                                              text: "accept",
                                              textStyle: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.white
                                                      .withOpacity(0.7)),
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
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

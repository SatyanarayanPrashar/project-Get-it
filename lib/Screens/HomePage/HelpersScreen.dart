import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:get_it/Screens/insiderScreens/HelperForm.dart';
import 'package:slide_to_act/slide_to_act.dart';

class HelpersScreen extends StatelessWidget {
  const HelpersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return HelperFormPage();
          }));
        },
        backgroundColor: Colors.blue,
        child: Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16),
        child: ListView.builder(
          physics: BouncingScrollPhysics(),
          itemCount: 10,
          itemBuilder: (context, index) => HelperTile(),
        ),
      ),
    );
  }
}

class HelperTile extends StatelessWidget {
  const HelperTile({super.key});

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
          true // if any note attached
              ? Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: ExpandableText(
                    "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam lobortis dignissim tortor. Nunc a suscipit libero. Aliquam convallis tellus sit amet rutrum tristique Lorem ipsum dolor sit amet, consectetur adipiscing elit. Lorem ipsum dolor sit amet, consectetur adipiscing elit..",
                    style: TextStyle(fontSize: 13),
                    prefixText: "Note: ",
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
                        Text("11th December"),
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

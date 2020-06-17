import 'dart:convert';

import 'package:fitness_flutter/EditProfile/editProfileScreen.dart';
import 'package:fitness_flutter/components/daily_tip.dart';
import 'package:fitness_flutter/components/image_card_with_basic_footer.dart';
import 'package:fitness_flutter/components/section.dart';
import 'package:fitness_flutter/components/image_card_with_internal.dart';
import 'package:fitness_flutter/components/user_tip.dart';
import 'package:fitness_flutter/models/exercise.dart';
import 'package:fitness_flutter/pages/activity_detail.dart';
import 'package:fitness_flutter/main.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fitness_flutter/pages/get_videos_search.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Programs extends StatefulWidget {
  @override
  _ProgramsState createState() => _ProgramsState();
}

class _ProgramsState extends State<Programs> {
  Icon cusIcon = Icon(Icons.search);
  Widget cusSearchBar = Text("");
  String name = "";
  String day = "";

  String full_name="";
  var us1;

  Draw draw;

  bool _islogged = false;
  @override
  void initState() {
    draw = new Draw();
    super.initState();
    checkLogged();
  }

  checkLogged() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var userJson = localStorage.getString('user');
    var extJson = localStorage.getString("user_extProfile");
    var hour = DateTime.now().hour;
    if (userJson == null) {
      //print(json.decode(extJson));
      setState(() {
        _islogged = false;
        if (hour < 12) {
          day = 'Good Morning';
        } else if ((hour < 17) && (hour >= 12)) {
          day = 'Good Afternoon';
        } else {
          day = 'Good Evening';
        }
        name = "Guest";
      });
    } else {
      var us = json.decode(userJson);
      var us1 = json.decode(extJson);
      print(us);
      print("-----");
       print(us1);
      //for(var i=0; i<us["detail"])

      setState(() {
        _islogged = true;
        if (hour < 12) {
          day = 'Good Morning';
        } else if ((hour < 17) && (hour >= 12)) {
          day = 'Good Afternoon';
        } else {
          day = 'Good Evening';
        }
        // name = us['detail']['extProfile'];
        if (us['detail']['extProfile']== null) {
          name = us1['extProfile']['firstname'];
          full_name = us1['extProfile']['firstname'] + " " +  us1['extProfile']['lastname'];
        } else {
          name = us['detail']['extProfile']['firstname'];
          full_name = us['detail']['extProfile']['firstname'] + " " + us['detail']['extProfile']['lastname'];
        }
      });
    }
  }

  final List<Exercise> exercises = [
    Exercise(
      image: 'assets/images/image001.jpg',
      title: 'Easy Start',
      time: '5 min',
      difficult: 'Low',
    ),
    Exercise(
      image: 'assets/images/image002.jpg',
      title: 'Medium Start',
      time: '10 min',
      difficult: 'Medium',
    ),
    Exercise(
      image: 'assets/images/image003.jpg',
      title: 'Pro Start',
      time: '25 min',
      difficult: 'High',
    )
  ];

  List<Widget> generateList(BuildContext context) {
    List<Widget> list = [];
    int count = 0;
    exercises.forEach((exercise) {
      Widget element = Container(
        margin: EdgeInsets.only(right: 20.0),
        child: GestureDetector(
          child: ImageCardWithBasicFooter(
            exercise: exercise,
            tag: 'imageHeader$count',
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) {
                  return ActivityDetail(
                    exercise: exercise,
                    tag: 'imageHeader$count',
                  );
                },
              ),
            );
          },
        ),
      );
      list.add(element);
      count++;
    });
    return list;
  }

  Future<bool> _onBackPressed() {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Do you want to exit the App ?"),
              actions: <Widget>[
                FlatButton(
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                    child: Text("Yes")),
                FlatButton(
                    onPressed: () {
                      Navigator.pop(context, false);
                    },
                    child: Text("No")),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        drawer: this.draw.buildDrawer(context, full_name),
        appBar: AppBar(
          title: this.cusSearchBar,
          backgroundColor: Color.fromRGBO(100, 100, 255, 0.7),
          actions: <Widget>[
            !_islogged
                ? Text("")
                : IconButton(
                    icon: cusIcon,
                    onPressed: () {
                      setState(() {
                        if (this.cusIcon.icon == Icons.search) {
                          this.cusIcon = Icon(Icons.cancel);

                          this.cusSearchBar = TextField(
                            autofocus: true,
                            textInputAction: TextInputAction.go,
                            onSubmitted: (String str) {
                              if (str == "") {
                                Fluttertoast.showToast(
                                    msg: "Nothing to search for .. :) ",
                                    toastLength: Toast.LENGTH_SHORT,
                                    // gravity: ToastGravity.,
                                    timeInSecForIosWeb: 2,
                                    backgroundColor:
                                        Color.fromRGBO(100, 100, 255, 0.7),
                                    textColor: Colors.white,
                                    fontSize: 14.0);
                              } else
                                Navigator.push(
                                    context,
                                    new MaterialPageRoute(
                                        builder: (context) => GetVideosSearch(
                                              queryy: str.toString(),
                                            )));
                            },
                            style: TextStyle(
                                fontSize: 18.0,
                                color: Color.fromRGBO(100, 100, 255, 0.7)),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              hintText: 'Search here..',
                              contentPadding: const EdgeInsets.only(
                                  left: 14.0, bottom: 4.0, top: 4.0),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(15.7),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(15.7),
                              ),
                            ),
                          );
                        } else {
                          this.cusIcon = Icon(Icons.search);
                          this.cusSearchBar = Text("");
                        }
                      });
                    })
          ],
        ),
        //drawer: Drawer(),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: SafeArea(
            child: Container(
              padding: EdgeInsets.only(top: 20.0),
              child: Column(
                children: <Widget>[
                  InkWell(
                    child: Text(
                      "$day, $name",
                      style: TextStyle(
                          fontSize: 18,
                          color: Color.fromRGBO(100, 100, 255, 0.7),
                          fontWeight: FontWeight.bold),
                    ),
                    onTap: () {
                      Navigator.push(context,
                          new MaterialPageRoute(builder: (context) => Edit()));
                    },
                  ),
                  Divider(),
                  //MainCardPrograms(), // MainCard
                  Section(
                    title: 'Fat burning',
                    horizontalList: this.generateList(context),
                  ),
                  Section(
                    title: 'Abs Generating',
                    horizontalList: <Widget>[
                      ImageCardWithInternal(
                        image: 'assets/images/image004.jpg',
                        title: 'Core \nWorkout',
                        duration: '7 min',
                      ),
                      ImageCardWithInternal(
                        image: 'assets/images/image004.jpg',
                        title: 'Core \nWorkout',
                        duration: '7 min',
                      ),
                      ImageCardWithInternal(
                        image: 'assets/images/image004.jpg',
                        title: 'Core \nWorkout',
                        duration: '7 min',
                      ),
                    ],
                  ),

                  Container(
                    margin: EdgeInsets.only(top: 50.0),
                    padding: EdgeInsets.only(top: 10.0, bottom: 40.0),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                    ),
                    child: Column(
                      children: <Widget>[
                        Section(
                          title: 'Daily Tips',
                          horizontalList: <Widget>[
                            UserTip(
                              image: 'assets/images/image010.jpg',
                              name: 'User Img',
                            ),
                            UserTip(
                              image: 'assets/images/image010.jpg',
                              name: 'User Img',
                            ),
                            UserTip(
                              image: 'assets/images/image010.jpg',
                              name: 'User Img',
                            ),
                            UserTip(
                              image: 'assets/images/image010.jpg',
                              name: 'User Img',
                            ),
                          ],
                        ),
                        Section(
                          horizontalList: <Widget>[
                            DailyTip(),
                            DailyTip(),
                            DailyTip(),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

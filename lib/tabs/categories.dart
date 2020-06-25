import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fitness_flutter/Login/loginScreen.dart';
import 'package:fitness_flutter/api/api.dart';
import 'package:fitness_flutter/pages/get_videos.dart';
import 'package:fitness_flutter/Classes/videos.dart';
import 'package:fitness_flutter/SignUp/premium.dart';

class Categories extends StatefulWidget {
  @override
  _CategoriesState createState() => _CategoriesState();
}

List uss = [];
var ispremium;

class _CategoriesState extends State<Categories> {
  bool _islogged = false;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  checkLogged() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var userJson = localStorage.getString('user');
    if (userJson == null) {
      scaffoldKey.currentState.showSnackBar(new SnackBar(
          backgroundColor: Colors.white,
          content: Text(
            "Not logged in..",
            style: TextStyle(
              color: Colors.red,
              fontSize: 16,
            ),
          )));
      Navigator.push(
          context, new MaterialPageRoute(builder: (context) => LogIn()));
    } else {
      _islogged = true;
      var user = json.decode(userJson);
      uss.add(user);
      ispremium = uss[0]['detail']['ispremium'];
      // print(ispremium);
    }
  }

  static Future<List<Videos>> getVideos() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var userJson = localStorage.getString('user');
    var user = json.decode(userJson);
    var data = {
      'key': user['detail']['apibld_key'],
      'requestType': 'getVideoCategories',
    };
  }

  void initState() {
    super.initState();
    checkLogged();
    getVideosCategories();
  }

  printType(String typee) {
    if (typee == 'free') {
      return false;
    } else {
      return true;
    }
  }

  printPre(String typee) {
    return "Pre";
  }

  var categories = new List<Category>();

  getVideosCategories() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var userJson = localStorage.getString('user');
    if (userJson == null) {
      scaffoldKey.currentState.showSnackBar(new SnackBar(
          backgroundColor: Colors.white,
          content: Text(
            "Not logged in..",
            style: TextStyle(
              color: Colors.red,
              fontSize: 16,
            ),
          )));
      Navigator.push(
          context, new MaterialPageRoute(builder: (context) => LogIn()));
    } else {
      _islogged = true;
      var user = json.decode(userJson);
      var data = {
        'key': user['detail']['apibld_key'],
        'requestType': 'getVideoCategories',
      };
      var res = await CallApi().postData1(data);
      // if(res.body.isNotEmpty) {}
      var body = json.decode(res.body);
      //print(body['detail']);
      CallApi().postData2(data).then((response) {
        if (mounted) {
          setState(() {
            //    print(response.body);
            var res = json.decode(response.body);
            //    print(res["detail"]);
            var listt = json.encode(res['detail']);
            Iterable list = json.decode(listt);
            categories = list.map((model) => Category.fromJson(model)).toList();
          });
        }
      });
    }
  }


  Future<bool> _onBackPressed() {
    // return showDialog(
    //     context: context,
    //     builder: (context) => AlertDialog(
    //           title: Text("Do you want to exit the App ?"),
    //           actions: <Widget>[
    //             FlatButton(
    //                 onPressed: () {
    //                   Navigator.pop(context, true);
    //                 },
    //                 child: Text("Yes")),
    //             FlatButton(
    //                 onPressed: () {
    //                   Navigator.pop(context, false);
    //                 },
    //                 child: Text("No")),
    //           ],
    //         ));
    Navigator.pushNamed(context, '/programs');
  }
  @override
  Widget build(BuildContext context) {

   return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(100, 100, 255, 0.7),
      ),
      //drawer: Drawer(),
      backgroundColor: Colors.white,
      body: GridView.count(
          crossAxisCount: 2,
          children: List.generate(categories.length, (index) {
            if (categories.length == 0) {
              return Container(
                  child: Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.cyanAccent,
                  valueColor: new AlwaysStoppedAnimation<Color>(Colors.red),
                ),
              ));
            } else
              return Container(
                  padding: EdgeInsets.all(10),
                  child: Stack(
                    children: <Widget>[
                      GestureDetector(
                        child: CachedNetworkImage(
                          imageUrl: categories[index].imageurl,
                          //imageUrl: "https://www.micheldonze.com/wp-content/uploads/2019/01/fitness.jpg",
                          imageBuilder: (context, imageProvider) => Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: const Color.fromRGBO(100, 100, 255, 0.7),
                              image: DecorationImage(
                                colorFilter: new ColorFilter.mode(
                                    Colors.black.withOpacity(0.7),
                                    BlendMode.dstATop),
                                image: imageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          progressIndicatorBuilder:
                              (context, url, downloadProgress) =>
                                  CircularProgressIndicator(
                                      value: downloadProgress.progress),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        ),
                        onTap: () {
                          if ((ispremium == "0") &&
                              (categories[index].type == "premium")) {
                            print("premium");
                            Navigator.push(
                                context,
                                new MaterialPageRoute(
                                    builder: (context) => Premium()));
                          } else {
                            Navigator.push(
                                context,
                                new MaterialPageRoute(
                                    builder: (context) => GetVideos(
                                          cat_idd: categories[index].id,
                                          namee: categories[index].name,
                                        )));
                          }
                        },
                      ),
                      GestureDetector(
                        onTap: () {
                          if ((ispremium == "0") &&
                              (categories[index].type == "premium")) {
                            print("premium");
                            Navigator.push(
                                context,
                                new MaterialPageRoute(
                                    builder: (context) => Premium()));
                          } else {
                            Navigator.push(
                                context,
                                new MaterialPageRoute(
                                    builder: (context) => GetVideos(
                                          cat_idd: categories[index].id,
                                          namee: categories[index].name,
                                        )));
                          }
                        },
                        child: Center(
                          child: Text(categories[index].name,
                              style: TextStyle(
                                  shadows: <Shadow>[
                                    Shadow(
                                      offset: Offset(1.0, 1.0),
                                      blurRadius: 8.0,
                                      color: Color.fromARGB(255, 0, 0, 0),
                                    ),
                                    Shadow(
                                      offset: Offset(1.0, 1.0),
                                      blurRadius: 6.0,
                                      color: Colors.blueGrey,
                                    ),
                                  ],
                                  fontWeight: FontWeight.bold,
                                  fontSize: 26.0,
                                  color: Colors.white)),
                        ),
                      ),
                      categories[index].type == "premium"
                          ? Stack(
                              children: <Widget>[
                                Positioned(
                                  left: 1.0,
                                  top: 1.0,
                                  child: Icon(
                                    Icons.star,
                                    color: Colors.yellow[700],
                                    size: 26,
                                  ),
                                ),
                                Icon(
                                  Icons.star,
                                  color: Colors.yellow[500],
                                  size: 26,
                                ),
                              ],
                            )
                          : new Positioned(
                              left: 0.0,
                              top: 0.0,
                              child: Text(""),
                            )
                    ],
                  ));
          })),
    ),
    );
  }
}

class Category {
  String id;
  String name;
  String description;
  String type;
  String imageurl;

  Category(String id, String name, String description, String type,
      String imageurl) {
    this.id = id;
    this.name = name;
    this.description = description;
    this.type = type;
    this.imageurl = imageurl;
  }

  Category.fromJson(Map json)
      : id = json['id'],
        name = json['name'],
        description = json['description'],
        type = json['type'],
        imageurl = json['imageurl'];

  Map toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'type': type,
      'imageurl': imageurl
    };
  }
}

class ScaleRoute extends PageRouteBuilder {
  final Widget page;
  ScaleRoute({this.page})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              ScaleTransition(
            scale: Tween<double>(
              begin: 0.0,
              end: 1.0,
            ).animate(
              CurvedAnimation(
                parent: animation,
                curve: Curves.fastOutSlowIn,
              ),
            ),
            child: child,
          ),
        );
}

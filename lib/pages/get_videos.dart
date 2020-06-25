import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fitness_flutter/api/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fitness_flutter/pages/video_player_class.dart';
import 'package:fitness_flutter/Classes/videos.dart';
import 'package:fitness_flutter/SignUp/premium.dart';
import 'package:shimmer/shimmer.dart';

class GetVideos extends StatefulWidget {
  String cat_idd;
  String namee;

  GetVideos({
    @required this.cat_idd,
    @required this.namee,
  });

  @override
  _getVideosState createState() => _getVideosState();
}

class _getVideosState extends State<GetVideos> {
  MyHomePage createState() => MyHomePage(
        cat_id: this.widget.cat_idd,
        name: this.widget.namee,
      );

  List uss = [];
  var ispremium;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MyHomePage(cat_id: this.widget.cat_idd, name: this.widget.namee),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String cat_id;
  final String name;

  MyHomePage({
    @required this.cat_id,
    @required this.name,
  });

  @override
  _MyHomePageState createState() =>
      _MyHomePageState(cat: this.cat_id, nam: this.name);
}

class _MyHomePageState extends State<MyHomePage> {
  final String cat;
  final String nam;

  _MyHomePageState({
    @required this.cat,
    @required this.nam,
  });
  List uss = [];
  var widthh;
  var heightt;
  var ispremium;
  var globalContext;
  String appbar = "";
  String token = "";
  @override
  void initState() {
    appbar = this.nam;
    super.initState();
    // getVideos();
    checkPremium();
  }

  Future<String> videoInfoWidth(var v_id) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var userJson = localStorage.getString('user');
    var user = json.decode(userJson);

    // logout from the server ...
    // print(user['detail']['apibld_key']);
    var data = {
      "key": user['detail']['apibld_key'],
      "requestType": "vinfo",
      "id": v_id,
    };
    var res = await CallApi().postData1(data);
    var body = json.decode(res.body);
    //print(body);
    setState(() {
      return body['detail']['width'];
    });
  }

  Future<String> videoInfoHeight(var v_id) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var userJson = localStorage.getString('user');
    var user = json.decode(userJson);

    // logout from the server ...
    // print(user['detail']['apibld_key']);
    var data = {
      "key": user['detail']['apibld_key'],
      "requestType": "vinfo",
      "id": v_id,
    };
    var res = await CallApi().postData1(data);
    var body = json.decode(res.body);
    print(body);
    setState(() {
      return body['detail']['height'];
    });
  }

  checkPremium() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var userJson = localStorage.getString('user');
    var user = json.decode(userJson);
    uss.add(user);
    ispremium = uss[0]['detail']['ispremium'];
    print(ispremium);
  }

  Future<List<Videos>> getVideos() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var userJson = localStorage.getString('user');
    var user = json.decode(userJson);

    // logout from the server ...
    // print(user['detail']['apibld_key']);
    var data = {
      "key": user['detail']['apibld_key'],
      "requestType": "getVideoDetails",
      "categoryid": this.cat,
    };
    var res = await CallApi().postData1(data);
    var body = json.decode(res.body);
    print(body);
    List<Videos> v = [];
    if (body['detail'] == null) {
      return v;
    } else {
      for (var i in body['detail']) {
        var data1 = {
          "key": user['detail']['apibld_key'],
          "requestType": "vinfo",
          "id": i['id']
        };
        var res1 = await CallApi().postData1(data1);
        var body1 = json.decode(res1.body);
        var filename =
            i['filename'] + "&api_key=" + user['detail']['apibld_key'];
        var poster = i['poster'] + "&api_key=" + user['detail']['apibld_key'];

        Videos video = Videos(
            i['id'],
            i['title'],
            i['description'],
            i['createdon'],
            filename,
            i['duration'],
            i['type'],
            i['tags'],
            poster,
            body1['detail']['height'],
            body1['detail']['width']
            );
          // print(video.height);
        v.add(video);
      }
    }
    return v;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    globalContext = context;
    return Scaffold(
      appBar: AppBar(
        title: Text("Videos of $appbar"),
        backgroundColor: Colors.red,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context, false);
          },
        ),
      ),
      resizeToAvoidBottomPadding: false,
      body: Container(
        child: FutureBuilder(
            future: getVideos(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.data == null) {
                return Container(
                  child: Center(
                    child: Shimmer.fromColors(
                        baseColor: CupertinoColors.activeBlue,
                        highlightColor: CupertinoColors.activeOrange,
                        child: CupertinoActivityIndicator()),
                  ),
                );
              } else if (snapshot.data.length == 0) {
                return Container(
                    child: Center(
                  child: Text("Nothing found ... :("),
                ));
              } else {
                return ListView.separated(
                  separatorBuilder: (BuildContext context, int index) =>
                      Divider(),
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    print(snapshot.data[index].poster);
                    return Padding(
                        padding: EdgeInsets.only(top: 30),
                        child: InkWell(
                          child: ListTile(
                            leading: ConstrainedBox(
                              constraints: BoxConstraints(),
                              child: Stack(
                                children: <Widget>[
                                  Image.network(
                                    snapshot.data[index].poster,
                                    height: 140,
                                    width: 120,
                                    fit: BoxFit.fill,
                                  ),
                                  snapshot.data[index].type == "premium"
                                      ? Stack(
                                          children: <Widget>[
                                            Positioned(
                                              left: 1.0,
                                              top: 1.0,
                                              child: Icon(
                                                Icons.star,
                                                color: Colors.yellow[700],
                                                size: 16,
                                              ),
                                            ),
                                            Icon(
                                              Icons.star,
                                              color: Colors.yellow[500],
                                              size: 16,
                                            ),
                                          ],
                                        )
                                      : new Positioned(
                                          left: 0.0,
                                          top: 0.0,
                                          child: Text(""),
                                        )
                                ],
                              ),
                            ),
                            title: Text(snapshot.data[index].title),
                            subtitle: Text(snapshot.data[index].description +
                                "\n" +
                                snapshot.data[index].duration +
                                " s"),
                          ),
                          onTap: () {
                            if ((ispremium == "0") &&
                                (snapshot.data[index].type == "premium")) {
                              Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                      builder: (context) => Premium()));
                            } else {
                              //videoInfo(snapshot.data[index].id);
                              // print(widthh);
                             // print(snapshot.data[index].width+" is the width");
                              setState(() {
                                videoInfoHeight(snapshot.data[index].id)
                                    .then((String result) {
                                  setState(() {
                                    print(result);
                                    heightt = result;
                                  });
                                });
                                videoInfoWidth(snapshot.data[index].id)
                                    .then((String result1) {
                                  setState(() {
                                    widthh = result1;
                                  });
                                });
                                print(heightt);
                              });
                              Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                    builder: (context) => VidVid(
                                      urll: snapshot.data[index].filename,
                                      titlee: snapshot.data[index].title,
                                      descc: snapshot.data[index].description,
                                      heightt: snapshot.data[index].height,
                                      widthh: snapshot.data[index].width,
                                    ),
                                  ));
                            }
                          },
                        ));
                  },
                );
              }
            }),
      ),
    );
  }
}

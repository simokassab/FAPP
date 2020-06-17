import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fitness_flutter/api/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fitness_flutter/pages/video_player_class.dart';
import 'package:fitness_flutter/Classes/videos.dart';

class GetVideosSearch extends StatefulWidget {
  String queryy;

  GetVideosSearch({
    @required this.queryy,
  });

  @override
  _getVideosState createState() => _getVideosState();
}

class _getVideosState extends State<GetVideosSearch> {
  MyHomePage createState() => MyHomePage(
        query: this.widget.queryy,
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MyHomePage(query: this.widget.queryy),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String query;

  MyHomePage({
    @required this.query,
  });

  @override
  _MyHomePageState createState() => _MyHomePageState(quer: this.query);
}

class _MyHomePageState extends State<MyHomePage> {
  final String quer;

  _MyHomePageState({
    @required this.quer,
  });
  var globalContext;
  String appbar = "";
  String token = "";
  @override
  void initState() {
    appbar = this.quer;
    super.initState();
  }

  Future<List<Videos>> getVideos() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var userJson = localStorage.getString('user');
    var user = json.decode(userJson);
    // logout from the server ...
    print(user['detail']['apibld_key']);
    var data = {
      "key": user['detail']['apibld_key'],
      "requestType": "searchVideo",
      "search": this.quer,
    };
    var res = await CallApi().postData1(data);
    var body = json.decode(res.body);
    print(body);
    List<Videos> v = [];
    if (body['detail'] == null) {
      return v;
    } else {
      for (var i in body['detail']) {
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
            poster);
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
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.cyanAccent,
                    valueColor: new AlwaysStoppedAnimation<Color>(Colors.red),
                  ),
                ));
              } else if (snapshot.data.length == 0) {
                return Container(
                    child: Center(
                  child: Text  ("Nothing found ... :("),
                ));
              } else {
                return ListView.separated(
                  separatorBuilder: (BuildContext context, int index) =>
                      Divider(),
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                        padding: EdgeInsets.only(top: 30),
                        child: InkWell(
                          child: ListTile(
                            leading: ConstrainedBox(
                              constraints: BoxConstraints(
                                minWidth: 104,
                                minHeight: 94,
                                maxWidth: 104,
                                maxHeight: 94,
                              ),
                              child: Image.network(snapshot.data[index].poster,
                                  fit: BoxFit.cover),
                            ),
                            title: Text(snapshot.data[index].title),
                            subtitle: Text(snapshot.data[index].description +
                                "\n" +
                                snapshot.data[index].duration +
                                " s"),
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                new MaterialPageRoute(
                                  builder: (context) => VidVid(
                                    urll: snapshot.data[index].filename,
                                    titlee: snapshot.data[index].title,
                                    descc: snapshot.data[index].description,
                                  ),
                                ));
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

import 'dart:convert';

import 'package:fitness_flutter/api/api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class VidVid extends StatefulWidget {
  String titlee;
  String urll;
  String descc;
  String heightt;
  String widthh;

  VidVid({
    @required this.titlee,
    @required this.urll,
    @required this.descc,
    @required this.heightt,
    @required this.widthh,
  });

  @override
  _VidVidState createState() => _VidVidState();
}

class _VidVidState extends State<VidVid> {
  MyHomePage createState() => MyHomePage(
        title: this.widget.titlee,
        url: this.widget.urll,
        desc: this.widget.descc,
        heigh: this.widget.heightt,
        widh: this.widget.widthh,
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MyHomePage(
        title: this.widget.titlee,
        url: this.widget.urll,
        desc: this.widget.descc,
        heigh: this.widget.heightt,
        widh: this.widget.widthh,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;
  final String url;
  final String desc;
  final String heigh;
  final String widh;

  MyHomePage({
    @required this.title,
    @required this.url,
    @required this.desc,
    @required this.heigh,
    @required this.widh,
  });

  @override
  _MyHomePageState createState() =>
      _MyHomePageState(tit: this.title, ur: this.url, des: this.desc, heig: this.heigh, wid: this.widh );
}

class _MyHomePageState extends State<MyHomePage> {
  final String tit;
  final String heig;
  final String wid;
  final String ur;
 TargetPlatform _platform;
  final String des;
  VideoPlayerController _videoPlayerController;
  ChewieController _chewieController;

  _MyHomePageState({
    @required this.tit,
    @required this.ur,
    @required this.des,
    @required this.heig,
    @required this.wid,
  });
  var widthh;
  var heightt;
  var globalContext;

  @override
  void initState() {
    super.initState();
    _videoPlayerController = VideoPlayerController.network(this.ur);
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      aspectRatio: 3 / 2,
      autoPlay: false,
      showControls: true,
     cupertinoProgressColors: ChewieProgressColors(
     ),
      allowMuting: true,
      isLive: false,
      showControlsOnInitialize: true,
      // materialProgressColors: ChewieProgressColors(
      //   playedColor: Colors.red,
      //   handleColor: Colors.blue,
      //   backgroundColor: Colors.white,
      //   bufferedColor: Colors.red[100],
      // ),
      placeholder: Container(
        color: Colors.grey,
      ),
      autoInitialize: true,
    );
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top]);
  }

  @override
  void dispose() {
    SystemChrome.restoreSystemUIOverlays();
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    globalContext = context;
    return Scaffold(
    
      appBar: AppBar(
        title: Text(tit),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () async {
            Navigator.pop(context);
          },
        ),
      ),
      resizeToAvoidBottomPadding: false,
      body: Column(
        children: <Widget>[
          Container(
            child: IconButton(
                color: Colors.red, icon: Icon(Icons.favorite), onPressed: null),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: Center(
              child: Chewie(
                controller: _chewieController,
              ),
            ),
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: FlatButton(
                  onPressed: () {
                    setState(() {
                      
                      _chewieController.dispose();
                      _videoPlayerController.pause();
                      _videoPlayerController.seekTo(Duration(seconds: 0));
                      _chewieController = ChewieController(
                        videoPlayerController: _videoPlayerController,
                        aspectRatio: 3 / 2,
                        autoPlay: true,
                        looping: true,
                        showControls: true,
                      );
                    });
                  },
                  child: null,
                ),
              ),
            ],
          ),
          Container(
            child: Text(
              this.des.toString(),
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
          Padding(padding: EdgeInsets.only(top: 30)),
          Center(
            child: Divider(
              color: Color.fromRGBO(100, 140, 255, 1.0),
              height: 1,
              thickness: 2,
              endIndent: 0,
            ),
          ),
          Column(
            children: <Widget>[],
          )
        ],
      ),
    );
  }
}

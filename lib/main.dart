import 'package:fitness_flutter/tabs/tabs.dart';
import 'package:fitness_flutter/SignUp/register.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fitness_flutter/pages/about_page.dart';
import 'package:fitness_flutter/pages/settings_page.dart';
import 'package:fitness_flutter/EditProfile/editProfileScreen.dart';
import 'dart:convert';

import 'package:fitness_flutter/api/api.dart';

void main() => runApp(MyApp1());

class MyApp1 extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp1> {
  bool _islogged = true;

  

  checkLogged() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var userJson = localStorage.getString('user');
    if (userJson == null) {
      setState(() {
        _islogged = false;
      });
    } else {
      setState(() {
        _islogged = true;
      });
    }
    print(_islogged);
  }

  @override
  void initState() {
    super.initState();
    checkLogged();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
       theme: ThemeData.light().copyWith(
        
        platform: TargetPlatform.iOS,
      ),
      routes: {
        '/programs': (context) => Tabs(),
      },
     // theme: ThemeData(fontFamily: 'Geometria'),
      home: Scaffold(
        // drawer: _buildDrawer(context),
        //  drawer: _islogged ? _buildDrawer(context): null,
        body: _islogged ? Tabs() : Register(),
      ),
    );
  }
}

class Draw {
  bool _isloading = false;
  Drawer buildDrawer(context, String full_name) {
    
    return Drawer(
      child: new ListView(
        children: <Widget>[
          new DrawerHeader(
            child: new Container(
                child: new Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                CircleAvatar(
                    minRadius: 24,
                    maxRadius: 50,
                    backgroundImage: NetworkImage(
                        'https://media-exp1.licdn.com/dms/image/C4D03AQGKmNMiuehfMA/profile-displayphoto-shrink_200_200/0?e=1597881600&v=beta&t=QkNwFAdNu2WV8q9lEkBSKCcHvpTUr-iPHx93dKI5Xz0')),
                new Text(
                  full_name,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            )),
          ),
          new ListTile(
            leading: Icon(Icons.person),
            title: Text("Profile"),
            onTap: () {
              Navigator.push(
                  context, new MaterialPageRoute(builder: (context) => Edit()));
            },
          ),
          new ListTile(
            leading: Icon(Icons.info),
            title: Text("About"),
            onTap: () {
              Navigator.push(
                  context, new MaterialPageRoute(builder: (context) => AboutPage()));
            },
          ),
          new ListTile(
            leading: Icon(Icons.notifications),
            title: Text("Notifications"),
            
          ),
          new ListTile(
            leading: Icon(Icons.settings),
            title: Text("Settings"),
            onTap: () {
              Navigator.push(
                  context, new MaterialPageRoute(builder: (context) => SettingsPage()));
            },
          ),
          new Divider(
            color: Colors.black,
            indent: 26.0,
          ),
          new ListTile(
            leading: Icon(Icons.exit_to_app),
            title: _isloading ? Text("Logging out..."): Text("Logout"),
            onTap: (){
              logout(context);
            }
          ),
        ],
      ),
    );
  }
   void logout(context) async {
     SharedPreferences localStorage = await SharedPreferences.getInstance();
      var userJson = localStorage.getString('user');
      var user =json.decode(userJson);
    // logout from the server ...
    print(user['detail']['apibld_key']);
    var data ={
      "key" : user['detail']['apibld_key'],
      "requestType" : "logout"
      };
    var res = await CallApi().postData1(data);
    
    var body = json.decode(res.body);
    print(body);
    if (body['result']=='success') {
    //setState(()  {
      _isloading = true;
   // });
          localStorage.remove('user');
      Navigator.push(
          context, new MaterialPageRoute(builder: (context) => MyApp1()));
    }
    else {
      print("Error");
    }
  }
}

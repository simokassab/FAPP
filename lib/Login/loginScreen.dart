import 'dart:convert';
import 'package:fitness_flutter/main.dart';
import 'package:flutter/material.dart';
import 'package:fitness_flutter/SignUp/signUpScreen.dart';
import 'package:fitness_flutter/api/api.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
//import 'package:fitness_flutter/EditProfile/editProfileScreen.dart';

//import 'package:http/http.dart' as http;
//import 'dart:convert' as JSON;

class LogIn extends StatefulWidget {
  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isLoading = false;
  //bool _isLoadingFacebook = false;

  TextEditingController mailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  ScaffoldState scaffoldState;
  Map userProfile;
  final facebookLogin = FacebookLogin();

  // _loginWithFacebook() async {
  //   //_isLoadingFacebook = true;
  //   final result = await facebookLogin.logInWithReadPermissions(['email']);
  //   switch (result.status) {
  //     case FacebookLoginStatus.loggedIn:
  //       final token = result.accessToken.token;
  //       SharedPreferences localStorage = await SharedPreferences.getInstance();
  //       localStorage.setString('token', token);
  //       final graphResponse = await http.get(
  //           'https://graph.facebook.com/v2.12/me?fields=name,picture,email&access_token=${token}');
  //       final profile = JSON.jsonDecode(graphResponse.body);
  //       print(profile);
  //       print(profile['email']);
  //       var data = {
  //         'firstName': profile['name'],
  //         'lastName': profile['name'],
  //         'email': profile['email'],
  //         'password': 'fsfsdfsdf',
  //         'phone': '3424324',
  //       };
  //       print('Loading...');
  //       var res = await CallApi().postData(data, 'register');
  //       var body = json.decode(res.body);
  //       print(body);
  //       if (body['success']) {
  //         SharedPreferences localStorage =
  //             await SharedPreferences.getInstance();
  //         localStorage.setString('token', body['token']);
  //         localStorage.setString('user', json.encode(body['user']));
  //         Navigator.push(
  //             context, new MaterialPageRoute(builder: (context) => Edit()));
  //       }
  //       setState(() {
  //         //_isLoadingFacebook = false;
  //         userProfile = profile;
  //       });

  //       break;

  //     case FacebookLoginStatus.cancelledByUser:
  //       break;
  //     case FacebookLoginStatus.error:
  //       break;
  //   }
  // }

  // _logoutFacebook() {
  //   facebookLogin.logOut();
  //   setState(() {
  //     _isLoggedIn = false;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: Container(
        child: Stack(
          children: <Widget>[
            ///////////  background///////////
            new Container(
              decoration: new BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: [0.0, 0.4, 0.9],
                  colors: [
                    Color.fromRGBO(100, 140, 255, 1.0),
                    Color.fromRGBO(100, 100, 255, 1.0),
                    Color.fromRGBO(100, 70, 255, 1.0),
                  ],
                ),
              ),
            ),

            Positioned(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Card(
                      elevation: 4.0,
                      color: Colors.white,
                      margin: EdgeInsets.only(left: 20, right: 20),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            /////////////  Email//////////////

                            TextField(
                              style: TextStyle(color: Color(0xFF000000)),
                              controller: mailController,
                              cursorColor: Color(0xFF9b9b9b),
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.account_circle,
                                  color: Colors.grey,
                                ),
                                hintText: "Email",
                                hintStyle: TextStyle(
                                    color: Color(0xFF9b9b9b),
                                    fontSize: 15,
                                    fontWeight: FontWeight.normal),
                              ),
                            ),

                            /////////////// password////////////////////

                            TextField(
                              style: TextStyle(color: Color(0xFF000000)),
                              cursorColor: Color(0xFF9b9b9b),
                              controller: passwordController,
                              keyboardType: TextInputType.text,
                              obscureText: true,
                              decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.vpn_key,
                                  color: Colors.grey,
                                ),
                                hintText: "Password",
                                hintStyle: TextStyle(
                                    color: Color(0xFF9b9b9b),
                                    fontSize: 15,
                                    fontWeight: FontWeight.normal),
                              ),
                            ),
                            /////////////  LogIn Botton///////////////////
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: FlatButton(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      top: 8, bottom: 8, left: 10, right: 10),
                                  child: Text(
                                    _isLoading ? 'Loging...' : 'Login',
                                    textDirection: TextDirection.ltr,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15.0,
                                      decoration: TextDecoration.none,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ),
                                color: Color.fromRGBO(100, 140, 255, 1.0),
                                disabledColor: Colors.grey,
                                shape: new RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(20.0)),
                                onPressed: _isLoading ? null : _login,
                              ),
                            ),
                            Center(
                              child: FacebookSignInButton(onPressed: () {
                               // _loginWithFacebook();
                              }),
                            ),
                          ],
                        ),
                      ),
                    ),

                    ////////////   new account///////////////
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              new MaterialPageRoute(
                                  builder: (context) => SignUp()));
                        },
                        child: Text(
                          'Create new Account',
                          textDirection: TextDirection.ltr,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15.0,
                            decoration: TextDecoration.none,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              new MaterialPageRoute(
                                  builder: (context) => MyApp1()));
                        },
                        child: Text(
                          'Home',
                          textDirection: TextDirection.ltr,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15.0,
                            decoration: TextDecoration.none,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _login() async {
    setState(() {
      _isLoading = true;
    });

    var data = {
      'key': 'ZKANP-MMKBR-Y5ECF-63589-8CCC',
      'requestType': 'login',
      'email': mailController.text,
      'password': passwordController.text
    };

    var res = await CallApi().postData1(data);
    var body = json.decode(res.body);
    print(body);
    if (body['result'] == "success") {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      //localStorage.setString('token', body['token']);
      localStorage.setString('user', json.encode(body));
      Navigator.push(context, ScaleRoute(page: MyApp1()));

      Fluttertoast.showToast(
          msg: "Logged in ... ",
          toastLength: Toast.LENGTH_SHORT,
          // gravity: ToastGravity.,
          timeInSecForIosWeb: 2,
          backgroundColor: Color.fromRGBO(100, 100, 255, 0.7),
          textColor: Colors.white,
          fontSize: 14.0);
    } else {
      //var scaffoldKey = new GlobalKey<ScaffoldState>();
      Fluttertoast.showToast(
          msg: "Login Failed.. please check .. ",
          toastLength: Toast.LENGTH_SHORT,
          // gravity: ToastGravity.,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 14.0);
      setState(() {
        _isLoading = false;
      });
    }
    setState(() {
      _isLoading = false;
    });
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

import 'dart:convert';

import 'package:fitness_flutter/EditProfile/editProfileScreen.dart';
import 'package:flutter/material.dart';
import 'package:fitness_flutter/Login/loginScreen.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fitness_flutter/SignUp/secondstep.dart';
import 'package:fitness_flutter/api/api.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as JSON;
import 'package:getflutter/getflutter.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController userNAmeController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController mailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  bool _isLoading = false;
  bool _isLoadingFacebook = false;
  bool _isLoggedIn = false;
  bool _failuser = false;
  Map userProfile;
  final facebookLogin = FacebookLogin();

  _loginWithFacebook() async {
    _isLoadingFacebook = true;
    final result = await facebookLogin.logInWithReadPermissions(['email']);
    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final token = result.accessToken.token;
        SharedPreferences localStorage = await SharedPreferences.getInstance();
        localStorage.setString('token', token);
        final graphResponse = await http.get(
            'https://graph.facebook.com/v2.12/me?fields=name,picture,email&access_token=${token}');
        final profile = JSON.jsonDecode(graphResponse.body);
        print(profile);
        print(profile['email']);
        var data = {
          'firstName': profile['name'],
          'lastName': profile['name'],
          'email': profile['email'],
          'password': 'fsfsdfsdf',
          'phone': '3424324',
        };
        print('Loading...');
        var res = await CallApi().postData(data, 'register');
        var body = json.decode(res.body);
        print(body);
        if (body['success']) {
          SharedPreferences localStorage =
              await SharedPreferences.getInstance();
          localStorage.setString('token', body['token']);
          localStorage.setString('user', json.encode(body['user']));
          Navigator.push(
              context, new MaterialPageRoute(builder: (context) => Edit()));
        }
        setState(() {
          _isLoadingFacebook = false;
          userProfile = profile;
          _isLoggedIn = true;
        });

        break;

      case FacebookLoginStatus.cancelledByUser:
        setState(() => _isLoggedIn = false);
        break;
      case FacebookLoginStatus.error:
        setState(() => _isLoggedIn = false);
        break;
    }
  }

  _logoutFacebook() {
    facebookLogin.logOut();
    setState(() {
      _isLoggedIn = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    const padding = 25.0;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        child: Stack(
          children: <Widget>[
            /////////////  background/////////////
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

            Container(
              child: Padding(
                padding: const EdgeInsets.all(1.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Card(
                      elevation: 6.0,
                      color: Colors.white,
                      margin: EdgeInsets.only(left: 10, right: 10, top: 0),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            /////////////// name////////////
                            TextField(
                              autofocus: false,
                              style: TextStyle(color: Color(0xFF000000)),
                              controller: userNAmeController,
                              cursorColor: Color(0xFF9b9b9b),
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.account_circle,
                                  color: Colors.grey,
                                ),
                                contentPadding: const EdgeInsets.all(10.0),
                                hintText: "UserName",
                                errorText:
                                    _failuser ? 'User already in use' : null,
                                hintStyle: TextStyle(
                                    color: Color(0xFF9b9b9b),
                                    fontSize: 15,
                                    fontWeight: FontWeight.normal),
                              ),
                            ),
                            TextField(
                              style: TextStyle(color: Color(0xFF000000)),
                              controller: firstNameController,
                              cursorColor: Color(0xFF9b9b9b),
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.all(10.0),
                                prefixIcon: Icon(
                                  Icons.account_circle,
                                  color: Colors.grey,
                                ),
                                hintText: "Firstname",
                                hintStyle: TextStyle(
                                    color: Color(0xFF9b9b9b),
                                    fontSize: 15,
                                    fontWeight: FontWeight.normal),
                              ),
                            ),
                            TextField(
                              style: TextStyle(color: Color(0xFF000000)),
                              controller: lastNameController,
                              cursorColor: Color(0xFF9b9b9b),
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.all(10.0),
                                prefixIcon: Icon(
                                  Icons.account_circle,
                                  color: Colors.grey,
                                ),
                                hintText: "Lastname",
                                hintStyle: TextStyle(
                                    color: Color(0xFF9b9b9b),
                                    fontSize: 15,
                                    fontWeight: FontWeight.normal),
                              ),
                            ),

                            /////////////// Email ////////////

                            TextField(
                              style: TextStyle(color: Color(0xFF000000)),
                              controller: mailController,
                              cursorColor: Color(0xFF9b9b9b),
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.all(10.0),
                                prefixIcon: Icon(
                                  Icons.mail,
                                  color: Colors.grey,
                                ),
                                hintText: "Email ",
                                hintStyle: TextStyle(
                                    color: Color(0xFF9b9b9b),
                                    fontSize: 15,
                                    fontWeight: FontWeight.normal),
                              ),
                            ),

                            /////////////// password ////////////

                            TextField(
                              style: TextStyle(color: Color(0xFF000000)),
                              cursorColor: Color(0xFF9b9b9b),
                              controller: passwordController,
                              keyboardType: TextInputType.text,
                              obscureText: true,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.all(10.0),
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
                            TextField(
                              style: TextStyle(color: Color(0xFF000000)),
                              controller: phoneController,
                              cursorColor: Color(0xFF9b9b9b),
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                WhitelistingTextInputFormatter.digitsOnly
                              ],
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.all(10.0),
                                prefixIcon: Icon(
                                  Icons.mobile_screen_share,
                                  color: Colors.grey,
                                ),
                                hintText: "Phone",
                                hintStyle: TextStyle(
                                    color: Color(0xFF9b9b9b),
                                    fontSize: 15,
                                    fontWeight: FontWeight.normal),
                              ),
                            ),

                            /////////////// SignUp Button ////////////

                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 35, bottom: 25),
                              child: GFButton(
                                onPressed: () {
                                  _isLoading ? null : _handleLogin();
                                },
                                text: _isLoading ? "Creating.." : "Create Account",
                              
                                color: Color.fromRGBO(100, 140, 255, 1.0),
                                shape: GFButtonShape.pills,
                                fullWidthButton: true,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  Column(
                                    children: <Widget>[
                                      Center(
                                          child: _isLoggedIn
                                              ? Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    Image.network(
                                                      userProfile["picture"]
                                                          ["data"]["url"],
                                                      height: 50.0,
                                                      width: 50.0,
                                                    ),
                                                    Text(userProfile["name"]),
                                                    OutlineButton(
                                                      child: Text("Logout"),
                                                      onPressed: () {
                                                        _logoutFacebook();
                                                      },
                                                    )
                                                  ],
                                                )
                                              : Center(
                                                  child: FacebookSignInButton(
                                                      onPressed: () {
                                                    _loginWithFacebook();
                                                  }),
                                                )),
                                      SizedBox(height: padding),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    /////////////// already have an account ////////////
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              new MaterialPageRoute(
                                  builder: (context) => LogIn()));
                        },
                        child: Text(
                          'Already have an Account',
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

  void _handleLogin() async {
    setState(() {
      _isLoading = true;
    });

    var data = {
      'key': 'ZKANP-MMKBR-Y5ECF-63589-8CCC',
      'requestType': 'register',
      'username': userNAmeController.text,
      'fname': firstNameController.text,
      'lname': lastNameController.text,
      'email': mailController.text,
      'password': passwordController.text,
      'phone': phoneController.text,
    };

    var res = await CallApi().postData1(data);
    if (res.body.isNotEmpty) {
      var body = json.decode(res.body);
      print(body);
      if ((body['msg'] == 'Username/Email already in use') &&
          !(body['result'] == 'failed')) {
        _failuser = true;
        _isLoading = false;
      } else if ((body['msg'] == 'New user created') &&
          (body['result'] == 'success')) {
        _failuser = false;
        SharedPreferences localStorage = await SharedPreferences.getInstance();
        localStorage.setString('username', userNAmeController.text);
        //localStorage.setString('user', json.encode(body));
        Navigator.push(
            context,
            ScaleRoute(
                page: SecondStep(
              phone: userNAmeController.text,
            )));
      }
      setState(() {
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
      print("OUTPUT: " + res.body);
    }

    //  print(body);
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

import 'dart:convert';
import 'package:fitness_flutter/main.dart';
import 'package:flutter/material.dart';
import 'package:fitness_flutter/api/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './questions.dart';

class SecondStep extends StatefulWidget {
  String phone;

  SecondStep({
    @required this.phone,
  });

  @override
  _LogInState createState() => _LogInState(phon: this.phone);
}

class _LogInState extends State<SecondStep> {
  String phon;

  _LogInState({
    @required this.phon,
  });

  bool _isLoading = false;
  TextEditingController CodeController = TextEditingController();
  ScaffoldState scaffoldState;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                              controller: CodeController,
                              cursorColor: Color(0xFF9b9b9b),
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.account_circle,
                                  color: Colors.grey,
                                ),
                                hintText: "Your Code",
                                errorText:
                                    error_code ? 'Code is Incorrect..' : null,
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
                                    _isLoading ? 'Saving..' : 'Save',
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
                                onPressed: _isLoading ? null : _Save,
                              ),
                            ),
                          ],
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

  var extProfile;
  bool error_code = false;

  void _Save() async {
    setState(() {
      _isLoading = true;
      error_code = false;
    });
    var data = {
      'key': 'ZKANP-MMKBR-Y5ECF-63589-8CCC',
      'requestType': 'verify',
      'phone': this.phon,
      'vericode': CodeController.text,
    };

    // var userData= {};
    var res = await CallApi().postData1(data);
    var body = json.decode(res.body);
    print(body);
    if (body['result'] == 'success') {
      //  userData = body;
      // print(userData);
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.setString('apibld_key', body['apibld_key']);
      localStorage.setString('user', json.encode(body));
      localStorage.setString('user_extProfile', body['detail']['extProfile']);
      var userJson = localStorage.getString('user');
      var user = json.decode(userJson);
      extProfile = user['detail']['extProfile'];
      print("ext: " + extProfile);
      if (extProfile == null) {
        Navigator.push(
            context, new MaterialPageRoute(builder: (context) => Questions()));
      } else {
        Navigator.push(
            context, new MaterialPageRoute(builder: (context) => MyApp1()));
      }
    } else {
      // _showMsg(body['message']);

      _isLoading = false;
      error_code = true;
    }
    setState(() {
      _isLoading = false;
    });
  }
}

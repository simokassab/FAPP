import 'dart:convert';
import 'package:fitness_flutter/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fitness_flutter/api/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './questions.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';


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
  TextEditingController controller = TextEditingController(text: "");
  String thisText = "";
  int pinLength = 6;
  bool hasError = false;
  String errorMessage;

  CupertinoPageScaffold cupertinoPin() {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text("Cupertino Pin Code Text Field Example"),
      ),
      child: SafeArea(
        child: Container(
          child: SingleChildScrollView(
            child: Container(
              color: Colors.blue,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 60.0),
                    child: Text(thisText),
                  ),
                  PinCodeTextField(
                    autofocus: false,
                    controller: controller,
                    hideCharacter: false,
                    highlight: true,
                    highlightColor: CupertinoColors.activeBlue,
                    defaultBorderColor: CupertinoColors.black,
                    hasTextBorderColor: CupertinoColors.activeGreen,
                    maxLength: pinLength,
                    hasError: hasError,
                 //   maskCharacter: "🐶",
                    onTextChanged: (text) {
                      setState(() {
                        hasError = false;
                        thisText = text;
                      });
                    },
                    isCupertino: true,
                    onDone: (text) {
                      print("DONE $text");
                    },
                    wrapAlignment: WrapAlignment.end,
                    pinBoxDecoration:
                        ProvidedPinBoxDecoration.roundedPinBoxDecoration,
                    pinTextStyle: TextStyle(fontSize: 30.0),
                    pinTextAnimatedSwitcherTransition:
                        ProvidedPinBoxTextAnimation.scalingTransition,
                    pinTextAnimatedSwitcherDuration:
                        Duration(milliseconds: 300),
                    highlightAnimation: true,
                    highlightAnimationBeginColor: Colors.black,
                    highlightAnimationEndColor: Colors.white12,
                  ),
                  Visibility(
                    child: Text(
                      "Wrong PIN!",
                      style: TextStyle(color: CupertinoColors.destructiveRed),
                    ),
                    visible: hasError,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 32.0),
                    child: Wrap(
                      alignment: WrapAlignment.spaceEvenly,
                      children: <Widget>[
                        CupertinoButton(
//                      color: Colors.blue,
//                      textColor: Colors.white,
                          child: Text("+"),
                          onPressed: () {
                            setState(() {
                              this.pinLength++;
                            });
                          },
                        ),
                        CupertinoButton(
//                      color: Colors.blue,
//                      textColor: Colors.white,
                          child: Text("-"),
                          onPressed: () {
                            setState(() {
                              this.pinLength--;
                            });
                          },
                        ),
                        CupertinoButton(
//                      color: Colors.blue,
//                      textColor: Colors.white,
                          child: Text("SUBMIT"),
                          onPressed: () {
                            setState(() {
                              this.thisText = controller.text;
                            });
                          },
                        ),
                        CupertinoButton(
//                      color: Colors.red,
//                      textColor: Colors.white,
                          child: Text("SUBMIT Error"),
                          onPressed: () {
                            setState(() {
                              this.hasError = true;
                            });
                          },
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool _isLoading = false;
  TextEditingController CodeController = TextEditingController();
  ScaffoldState scaffoldState;
  @override
  Widget build(BuildContext context) {
    cupertinoPin();
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

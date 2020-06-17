import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fitness_flutter/api/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_country_picker/flutter_country_picker.dart';
import './questions.dart';
import 'package:fitness_flutter/main.dart';

class Register extends StatefulWidget {
  Register({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _Register createState() => _Register();
}

class _Register extends State<Register> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  TextEditingController phoneController = TextEditingController();
  bool _value= false;
  var lang ="en";
  Country _selected;
  bool _isLoading = false;
  List<RadioModel> sampleData = new List<RadioModel>();
  @override
  void initState() {
    super.initState();
    sampleData.add(new RadioModel(false, 'EN', ''));
    sampleData.add(new RadioModel(false, 'AR', ''));
  }

  void _handleLogin() async {
    setState(() {
      _isLoading = true;
    });

    print("lang: "+ lang);

    var data = {
      'key': 'ZKANP-MMKBR-Y5ECF-63589-8CCC',
      'requestType': 'mobileLogin',
      'phone': phoneController.text,
      'language': lang.toString()
    };

    var res = await CallApi().postData1(data);
    if (res.body.isNotEmpty) {
      var body = json.decode(res.body);
      print(body);
      if ((body['msg'] == 'invalid phone number') &&
          !(body['result'] == 'failed')) {
        Fluttertoast.showToast(
            msg: "An Error Occured",
            toastLength: Toast.LENGTH_SHORT,
            // gravity: ToastGravity.,
            timeInSecForIosWeb: 2,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 14.0);
        _isLoading = false;
      } else if ((body['msg'] == 'invalid phone number') &&
          (body['result'] == 'failed')) {
        Fluttertoast.showToast(
            msg: "Invalid phone number..",
            toastLength: Toast.LENGTH_SHORT,
            // gravity: ToastGravity.,
            timeInSecForIosWeb: 2,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 14.0);
      } else {
        Fluttertoast.showToast(
            msg: "Enter the code received by SMS..",
            toastLength: Toast.LENGTH_SHORT,
            // gravity: ToastGravity.,
            timeInSecForIosWeb: 3,
            backgroundColor: Color.fromRGBO(100, 140, 255, 1.0),
            textColor: Colors.white,
            fontSize: 14.0);
        //localStorage.setString('user', json.encode(body));
        Navigator.push(
          context,
          CupertinoPageRoute(
              builder: (_) => SecondStep(
                    phone: phoneController.text,
                  ),
              fullscreenDialog: true),
        );
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

  @override
  Widget build(BuildContext context) {
    final PhoneField = TextField(
       textAlign: _value ? TextAlign.right: TextAlign.left,
     // textDirection: _value ? TextDirection.rtl :  TextDirection.ltr,
      obscureText: false,
      controller: phoneController,
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[
        WhitelistingTextInputFormatter.digitsOnly
      ],
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: _value ? "رقم الهاتف" : "Your Phone Number",
        
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(20.0))),
    );

    final loginButon = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(20.0),
      color: CupertinoColors.activeBlue,
      child: SizedBox(
        width: double.infinity,
        child: CupertinoButton(
          // minWidth: MediaQuery.of(context).size.width,
          padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          onPressed: () {
            _handleLogin();
          },
          child: _isLoading
              ? CupertinoActivityIndicator()
              : Text(_value ? "تسجيل" : "Register",
                  textAlign: TextAlign.center,
                  style: style.copyWith(
                      color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      ),
    );
    return Scaffold(
      body: Center(
        child: Container(
          height: 700,
          child: Padding(
            padding: const EdgeInsets.only(top: 30, left: 20, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 125.0,
                  child: Image.asset(
                    "assets/images/logo1.jpg",
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(
                    child: Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Text("Fitness  App"),
                )),
                SizedBox(height: 15.0),
                Center(
                  child: CountryPicker(
                    showDialingCode: true,
                    onChanged: (Country country) {
                      setState(() {
                        phoneController.text = country.dialingCode.toString();
                        print(country.isoCode);
                        _selected = country;
                      });
                    },
                    selectedCountry: _selected,
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                new Divider(),
                  Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    FlatButton.icon(
                      icon: Icon(Icons.language),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: BorderSide(color: Colors.red)),
                      color: _value ?  Colors.white :  Colors.red,
                      textColor: _value ?  Colors.red :  Colors.white,
                      padding: EdgeInsets.all(8.0),
                      onPressed: () {
                        setState(() {
                          _value =false;
                          lang = "en";
                        });
                      },
                      label: Text(
                        "english".toUpperCase(),
                        style: TextStyle(
                          fontSize: 14.0,
                        ),
                      ),
                    ),
                    SizedBox(width: 20),
                    FlatButton.icon(
                      icon: Icon(Icons.language),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: BorderSide(color: Colors.red)),
                      color: _value ?  Colors.red :  Colors.white,
                      textColor: _value ?  Colors.white :  Colors.red,
                      padding: EdgeInsets.all(8.0),
                      onPressed: () {
                        setState(() {
                          _value =true;
                           lang = "ar";
                        });
                      },
                      label: Text(
                        "عربي".toUpperCase(),
                        style: TextStyle(
                          fontSize: 14.0,
                        ),
                      ),
                    ),
                  ],
                ),
                new Divider(),
                SizedBox(
                  height: 25.0,
                ),
                PhoneField,
                SizedBox(
                  height: 25.0,
                ),
                loginButon,
                SizedBox(
                  height: 15.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

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
      var userJson = localStorage.getString('user');
      var user = json.decode(userJson);
      extProfile = user['detail']['extProfile'];
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

class RadioItem extends StatelessWidget {
  final RadioModel _item;
  RadioItem(this._item);
  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: new EdgeInsets.all(15.0),
      child: new Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          new Container(
            height: 50.0,
            width: 50.0,
            child: new Center(
              child: new Text(_item.buttonText,
                  style: new TextStyle(
                      color: _item.isSelected ? Colors.white : Colors.black,
                      //fontWeight: FontWeight.bold,
                      fontSize: 18.0)),
            ),
            decoration: new BoxDecoration(
              color: _item.isSelected ? Colors.blueAccent : Colors.transparent,
              border: new Border.all(
                  width: 1.0,
                  color: _item.isSelected ? Colors.blueAccent : Colors.grey),
              borderRadius: const BorderRadius.all(const Radius.circular(2.0)),
            ),
          ),
          new Container(
            margin: new EdgeInsets.only(left: 10.0),
            child: new Text(_item.text),
          )
        ],
      ),
    );
  }
}

class RadioModel {
  bool isSelected;
  final String buttonText;
  final String text;

  RadioModel(this.isSelected, this.buttonText, this.text);
}

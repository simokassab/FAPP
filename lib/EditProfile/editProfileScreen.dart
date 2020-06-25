import 'dart:convert';

import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:fitness_flutter/api/api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fitness_flutter/main.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fitness_flutter/Login/loginScreen.dart';
import 'package:flutter/services.dart';
import 'package:flutter/gestures.dart' show DragStartBehavior;

TextEditingController userNameController = TextEditingController();
TextEditingController firstNameController = TextEditingController();
TextEditingController lastNameController = TextEditingController();
TextEditingController mailController = TextEditingController();
TextEditingController birthController = TextEditingController();
TextEditingController heightController = TextEditingController();
TextEditingController weightController = TextEditingController();

class Edit extends StatefulWidget {
  @override
  _EditState createState() => _EditState();
}

class _EditState extends State<Edit> {
  var userData;
  @override
  void initState() {
    _getUserInfo();
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();
  String birthDateInString;
  DateTime birthDate;
  bool isDateSelected = false;
  List gender = ["Male", "Female"];
  var gend;
  String select;
  var user_info;
  var token;

  void _getUserInfo() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var userJson = localStorage.getString('user');
    var use = localStorage.getString('user_extProfile');

    var ext = json.decode(use);
    if (userJson == null) {
      Navigator.push(
          context, new MaterialPageRoute(builder: (context) => LogIn()));
    } else {
      var user = json.decode(userJson);
      setState(() {
        token = user['detail']['apibld_key'];
        user_info = use;
        firstNameController.text = ext['extProfile']['firstname'];
        lastNameController.text = ext['extProfile']['lastname'];
        mailController.text = ext['extProfile']['email'];
        birthController.text = ext['extProfile']['bdate'];
        weightController.text = ext['extProfile']['weight'];
        heightController.text = ext['extProfile']['height'];
        gend = ext['extProfile']['gender'];
      });
    }
  }

  Row addRadioButton(int btnValue, String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Radio(
          activeColor: Color.fromRGBO(100, 100, 255, 0.7),
          value: gender[btnValue],
          groupValue: gend,
          onChanged: (value) {
            setState(() {
           //   print(value);
              select = value;
            });
          },
        ),
        Text(title)
      ],
    );
  }
bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    final format = DateFormat("yyyy-MM-dd");
    final cursorColor = Color.fromRGBO(100, 100, 255, 0.7);
    const sizedBoxSpace = SizedBox(height: 12);
    
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Profile"),
      ),
      body: Container(
        child: ListView(
          //  crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            /////////////  background/////////////
            Container(
              padding: EdgeInsets.only(top: 20),
              alignment: Alignment.topCenter,
              child: new CircleAvatar(
                radius: 50.0,
                backgroundImage: AssetImage("assets/images/image010.jpg"),
              ),
            ),
            Container(
              child: Form(
                key: _formKey,
                autovalidate: true,
                child: Scrollbar(
                  child: SingleChildScrollView(
                    dragStartBehavior: DragStartBehavior.down,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        sizedBoxSpace,
                        TextFormField(
                          textCapitalization: TextCapitalization.words,
                          controller: firstNameController,
                          cursorColor: cursorColor,
                          decoration: InputDecoration(
                              filled: true,
                              icon: Icon(
                                Icons.person,
                                color: cursorColor,
                              ),
                              hintText: "What people Call You :) ?",
                              labelText: "Name",
                              labelStyle: TextStyle(
                                color: Color.fromRGBO(100, 100, 255, 0.6),
                              )),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter your First name';
                            } else if (value.length < 3) {
                              return 'First name Invalid';
                            } else
                              return null;
                          },
                        ),
                        sizedBoxSpace,
                        Divider(),
                        sizedBoxSpace,
                        TextFormField(
                          textCapitalization: TextCapitalization.words,
                          controller: lastNameController,
                          cursorColor: cursorColor,
                          decoration: InputDecoration(
                              filled: true,
                              icon: Icon(
                                Icons.person_pin,
                                color: cursorColor,
                              ),
                              labelText: "Last Name",
                              labelStyle: TextStyle(
                                color: Color.fromRGBO(100, 100, 255, 0.6),
                              )),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter your Last name';
                            } else if (value.length < 3) {
                              return 'Last name Invalid';
                            } else
                              return null;
                          },
                        ),
                        sizedBoxSpace,
                        Divider(),
                        sizedBoxSpace,
                        TextFormField(
                          cursorColor: cursorColor,
                          controller: mailController,
                          decoration: InputDecoration(
                              filled: true,
                              icon: Icon(
                                Icons.email,
                                color: cursorColor,
                              ),
                              hintText: "Email Address",
                              labelText: "Email",
                              labelStyle: TextStyle(
                                color: Color.fromRGBO(100, 100, 255, 0.6),
                              )),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Enter your email here..';
                            }
                            String p =
                                r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

                            RegExp regExp = new RegExp(p);
                            if (!regExp.hasMatch(value)) {
                              return "Invalid email Address";
                            }

                            return null;
                          },
                          keyboardType: TextInputType.emailAddress,
                        ),
                        sizedBoxSpace,
                        Divider(),
                        sizedBoxSpace,
                        DateTimeField(
                          autovalidate: true,
                          //  readOnly: true,
                          cursorColor: cursorColor,
                          controller: birthController,
                          decoration: InputDecoration(
                              filled: true,
                              icon: Icon(
                                Icons.calendar_today,
                                color: cursorColor,
                              ),
                              labelText: "Birth Date",
                              labelStyle: TextStyle(
                                color: Color.fromRGBO(100, 100, 255, 0.6),
                              )),
                          format: format,
                          onShowPicker: (context, currentValue) async {
                            final date = await showDatePicker(
                                context: context,
                                firstDate: DateTime(1900),
                                initialDate: currentValue ?? DateTime.now(),
                                lastDate: DateTime(2100));
                            return date;
                          },
                        ),
                        sizedBoxSpace,
                        Divider(),
                        sizedBoxSpace,
                        Row(
                          children: <Widget>[
                            Icon(
                              Icons.person_add,
                              color: cursorColor,
                            ),
                            Padding(padding: EdgeInsets.all(10)),
                            new Flexible(
                              child: new TextFormField(
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Invalid..';
                                  } else if ((int.parse(value) < 40) ||
                                      ((int.parse(value) > 180))) {
                                    return "Invalid weight";
                                  } else
                                    return null;
                                },
                                controller: weightController,
                                decoration: InputDecoration(
                                    filled: true,
                                    labelText: "Weight",
                                    suffixText: "Kg",
                                    labelStyle: TextStyle(
                                      color: Color.fromRGBO(100, 100, 255, 0.6),
                                    )),
                                keyboardType: TextInputType.numberWithOptions(
                                    decimal: true),
                              ),
                            ),
                            Padding(padding: EdgeInsets.all(10)),
                            new Flexible(
                              child: new TextFormField(
                                controller: heightController,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Invalid';
                                  } else if ((int.parse(value) < 80) ||
                                      ((int.parse(value) > 230))) {
                                    return "Invalid Height";
                                  } else
                                    return null;
                                },
                                decoration: InputDecoration(
                                    filled: true,
                                    labelText: "Height",
                                    suffixText: "cm",
                                    labelStyle: TextStyle(
                                      color: Color.fromRGBO(100, 100, 255, 0.6),
                                    )),
                                keyboardType: TextInputType.numberWithOptions(
                                    decimal: true),
                              ),
                            ),
                          ],
                        ),
                        sizedBoxSpace,
                        Divider(),
                        sizedBoxSpace,
                        Material(
                          elevation: 5.0,
                          borderRadius: BorderRadius.circular(30.0),
                          color: CupertinoColors.activeBlue,
                          child: MaterialButton(
                            minWidth: MediaQuery.of(context).size.width,
                            padding:
                                EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                            onPressed: () {
                              if (_formKey.currentState.validate()) {
                                editProfile();
                              } else {
                                print("error");
                              }
                            },
                            child: 
                              isLoading ? CupertinoActivityIndicator() : 
                            Text("Save",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void logout() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var userJson = localStorage.getString('user');
    var user = json.decode(userJson);
    // logout from the server ...

    var data = {"key": user['detail']['apibld_key'], "requestType": "logout"};
    var res = await CallApi().postData1(data);

    var body = json.decode(res.body);
    if (body['result'] == 'success') {
      localStorage.remove('user');
      Navigator.push(
          context, new MaterialPageRoute(builder: (context) => MyApp1()));
    } else {
      print("Error");
    }
  }

  void editProfile() async {
    

    var data = {
      "key": token,
      "requestType": "updateProfile",
      'profile': {
        'firstname': firstNameController.text,
        'lastname': lastNameController.text,
        'email': mailController.text,
        'height': heightController.text,
        'weight': weightController.text,
        'bdate': birthController.text,
      }
    };
    setState(() {
       isLoading = true;
    });
    var res = await CallApi().postData1(data);
    var body = json.decode(res.body);
   
    //print(body);
    if (body['result'] == "success") {
      print(isLoading);
      SharedPreferences localStorage = await SharedPreferences.getInstance();
    //  setState(() {
        localStorage.setString('user_extProfile', json.encode(body['detail']));
    //  });
      Navigator.push(
          context, new MaterialPageRoute(builder: (context) => MyApp1()));
    }
    else {
      isLoading = false;
    }
  }
}

import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fitness_flutter/api/api.dart';
import 'package:fitness_flutter/components/scale_route.dart';
//import 'package:multiselect_formfield/multiselect_formfield.dart';
import 'package:fitness_flutter/main.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/gestures.dart' show DragStartBehavior;

class Questions extends StatefulWidget {
  @override
  _Questions createState() => _Questions();
}

class _Questions extends State<Questions> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  final _formKey = GlobalKey<FormState>();
  String birthDateInString;
  DateTime birthDate;
  bool isDateSelected = false;
  List gender = ["Male", "Female"];

  String select;
  //List _myActivities;
  //String _myActivitiesResult;
  bool _isLoading = false;

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController mailController = TextEditingController();
  TextEditingController birthController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController heightController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // _myActivities = [];
    // _myActivitiesResult = '';
    select = "male";
  }

  @override
  void dispose() {
    super.dispose();
  }

  Row addRadioButton(int btnValue, String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Radio(
          activeColor: Color.fromRGBO(100, 100, 255, 0.7),
          value: gender[btnValue],
          groupValue: select,
          onChanged: (value) {
            setState(() {
              print(value);
              select = value;
            });
          },
        ),
        Text(title)
      ],
    );
  }

  void _extendProfile() async {
    setState(() {
      _isLoading = true;
    });

    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var userJson = localStorage.getString('user');
    var user = json.decode(userJson);
    print(user['detail']['apibld_key']);
    var data = {
      'key': user['detail']['apibld_key'],
      'requestType': 'updateProfile',
      'profile': {
        'firstname': firstNameController.text,
        'lastname': lastNameController.text,
        'email': mailController.text,
        'gender': select,
        'weight': weightController.text,
        'height': heightController.text,
        'bdate': birthController.text,
      }
    };

    var res = await CallApi().postData1(data);
    if (res.body.isNotEmpty) {
      setState(() {
        _isLoading = true;
      });
      var body = json.decode(res.body);
      print(body);
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      print(body['detail']);
      localStorage.setString('user_extProfile', json.encode(body['detail']));
      Navigator.push(context, ScaleRoute(page: MyApp1()));
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final format = DateFormat("yyyy-MM-dd");
    final cursorColor = Color.fromRGBO(100, 100, 255, 0.7);
    const sizedBoxSpace = SizedBox(height: 12);
    //will
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(
          child: Text("Continue your profile"),
        ),
        backgroundColor: Color.fromRGBO(100, 100, 255, 0.7),
      ),
      //drawer: Drawer(),
      backgroundColor: Colors.grey[100],
      body: ListView(
        children: <Widget>[
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
                            Icons.person_outline,
                            color: cursorColor,
                          ),
                          addRadioButton(0, 'Male'),
                          addRadioButton(1, 'Female'),
                        ],
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
                      //   Row(
                      //     children: <Widget>[
                      //       Icon(
                      //         Icons.favorite_border,
                      //         color: cursorColor,
                      //       ),
                      //       new Flexible(
                      //         child: MultiSelectFormField(
                      //     autovalidate: false,
                      //     titleText: 'My Favorites',
                      //     validator: (value) {
                      //       if (value == null || value.length == 0) {
                      //         return 'Please select one or more options';
                      //       }
                      //     },
                      //     dataSource: [
                      //       {
                      //         "display": "Running",
                      //         "value": "Running",
                      //       },
                      //       {
                      //         "display": "Climbing",
                      //         "value": "Climbing",
                      //       },
                      //       {
                      //         "display": "Walking",
                      //         "value": "Walking",
                      //       },
                      //       {
                      //         "display": "Swimming",
                      //         "value": "Swimming",
                      //       },
                      //       {
                      //         "display": "Soccer Practice",
                      //         "value": "Soccer Practice",
                      //       },
                      //       {
                      //         "display": "Baseball Practice",
                      //         "value": "Baseball Practice",
                      //       },
                      //       {
                      //         "display": "Football Practice",
                      //         "value": "Football Practice",
                      //       },
                      //     ],
                      //     textField: 'display',

                      //     valueField: 'value',
                      //     okButtonLabel: 'OK',
                      //     cancelButtonLabel: 'CANCEL',
                      //     // required: true,
                      //     hintText: 'Please choose one or more',
                      //     onSaved: (value) {
                      //       if (value == null) return;
                      //       setState(() {
                      //         _myActivities = value;
                      //         print(_myActivities);
                      //       });
                      //     },
                      //   ),
                      // ),

                      //     ],
                      //     ),
                      Material(
                        elevation: 5.0,
                        borderRadius: BorderRadius.circular(30.0),
                        color: Color.fromRGBO(100, 100, 255, 0.6),
                        child: MaterialButton(
                          minWidth: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              _extendProfile();
                            } else {
                              //print("error");
                            }
                          },
                          child: Text(_isLoading ? "Saving..." : "Save",
                              textAlign: TextAlign.center,
                              style: style.copyWith(
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
    );
  }
}

import 'package:flutter/material.dart';

class Premium extends StatefulWidget {
  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.
  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  _Premium createState() => _Premium();
}

class _Premium extends State<Premium> {
  String tokenn;
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final loginButon = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color.fromRGBO(252, 207, 68, 1.0),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {},
        child: Text("BE PREMIUM..",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.black, fontWeight: FontWeight.bold)),
      ),
    );

    return Scaffold(
      body: Center(
        child: Container(
          color: Color.fromRGBO(246, 246, 246, 1.0),
          child: Padding(
            padding: const EdgeInsets.all(36.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 240.0,
                  child: Image.asset(
                    "assets/images/prem.png",
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(
                    child: Padding(
                        padding: EdgeInsets.only(top: 30, bottom: 40),
                        child: Text("This is a Premium Content...",
                            style: TextStyle(
                                shadows: <Shadow>[
                                  Shadow(
                                    offset: Offset(1.0, 1.0),
                                    blurRadius: 8.0,
                                    color: Color.fromRGBO(100, 140, 255, 1.0),
                                  ),
                                  Shadow(
                                    offset: Offset(1.0, 1.0),
                                    blurRadius: 6.0,
                                    color: Color.fromRGBO(252, 207, 68, 1.0),
                                  ),
                                ],
                                fontWeight: FontWeight.bold,
                                fontSize: 26.0,
                                color: Colors.black)))),
                SizedBox(
                  height: 25.0,
                ),
                loginButon,
                SizedBox(
                  height: 15.0,
                ),
                RaisedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Back',
                      style: TextStyle(fontSize: 20)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class SettingsPage  extends StatefulWidget {
  @override
  _SettingsPage  createState() => _SettingsPage();
}

class _SettingsPage extends State<SettingsPage> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings Page"),),
    );
  }
}
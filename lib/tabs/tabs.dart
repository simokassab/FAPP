import 'package:flutter/material.dart';
import 'package:fitness_flutter/tabs/Diet.dart';
import 'package:fitness_flutter/tabs/Programs.dart';
import 'package:fitness_flutter/tabs/Results.dart';
import 'package:fitness_flutter/tabs/categories.dart';
import 'package:fitness_flutter/EditProfile/editProfileScreen.dart';

class Tabs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: 
        TabBarView(
          children: <Widget>[
            Programs(),
            Categories(),
            Diet(),
            Results(),
            Edit(),
          ],
        ),
        bottomNavigationBar: TabBar(
          tabs: <Widget>[
            Tab(
              icon: Icon(Icons.home, size: 26.0),
            ),
            Tab(
              icon: Icon(Icons.category, size: 26.0),
            ),
            Tab(
              icon: Icon(Icons.restaurant_menu, size: 26.0),
            ),
            Tab(
              icon: Icon(Icons.insert_chart, size: 26.0),
            ),
            Tab(
              icon: Icon(Icons.person, size: 26.0),
            ),
          ],
          labelPadding: EdgeInsets.all(5.0),
          labelColor: Colors.blue,
          unselectedLabelColor: Colors.black12,
          indicatorWeight: 0.01,
        ),
      ),
    );
  }
}
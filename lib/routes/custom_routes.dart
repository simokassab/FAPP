import 'package:flutter/material.dart';
import 'package:fitness_flutter/routes/route_names.dart';
import 'package:fitness_flutter/tabs/Programs.dart';

class CustomRoute {
  static Route<dynamic> allRoutes(RouteSettings settings){

    switch (settings.name){
      case homeRoute:
        return MaterialPageRoute(builder: (_) => Programs());
    }
  }
}
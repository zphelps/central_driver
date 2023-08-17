import 'package:central_driver/views/login/login.dart';
import 'package:central_driver/widgets/auth/auth_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../views/home/home.dart';

var routes = <String, WidgetBuilder>{
  '/': (_) => const AuthWidget(),
  '/login': (_) => const Login(),
  '/home': (_) => const Home(),
};
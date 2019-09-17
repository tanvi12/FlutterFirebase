import 'package:flutter/material.dart';
import 'package:flutter_interactive_app/SignUpPage/signUp.dart';

import 'HomePage/HomePage.dart';
import 'LoginPage/login.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: LoginPage(),
      routes: <String, WidgetBuilder> {
        '/landingpage': (BuildContext context)=> new MyApp(),
        '/homepage': (BuildContext context) => new HomePage(),
        '/signup': (BuildContext context) => new SignUpPage(),
      },
    );
  }
}


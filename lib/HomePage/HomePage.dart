import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: MaterialButton(
        onPressed: () {
          FirebaseAuth.instance.signOut().then((onValue) {
            Navigator.of(context).pushReplacementNamed('/landingpage');
            Navigator.of(context).pushNamed('/signup');
          });
        },
        child: Text("SingOut"),
      ),
    );
  }
}

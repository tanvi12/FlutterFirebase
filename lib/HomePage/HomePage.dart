import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_interactive_app/LoginPage/login.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirebaseUser user;

  @override
  void initState() {
    super.initState();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "User Profile",
          style: TextStyle(color: Colors.white),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () async {
               await FirebaseAuth.instance.signOut().then((value){
                 Navigator.pushReplacement(
                   context,
                   MaterialPageRoute(builder: (context) => LoginPage()),
                 );
                });
            },
            icon: Icon(Icons.power_settings_new),
          )
        ],
      ),
      body: user == null
          ? CircularProgressIndicator()
          : Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.center,
                      child: CircleAvatar(
                        radius: 100,
                        backgroundColor: Color(0xff476cfb),
                        child: ClipOval(
                          child: new SizedBox(
                            width: 180.0,
                            height: 180.0,
                            child: Image.network(
                              user.photoUrl==null ?"https://images.unsplash.com/photo-1502164980785-f8aa41d53611?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60":user.photoUrl,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 180.0),
                      child: IconButton(
                        icon: Icon(
                          Icons.camera,
                          size: 30.0,
                        ),
                        onPressed: () {
                        },
                      ),
                    ),
                  ],
                ),
                Text(user.email != null ? user.email : ""),
                Text(user.displayName != null ? user.displayName : ""),
              ],
            ),
    );
  }

  getUser() async {
    user = await FirebaseAuth.instance.currentUser();
    setState(() {});
  }
}

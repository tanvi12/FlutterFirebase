import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_interactive_app/LoginPage/login.dart';

import 'home_bloc.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var homeBloc = new HomeBloc();

  @override
  void initState() {
    super.initState();
    homeBloc.dispatch(getFirebaseUser());
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
            onPressed: () {
              homeBloc.dispatch(logoutUser());
            },
            icon: Icon(Icons.power_settings_new),
          )
        ],
      ),
      body: BlocListener<HomeBloc, HomeState>(
        key: Key("HomePageBlockListener"),
        bloc: homeBloc,
        listener: (BuildContext context, HomeState state) {
          if (state is loggedOut) {
            if (state.isLoggedOut) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            }else{
              Scaffold.of(context).showSnackBar(new SnackBar(
                content: new Text(state.message),
              ));
            }
          }else if(state is loaded){
            if(state.message!=null){
              Scaffold.of(context).showSnackBar(new SnackBar(
                content: new Text(state.message),
              ));
            }
          }
        },
        child: BlocBuilder(
          bloc: homeBloc,
          builder: (BuildContext context, HomeState state) {
            if (state is loaded) {
              return Column(
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
                                state.authResult.photoUrl == null
                                    ? "https://images.unsplash.com/photo-1502164980785-f8aa41d53611?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60"
                                    : state.authResult.photoUrl,
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
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
                  Text(state.authResult.email != null
                      ? state.authResult.email
                      : ""),
                  Text(state.authResult.displayName != null
                      ? state.authResult.displayName
                      : ""),
                ],
              );
            } else
              return CircularProgressIndicator();
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    homeBloc.dispose();
  }
}

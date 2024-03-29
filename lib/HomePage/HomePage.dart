import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_interactive_app/LoginPage/login.dart';
import 'package:image_picker/image_picker.dart';

import 'home_bloc.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var homeBloc = new HomeBloc();
  TextEditingController username = TextEditingController();
  String usernameError;

  @override
  void initState() {
    super.initState();
    homeBloc.dispatch(getFirebaseUser());
  }

  void _showImageSelectionDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: Text('PickImage'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  InkWell(
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Text("Camera"),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      homeBloc.dispatch(updateProfilePhoto(ImageSource.camera));
                    },
                  ),
                  InkWell(
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Text("Gallary"),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      homeBloc
                          .dispatch(updateProfilePhoto(ImageSource.gallery));
                    },
                  ),
                ],
              ),
              actions: <Widget>[
                FlatButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Cancel'))
              ]);
        });
  }

  void _showEditProfileDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: Text('Edit Profile'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextField(
                    controller: username,
                    decoration: InputDecoration(
                        labelText: "Username", errorText: usernameError),
                  ),
                ],
              ),
              actions: <Widget>[
                FlatButton(
                    onPressed: () {
                      Navigator.pop(context);
                      if (username.text.length != 0) {
                        homeBloc.dispatch(updateProfile(username.text));
                      }
                    },
                    child: Text('Save')),
                FlatButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Cancel'))
              ]);
        });
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
            } else {
              Scaffold.of(context).showSnackBar(new SnackBar(
                content: new Text(state.message),
              ));
            }
          } else if (state is loaded) {
            if (state.message != null) {
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
                          backgroundColor: Colors.transparent,
                          child: ClipOval(
                            child: new SizedBox(
                              width: 195.0,
                              height: 195.0,
                              child: InkWell(
                                onTap: () {
                                  _showImageSelectionDialog(context);
                                },
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
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 180.0),
                        child: IconButton(
                          icon: Icon(
                            Icons.edit,
                            size: 30.0,
                          ),
                          onPressed: () {
                            username.text = state.authResult.displayName;
                            _showEditProfileDialog(context);
                          },
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Email",
                          style: TextStyle(color: Colors.red),
                        ),
                        Text(state.authResult.email != null
                            ? state.authResult.email
                            : ""),
                        SizedBox(
                          height: 10,
                        ),
                        Text("Name", style: TextStyle(color: Colors.red)),
                        Text(state.authResult.displayName != null
                            ? state.authResult.displayName
                            : "")
                      ],
                    ),
                  )
                ],
              );
            } else
              return Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    homeBloc.dispose();
  }
}

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_interactive_app/HomePage/HomePage.dart';
import 'package:flutter_interactive_app/main.dart';

import '../usermanagement.dart';
import 'login_bloc.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String usernameError, passwordError;
  bool isValidated = true;
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  var loginBloc = LoginBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: BlocListener(
          bloc: loginBloc,
          listener: (BuildContext context, LoginState state) {
            if (state is loaded) {
              if (state .message != null && state.message.isNotEmpty) {
                Scaffold.of(context).showSnackBar(new SnackBar(
                  content: new Text(state.message),
                ));
              } else if (state.authResult != null) {
                UserManagement().storeNewUser(state.authResult.user, context);
              }
            }
          },
          child: BlocBuilder(
              bloc: loginBloc,
              builder: (BuildContext context, LoginState state) {
                if (state is loading)
                  return Center(child: CircularProgressIndicator());
                else if (state is LoginInitial)
                  return mainContain();
                else if (state is loaded) {
                  if (state.loggedIn) {
                    return HomePage();
                  } else {
                    return mainContain(state.message);
                  }
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              }),
        ),
      ),
    );
  }

  Widget mainContain([String message]) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).size.height * .30,
            ),
            TextField(
              controller: username,
              decoration: InputDecoration(
                  labelText: "Username", errorText: usernameError),
            ),
            TextField(
              controller: password,
              obscureText: true,
              decoration: InputDecoration(
                  labelText: "Password", errorText: passwordError),
            ),
            SizedBox(
              height: 30,
            ),
            MaterialButton(
              onPressed: () {
                validateAndLogin();
              },
              color: Colors.orange,
              child: Text(
                "LOGIN",
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text("New user?"),
            SizedBox(
              height: 10,
            ),
            MaterialButton(
                onPressed: () {
                  validateAndSignUp();
                },
                color: Colors.orange,
                child: Text(
                  "SIGNUP",
                  style: TextStyle(color: Colors.white),
                ))
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    loginBloc.dispose();
  }

  void validateAndLogin() {
    setState(() {
      validate();

      if (isValidated) {
        loginBloc.dispatch(loginFirebase(username.text, password.text));
      }
    });
  }

  void validateAndSignUp() {
    setState(() {
      validate();

      if (isValidated) {
        loginBloc.dispatch(signUpToFirebase(username.text, password.text));
      }
    });
  }

  void validate() {
    if (username.text.isEmpty) {
      usernameError = "Username can't be empty";
      isValidated = false;
    } else {
      isValidated = true;
      usernameError = "";
    }
    if (password.text.isEmpty) {
      passwordError = "Password can't be empty";
      isValidated = false;
    } else {
      passwordError = "";
      isValidated = true;
    }
  }
}

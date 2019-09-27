import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_interactive_app/HomePage/HomePage.dart';
import 'package:flutter_interactive_app/SignUpPage/signUp.dart';
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

  FirebaseUser user;

  bool passwordVisible = true;

  bool isChecked = false;

  @override
  void didUpdateWidget(LoginPage oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    loginBloc.dispatch(getFirebaseUser(context));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<LoginBloc, LoginState>(
        key: Key('loginBlocListener'),
        bloc: loginBloc,
        listener: (BuildContext context, LoginState state) {
          if (state is loaded) {
            if (state.message != null && state.message.isNotEmpty) {
              Scaffold.of(context).showSnackBar(new SnackBar(
                content: new Text(state.message),
              ));
            } else if (state.authResult != null) {

              UserManagement().storeNewUser(state.authResult, context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
              );
            }
          }
        },
        child: Container(
          child: BlocBuilder(
              bloc: loginBloc,
              builder: (BuildContext context, LoginState state) {
                if (state is LoginInitial)
                  return mainContain();
                else if (state is loaded) {
                  if (state.loggedIn) {
                    if (state.message == null) {
                      return Container(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      return mainContain(state.message);
                    }
                  } else
                    return mainContain();
                }else if(state is changeCheckBoxState){
                  isChecked = state.checked;
                  username.text =  state.email;
                  password.text =  state.password;
                  return mainContain();
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
              decoration:
                  InputDecoration(labelText: "Email", errorText: usernameError),
            ),
            TextField(
              controller: password,
              obscureText: passwordVisible,
              decoration: InputDecoration(
                labelText: "Password",
                errorText: passwordError,
                suffixIcon: IconButton(
                  icon: Icon(
                    // Based on passwordVisible state choose the icon
                    passwordVisible ? Icons.visibility : Icons.visibility_off,
                    color: Theme.of(context).primaryColorDark,
                  ),
                  onPressed: () {
                    // Update the state i.e. toogle the state of passwordVisible variable
                    setState(() {
                      passwordVisible = !passwordVisible;
                    });
                  },
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Checkbox(
                  value: isChecked,
                  onChanged: (value) {
                    loginBloc
                        .dispatch(new checkBoxChangeListener(context, value));
                  },
                ),
                Text("Remember me"),
                SizedBox(
                  width: 20,
                )
              ],
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
                  moveToSignUpPage(context);
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
    debugPrint("disponsed");
  }

  void validateAndLogin() {
    setState(() {
      validate();

      if (isValidated) {
        loginBloc.dispatch(loginFirebase(username.text, password.text));
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

  void moveToSignUpPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SignUpPage()),
    );
  }
}

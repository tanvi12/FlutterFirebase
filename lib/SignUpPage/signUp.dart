import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_interactive_app/HomePage/HomePage.dart';
import 'package:flutter_interactive_app/SignUpPage/bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../usermanagement.dart';


class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  String usernameError, passwordError,nicknameError;
  bool isValidated = true;
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController nickname = TextEditingController();
  var signUpBloc = SignUpBloc();

  File _image;
  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
      print('Image Path $_image');
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: BlocListener(
          bloc: signUpBloc,
          listener: (BuildContext context, SignUpState state) {
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
              bloc: signUpBloc,
              builder: (BuildContext context, SignUpState state) {
                if (state is loading)
                  return Center(child: CircularProgressIndicator());
                else if (state is SignUpInitial)
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
              height: MediaQuery.of(context).size.height * .10,
            ),
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
                        child: (_image!=null)?Image.file(
                          _image,
                          fit: BoxFit.fill,
                        ):Image.network(
                          "https://images.unsplash.com/photo-1502164980785-f8aa41d53611?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60",
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
                      getImage();
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 10,),
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
            TextField(
              controller: nickname,
              decoration: InputDecoration(
                  labelText: "NickName", errorText: nicknameError),
            ),
            SizedBox(
              height: 30,
            ),
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
    signUpBloc.dispose();
  }


  void validateAndSignUp() {
    setState(() {
      validate();

      if (isValidated) {
        signUpBloc.dispatch(signUpToFirebase(username.text, password.text,nickname.text,_image));
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

    if (nickname.text.isEmpty) {
      nicknameError = "Name can't be empty";
      isValidated = false;
    } else {
      nicknameError = "";
      isValidated = true;
    }
  }

}

import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_interactive_app/usermanagement.dart';
import './bloc.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  @override
  LoginState get initialState => LoginInitial();

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    if (event is loginFirebase) {
      yield loading();

      yield await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: event.username, password: event.password)
          .then((signedInUser) {
        if (signedInUser.user != null)
          return loaded(loggedIn: true,authResult: signedInUser.user);
        else
          return loaded(loggedIn: false);
      }).catchError((e) {
        return loaded(loggedIn: false, message: e.message);
      });
    } else if (event is getFirebaseUser) {
      yield loading();
      yield await FirebaseAuth.instance.currentUser().then((user) {
        if (user != null)
          return loaded(loggedIn: true,authResult: user);
        else
          return loaded(loggedIn: false);
      });
    }
  }
}

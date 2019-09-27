import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_interactive_app/usermanagement.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './bloc.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final String _kRememberMe = "remember_me";
  final String _kEmail = "email";
  final String _kPassword = "password";

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
        if (signedInUser.user != null) {
          return SharedPreferences.getInstance().then((preference) {
            bool checked = preference.getBool(_kRememberMe);
            if (checked != null && checked) {
              preference.setString(_kEmail, event.username);
              preference.setString(_kPassword, event.password);
            } else {
              preference.remove(_kEmail);
              preference.remove(_kPassword);
            }
            return loaded(loggedIn: true, authResult: signedInUser.user);
          });

        } else
          return loaded(loggedIn: false);
      }).catchError((e) {
        return loaded(loggedIn: false, message: e.message);
      });
    } else if (event is getFirebaseUser) {
      yield loading();
      yield await FirebaseAuth.instance.currentUser().then((user) {
        if (user != null)
          return loaded(loggedIn: true, authResult: user);
        else {
          return SharedPreferences.getInstance().then((preference) {
            bool checked = preference.getBool(_kRememberMe);
            if (checked != null && checked) {
              return changeCheckBoxState(
                  checked: true,
                  email: preference.get(_kEmail),
                  password: preference.get(_kPassword));
            } else {
              return changeCheckBoxState(checked: false);
            }
          });

        }
      });
    } else if (event is checkBoxChangeListener) {
      yield changeCheckBoxState(checked: event.isChecked);
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool(_kRememberMe, event.isChecked);
    }
  }
}

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

@immutable
abstract class LoginEvent extends Equatable {
  LoginEvent([List props = const <dynamic>[]]) : super(props);
}

class loginFirebase extends LoginEvent {
  final String username, password;

  loginFirebase(this.username, this.password) : super([username, password]);
}

class getFirebaseUser extends LoginEvent {
  final BuildContext context;

  getFirebaseUser(this.context) : super([context]);
}

class checkBoxChangeListener extends LoginEvent {
  final BuildContext context;
  bool isChecked;

  checkBoxChangeListener(this.context, this.isChecked)
      : super([context, isChecked]);
}

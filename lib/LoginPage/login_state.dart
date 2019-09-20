import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

@immutable
abstract class LoginState extends Equatable {
  LoginState([List props = const <dynamic>[]]) : super(props);
}

class LoginInitial extends LoginState {

}

class loading extends LoginState {}

class loaded extends LoginState {
  final bool loggedIn;
  final String message;
  final FirebaseUser authResult;

  loaded({this.loggedIn,this.message,this.authResult}) : super([loggedIn,message,authResult]);
}


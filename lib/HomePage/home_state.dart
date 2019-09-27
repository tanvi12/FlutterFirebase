import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

@immutable
abstract class HomeState extends Equatable {
  HomeState([List props = const <dynamic>[]]) : super(props);
}

class InitialHomeState extends HomeState {}


class loading extends HomeState {}

class loaded extends HomeState {
  final bool loggedIn;
  final String message;
  final FirebaseUser authResult;

  loaded({this.loggedIn,this.message,this.authResult}) : super([loggedIn,message,authResult]);
}

class loggedOut extends HomeState {
  final bool isLoggedOut;
  final String message;

  loggedOut({this.isLoggedOut,this.message}) : super([isLoggedOut,message]);
}
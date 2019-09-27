import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

@immutable
abstract class HomeEvent extends Equatable {
  HomeEvent([List props = const <dynamic>[]]) : super(props);
}

class getFirebaseUser extends HomeEvent {

  getFirebaseUser() : super([]);
}

class logoutUser extends HomeEvent {
  bool isLoggedOut;
  String message;
  logoutUser({this.isLoggedOut,this.message}) : super([isLoggedOut,message]);
}
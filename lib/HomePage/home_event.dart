import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
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

  logoutUser({this.isLoggedOut, this.message}) : super([isLoggedOut, message]);
}

class updateProfilePhoto extends HomeEvent {
  ImageSource source;
  updateProfilePhoto(this.source) : super([source]);
}

class updateProfile extends HomeEvent {
  String name;
  updateProfile(this.name) : super([name]);
}





import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';


@immutable
abstract class SignUpState extends Equatable {
  SignUpState([List props = const <dynamic>[]]) : super(props);
}
class SignUpInitial extends SignUpState {}

class loading extends SignUpState {}

class loaded extends SignUpState {
  final bool loggedIn;
  final String message;
  final AuthResult authResult;

  loaded({this.loggedIn,this.message,this.authResult}) : super([loggedIn,message,authResult]);
}

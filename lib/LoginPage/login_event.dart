import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class LoginEvent extends Equatable {
  LoginEvent([List props = const <dynamic>[]]) : super(props);
}

class loginFirebase extends LoginEvent {
  final String username, password;

  loginFirebase(this.username, this.password) : super([username, password]);

}




import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';


@immutable
abstract class SignUpEvent extends Equatable {
  SignUpEvent([List props = const <dynamic>[]]) : super(props);
}

class signUpToFirebase extends SignUpEvent {
  final String username, password,nickname;

  signUpToFirebase(this.username, this.password,this.nickname) : super([username, password,nickname]);

}
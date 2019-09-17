import 'dart:async';
import 'dart:math';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './bloc.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  @override
  SignUpState get initialState => SignUpInitial();

  @override
  Stream<SignUpState> mapEventToState(
    SignUpEvent event,
  ) async* {
    if (event is signUpToFirebase) {
      yield loading();

      yield await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: event.username, password: event.password)
          .then((signedInUser) {
        if (signedInUser.user != null) {
          var updateUser = new UserUpdateInfo();
          updateUser.displayName = event.nickname;
          updateUser.photoUrl = "https://www.gstatic.com/webp/gallery3/1.png";
          signedInUser.user.updateProfile(updateUser).then((updatedUser){
            return loaded(loggedIn: true);
          }).catchError((e){
            return loaded(loggedIn: false, message: e.message);
          });
        } else {
          return loaded(loggedIn: false);
        }
        return loading();
      }).catchError((e) {
        return loaded(loggedIn: false, message: e.message);
      });
    }
  }
}

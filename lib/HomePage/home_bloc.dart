import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './bloc.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  @override
  HomeState get initialState => InitialHomeState();

  @override
  Stream<HomeState> mapEventToState(
    HomeEvent event,
  ) async* {
    if (event is getFirebaseUser) {
      yield loading();
      yield await FirebaseAuth.instance.currentUser().then((user) {
        if (user != null)
          return loaded(loggedIn: true, authResult: user);
        else
          return loaded(loggedIn: false, message: "Failed to get details");
      }).catchError((e) {
        return loaded(loggedIn: false, message: e.message);
      });
    } else if (event is logoutUser) {
      yield await FirebaseAuth.instance.currentUser().then((user) {
        if (user != null)
          return loaded(loggedIn: true, authResult: user);
        else
          return loaded(loggedIn: false, message: "Failed to get details");
      }).catchError((e) {
        return loaded(loggedIn: false, message: e.message);
      });
      yield await FirebaseAuth.instance.signOut().then((value) {
        return loggedOut(isLoggedOut: true, message: "");
      });
    }
  }
}

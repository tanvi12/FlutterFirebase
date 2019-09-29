import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import './bloc.dart';
import 'package:path/path.dart';

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
    } else if (event is updateProfilePhoto) {
      yield loading();
      yield await FirebaseAuth.instance.currentUser().then((user) {
        if (user != null) {
          return updateUser(user, event.source);
        } else {
          return loaded(loggedIn: false, message: "Failed to get details");
        }
      }).catchError((e) {
        return loaded(loggedIn: false, message: e.message);
      });
    } else if (event is updateProfile) {
      yield loading();
      yield await FirebaseAuth.instance.currentUser().then((user) async {
        if (user != null) {
          var updateUser = new UserUpdateInfo();
          updateUser.displayName = event.name;
          return await user.updateProfile(updateUser).then((updatedUser) async {
            return await FirebaseAuth.instance.currentUser().then((user) {
              return loaded(loggedIn: true, authResult: user);
            });
          }).catchError((e) {
            return loaded(loggedIn: false, message: e.message);
          });
          ;
        } else {
          return loaded(loggedIn: false, message: "Failed to get details");
        }
      }).catchError((e) {
        return loaded(loggedIn: false, message: e.message);
      });
    }
  }
}

Future<HomeState> updateUser(FirebaseUser user, ImageSource source) async {
  return ImagePicker.pickImage(source: source).then((file) async {
    return await uploadPic(file).then((snapshot) async {
      var updateUser = new UserUpdateInfo();
      updateUser.photoUrl = await snapshot.ref.getDownloadURL();
      return await user.updateProfile(updateUser).then((updatedUser) async {
        return await FirebaseAuth.instance.currentUser().then((user) {
          return loaded(loggedIn: true, authResult: user);
        });
      }).catchError((e) {
        return loaded(loggedIn: false, message: e.message);
      });
    });
  });
}

Future<StorageTaskSnapshot> uploadPic(File file) async {
  String fileName = basename(file.path);
  StorageReference firebaseStorageRef =
      FirebaseStorage.instance.ref().child(fileName);
  StorageUploadTask uploadTask = firebaseStorageRef.putFile(file);
  return await uploadTask.onComplete;
}

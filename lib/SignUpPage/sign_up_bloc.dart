import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
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
        return updateUser(signedInUser, event);
      }).catchError((e) {
        return loaded(loggedIn: false, message: e.message);
      });
    } else if (event is selectImage) {
      yield await ImagePicker.pickImage(source: event.source).then((image) {
        return imageSelected(image);
      });
    }
  }
}

Future<SignUpState> updateUser(
    AuthResult signedInUser, signUpToFirebase event) async {
  if (signedInUser.user != null) {
    if (event.file != null) {
      return await uploadPic(event.file).then((snapshot) async {
        var updateUser = new UserUpdateInfo();
        updateUser.displayName = event.nickname;
        debugPrint(snapshot.uploadSessionUri.toString());
        updateUser.photoUrl = await snapshot.ref.getDownloadURL();
        return await signedInUser.user
            .updateProfile(updateUser)
            .then((updatedUser) {
          return loaded(loggedIn: true, authResult: signedInUser);
        }).catchError((e) {
          return loaded(loggedIn: false, message: e.message);
        });
      });
    } else {
      var updateUser = new UserUpdateInfo();
      updateUser.displayName = event.nickname;
      return await signedInUser.user
          .updateProfile(updateUser)
          .then((updatedUser) {
        return loaded(loggedIn: true, authResult: signedInUser);
      }).catchError((e) {
        return loaded(loggedIn: false, message: e.message);
      });
    }
  } else {
    return loaded(loggedIn: false);
  }
}

Future<StorageTaskSnapshot> uploadPic(File file) async {
  String fileName = basename(file.path);
  StorageReference firebaseStorageRef =
      FirebaseStorage.instance.ref().child(fileName);
  StorageUploadTask uploadTask = firebaseStorageRef.putFile(file);
  return await uploadTask.onComplete;
}

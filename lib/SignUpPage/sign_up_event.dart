import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';


@immutable
abstract class SignUpEvent extends Equatable {
  SignUpEvent([List props = const <dynamic>[]]) : super(props);
}

class signUpToFirebase extends SignUpEvent {
  final String username, password,nickname;
  final File file;

  signUpToFirebase(this.username, this.password,this.nickname,this.file) : super([username, password,nickname,file]);

}

class selectImage extends SignUpEvent {
  ImageSource source;
  selectImage(this.source) : super([source]);
}


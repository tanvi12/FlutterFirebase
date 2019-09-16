import 'package:cloud_firestore/cloud_firestore.dart';

class UserManagement {
  storeNewUser(user, context) {
    Firestore.instance.collection('/users').add({
      'email': user.email,
      'uid': user.uid
    }).then((value) {
    }).catchError((e) {
      print(e);
    });
  }
}
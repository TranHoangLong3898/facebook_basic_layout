import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:facebook_basic_layout/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserService extends ChangeNotifier {
  final fireAuth = FirebaseAuth.instance;
  FUser currentUser = FUser('', '', '', false, '', [], []);
  final firebasefirestore = FirebaseFirestore.instance.collection('user');

  logIn(String email, String password) {
    fireAuth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((user) {
      changeStatus(true);
      getData();
      // chatTest();
    });
  }

  getData() {
    FirebaseFirestore.instance
        .collection('user')
        .doc(fireAuth.currentUser!.uid)
        .snapshots()
        .listen((snapshot) {
      currentUser = FUser.fromDocShapshot(snapshot);
      notifyListeners();
    });
  }

  Future<void> changeStatus(bool status) async {
    DocumentReference docRef = firebasefirestore.doc(fireAuth.currentUser!.uid);
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      transaction.update(docRef, {'status': status});
    });
  }

  void logOut() {
    changeStatus(false).then((_) => FirebaseAuth.instance.signOut());
  }
}

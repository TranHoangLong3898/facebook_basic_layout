import 'package:facebook_basic_layout/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FriendController extends ChangeNotifier {
  List<FUser> friends = [];
  final firebaseRef = FirebaseFirestore.instance.collection('user');

  FriendController(FUser currentUser) {
    friends.clear();
    for (var id in currentUser.friends) {
      firebaseRef.doc(id).snapshots().listen((friend) {
        FUser fUser = FUser.fromDocShapshot(friend);
        if (friends.contains(fUser)) {
          int index = friends.indexOf(fUser);
          friends[index] = fUser;
        } else {
          friends.add(fUser);
        }
        notifyListeners();
      });
    }
  }
}

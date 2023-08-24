import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:facebook_basic_layout/model/user_model.dart';
import 'package:flutter/material.dart';

class StoryController extends ChangeNotifier {
  List<FUser> friends = [];
  final firebaseRef = FirebaseFirestore.instance.collection('user');
  bool isStart = true;
  bool isEnd = false;

  void changeIsStart(bool bool) {
    isStart = bool;
    notifyListeners();
  }

  void changeIsEnd(bool bool) {
    isEnd = bool;
    notifyListeners();
  }

  StoryController(FUser currentUser) {
    for (var id in currentUser.friends) {
      firebaseRef.doc(id).snapshots().listen((snapshot) {
        var friend = FUser.fromDocShapshot(snapshot);
        if (friend.stories.isNotEmpty) friends.add(friend);
        notifyListeners();
      });
    }
  }
}

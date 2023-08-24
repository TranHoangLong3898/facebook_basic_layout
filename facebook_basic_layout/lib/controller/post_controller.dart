import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:facebook_basic_layout/model/post_model.dart';
import 'package:facebook_basic_layout/model/user_model.dart';
import 'package:facebook_basic_layout/model/user_post.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_functions/cloud_functions.dart';

class PostController extends ChangeNotifier {
  var firebaseRef = FirebaseFirestore.instance.collection('user');

  List<UserPost> listPost = [];

  PostController(FUser currentUser) {
    if (currentUser.role == 'admin') {
      listPost.clear();
      firebaseRef.snapshots().listen((snapshot) {
        for (var doc in snapshot.docs) {
          FUser user = FUser.fromDocShapshot(doc);
          getPost(user);
        }
      });
    } else {
      listPost.clear();
      var listId = currentUser.friends;
      listId.add(FirebaseAuth.instance.currentUser?.uid);
      for (var id in currentUser.friends) {
        firebaseRef.doc(id).snapshots().listen((snapshot) {
          FUser user = FUser.fromDocShapshot(snapshot);
          getPost(user);
        });
      }
    }
  }
  void getPost(FUser user) {
    firebaseRef.doc(user.id).collection('posts').snapshots().listen((event) {
      if (event.docChanges.isNotEmpty) {
        List<UserPost> checkList =
            listPost.where((element) => element.user.id == user.id).toList();
        for (var doc in event.docs) {
          var p = Post.fromSnapshot(doc);
          checkList.remove(UserPost(user, p));
          if (!listPost.contains(UserPost(user, p))) {
            listPost.add(UserPost(user, p));
            listPost.sort((a, b) => b.post.time.compareTo(a.post.time));
          } else {
            listPost[listPost.indexOf(UserPost(user, p))].post = p;
          }
        }
        if (checkList.isNotEmpty) {
          for (var element in checkList) {
            listPost.remove(element);
          }
        }
      }
      notifyListeners();
    });
  }

  like(String postId, String userId) async {
    final HttpsCallable callable =
        FirebaseFunctions.instance.httpsCallable('likePost');
    try {
      dynamic data = {"postId": postId, "userId": userId};
      await callable.call(data);
    } catch (e) {
      print(e);
    }
  }

  delete(UserPost userPost, FUser currentUser) async {
    final HttpsCallable callable =
        FirebaseFunctions.instance.httpsCallable('deletePost');
    dynamic data = {"ownerId": userPost.user.id, "postId": userPost.post.id};
    try {
      final HttpsCallableResult result = await callable.call(data);
    } catch (e) {
      print(e);
    }
  }
}

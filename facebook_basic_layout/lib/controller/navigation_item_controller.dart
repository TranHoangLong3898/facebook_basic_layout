import 'package:facebook_basic_layout/model/naviagtion_item_model.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NavigationItemController extends ChangeNotifier {
  List<NaviagtionItem> items = [];

  NavigationItemController() {
    FirebaseFirestore.instance
        .collection('navigation_Items')
        .snapshots()
        .listen((snapshot) {
      items.clear();
      for (var item in snapshot.docs) {
        items.add(NaviagtionItem.fromSnapshot(item));
      }
      notifyListeners();
    });
  }
}

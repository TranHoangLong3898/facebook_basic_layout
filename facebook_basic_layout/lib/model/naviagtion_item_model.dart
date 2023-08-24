import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NaviagtionItem {
  String name;
  Icon icon;

  NaviagtionItem(this.name, this.icon);

  static NaviagtionItem fromSnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> item) {
    return NaviagtionItem(
        item['name'],
        Icon(IconData(
            int.parse(
              item['icon'].split('.')[1],
            ),
            fontFamily: item['icon'].split('.')[0])));
  }
}

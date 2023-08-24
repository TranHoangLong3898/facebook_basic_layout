import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:facebook_basic_layout/model/story_model.dart';

class FUser {
  String id;
  String name;
  String avatar;
  bool status;
  String role;
  List<Story> stories;
  List<dynamic> friends;

  FUser(this.id, this.name, this.avatar, this.status, this.role, this.stories,
      this.friends);
  static FUser fromShapshot(QueryDocumentSnapshot<Map<String, dynamic>> user) {
    return FUser(user.id, user['name'], user['avatar'], user['status'],
        user['role'], Story.toListFromSnapshot(user), user['friends']);
  }

  FUser.empty()
      : id = '',
        avatar = '',
        name = '',
        status = false,
        role = '',
        stories = [],
        friends = [];
  static FUser fromDocShapshot(DocumentSnapshot<Map<String, dynamic>> user) {
    return FUser(user.id, user['name'], user['avatar'], user['status'],
        user['role'], Story.toListFromSnapshot(user), user['friends']);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FUser && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

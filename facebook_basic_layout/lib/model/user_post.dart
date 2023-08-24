import 'package:facebook_basic_layout/model/post_model.dart';
import 'package:facebook_basic_layout/model/user_model.dart';

class UserPost {
  FUser user;
  Post post;

  UserPost(this.user, this.post);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserPost &&
          runtimeType == other.runtimeType &&
          post.id == other.post.id;

  @override
  int get hashCode => post.id.hashCode;
}

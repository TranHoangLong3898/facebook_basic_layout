import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  String id;
  String img;
  String content;
  List<dynamic> likes;
  Timestamp time;

  Post(this.id, this.img, this.content, this.likes, this.time);

  static fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> post) {
    return Post(post.id, post.get('img'), post.get('content'),
        post.get('likes'), post.get('time'));
  }

  static Post fromDocSnapshot(DocumentSnapshot<Object?> post) {
    return Post(post.id, post.get('img'), post.get('content'),
        post.get('likes'), post.get('time'));
  }
}

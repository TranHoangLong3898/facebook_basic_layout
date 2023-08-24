import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String content;
  String sender;
  Timestamp time;

  Message(this.content, this.sender, this.time);

  static Message fromSnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> message) {
    return Message(
        message.get('content'), message.get('sender'), message.get('time'));
  }
}

import 'dart:developer';
import 'package:facebook_basic_layout/model/user_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../model/message_model.dart';
import 'package:cloud_functions/cloud_functions.dart';

class ChatController extends ChangeNotifier {
  bool _isOpen = false;
  FUser _friend = FUser.empty();
  List<Message> _messages = [];
  String _chatRoomId = '';

  static final ChatController _singleton = ChatController._internal();
  ChatController._internal();

  factory ChatController() {
    return _singleton;
  }

  bool get isOpen => _isOpen;
  FUser get friend => _friend;
  List<Message> get messages => _messages;
  String get chatRoomId => _chatRoomId;

  void showChatBox(FUser friend) {
    _isOpen = true;
    _friend = friend;
    getMessages();
    notifyListeners();
  }

  void closeChatBox() {
    _isOpen = false;
    notifyListeners();
  }

  void getMessages() {
    _messages.clear();
    final firestoreRef = FirebaseFirestore.instance.collection('chat_room');
    List<String> members = [FirebaseAuth.instance.currentUser!.uid, friend.id];
    members.sort();
    firestoreRef
        .where('members', isEqualTo: members)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.docs.length == 1) {
        _chatRoomId = snapshot.docs.first.id;
        firestoreRef
            .doc(snapshot.docs.first.id)
            .collection('messages')
            .orderBy('time', descending: true)
            .snapshots()
            .listen((messagesSnapshot) {
          List<Message> data = [];
          for (var element in messagesSnapshot.docs) {
            final mess = Message.fromSnapshot(element);
            data.add(mess);
          }
          _messages = data;
          notifyListeners();
        });
      }
    });
  }

  Future<void> chat(Message message) async {
    final HttpsCallable callable =
        FirebaseFunctions.instance.httpsCallable('sendMessage');
    dynamic data = {
      'content': message.content,
      'sender': message.sender,
      // 'time': message.time.toString(),
      'seconds': message.time.seconds,
      'nanoseconds': message.time.nanoseconds,
      'roomId': _chatRoomId
    };
    try {
      final HttpsCallableResult result = await callable.call(data);
      log('sent');
    } catch (e) {
      log(e.toString());
    }
  }
}

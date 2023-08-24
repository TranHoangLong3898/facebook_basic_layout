import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:facebook_basic_layout/controller/chat_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../model/message_model.dart';

class ChatBox extends StatelessWidget {
  final double navigationBarWidth;
  const ChatBox(this.navigationBarWidth, {super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ChatController>.value(
      value: ChatController(),
      child: Consumer<ChatController>(
        builder: (context, chatBox, child) => Visibility(
            child: Visibility(
          visible: chatBox.isOpen,
          child: SizedBox(
            height: 400,
            width: 330,
            child: Column(children: [
              ChatBoxHeader(
                chatBox: chatBox,
              ),
              ChatBoxBody(messages: chatBox.messages),
              TextBox(chatBox: chatBox)
            ]),
          ),
        )),
      ),
    );
  }
}

class ChatBoxHeader extends StatelessWidget {
  final ChatController chatBox;

  const ChatBoxHeader({super.key, required this.chatBox});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10), topRight: Radius.circular(10)),
        color: Theme.of(context).primaryColor,
      ),
      height: 50,
      width: 330,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(5, 8, 8, 8),
        child: Stack(
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage(chatBox.friend.avatar),
                  radius: 20,
                ),
                Text(
                  chatBox.friend.name,
                  style: const TextStyle(color: Colors.white),
                )
              ],
            ),
            Positioned(
                right: 0,
                child: Row(
                  children: [
                    TextButton(
                        style: ButtonStyle(
                          minimumSize:
                              MaterialStateProperty.all(const Size(0, 0)),
                          padding: MaterialStateProperty.all<EdgeInsets>(
                              const EdgeInsets.fromLTRB(4, 0, 0, 0)),
                        ),
                        onPressed: () {},
                        child: const Icon(
                          Icons.phone,
                          color: Colors.white,
                        )),
                    TextButton(
                        style: ButtonStyle(
                          minimumSize:
                              MaterialStateProperty.all(const Size(0, 0)),
                          padding: MaterialStateProperty.all<EdgeInsets>(
                              const EdgeInsets.fromLTRB(4, 0, 0, 0)),
                        ),
                        onPressed: () {},
                        child: const Icon(
                          Icons.video_camera_front,
                          color: Colors.white,
                        )),
                    TextButton(
                        style: ButtonStyle(
                          minimumSize:
                              MaterialStateProperty.all(const Size(0, 0)),
                          padding: MaterialStateProperty.all<EdgeInsets>(
                              const EdgeInsets.fromLTRB(4, 0, 0, 0)),
                        ),
                        onPressed: () {},
                        child: const Icon(
                          Icons.horizontal_rule,
                          color: Colors.white,
                        )),
                    TextButton(
                        style: ButtonStyle(
                          minimumSize:
                              MaterialStateProperty.all(const Size(0, 0)),
                          padding: MaterialStateProperty.all<EdgeInsets>(
                              const EdgeInsets.fromLTRB(4, 0, 0, 0)),
                        ),
                        onPressed: () {
                          chatBox.closeChatBox();
                        },
                        child: const Icon(
                          Icons.cancel,
                          color: Colors.white,
                        )),
                  ],
                ))
          ],
        ),
      ),
    );
  }
}

class ChatBoxBody extends StatelessWidget {
  final List<Message> messages;
  const ChatBoxBody({super.key, required this.messages});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.symmetric(
            vertical:
                BorderSide(color: Theme.of(context).primaryColor, width: 2)),
        color: const Color.fromARGB(255, 235, 235, 235),
      ),
      height: 300,
      child: ListView.builder(
        itemCount: messages.length,
        reverse: true,
        itemBuilder: (context, index) => Row(
          mainAxisAlignment:
              messages[index].sender == FirebaseAuth.instance.currentUser!.uid
                  ? MainAxisAlignment.end
                  : MainAxisAlignment.start,
          children: [
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 250),
              child: Card(
                color: messages[index].sender ==
                        FirebaseAuth.instance.currentUser!.uid
                    ? const Color.fromARGB(255, 235, 235, 235)
                    : Theme.of(context).primaryColor,
                elevation: 12,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    messages[index].content,
                    style: TextStyle(
                        color: messages[index].sender ==
                                FirebaseAuth.instance.currentUser!.uid
                            ? Theme.of(context).primaryColor
                            : const Color.fromARGB(255, 235, 235, 235)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TextBox extends StatefulWidget {
  final ChatController chatBox;
  const TextBox({super.key, required this.chatBox});

  @override
  State<TextBox> createState() => _TextBoxState();
}

class _TextBoxState extends State<TextBox> {
  double textFieldHeight = 35;
  double textFieldwidth = 150;
  bool isVisible = true;
  double opacity = 1;
  Icon sendOrEmoji = const Icon(
    Icons.thumb_up_alt,
    color: Colors.white,
  );
  final TextEditingController _mess = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      color: Theme.of(context).primaryColor,
      width: 330,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          AnimatedOpacity(
            opacity: opacity,
            duration: const Duration(milliseconds: 700),
            child: Visibility(
              visible: isVisible,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                        style: ButtonStyle(
                          minimumSize:
                              MaterialStateProperty.all(const Size(0, 0)),
                          padding: MaterialStateProperty.all<EdgeInsets>(
                              const EdgeInsets.fromLTRB(6, 0, 6, 0)),
                        ),
                        onPressed: () {},
                        child: const Icon(
                          Icons.add_circle,
                          color: Colors.white,
                        )),
                    TextButton(
                        style: ButtonStyle(
                          minimumSize:
                              MaterialStateProperty.all(const Size(0, 0)),
                          padding: MaterialStateProperty.all<EdgeInsets>(
                              const EdgeInsets.fromLTRB(6, 0, 6, 0)),
                        ),
                        onPressed: () {},
                        child: const Icon(
                          Icons.photo,
                          color: Colors.white,
                        )),
                    TextButton(
                        style: ButtonStyle(
                          minimumSize:
                              MaterialStateProperty.all(const Size(0, 0)),
                          padding: MaterialStateProperty.all<EdgeInsets>(
                              const EdgeInsets.fromLTRB(6, 0, 6, 0)),
                        ),
                        onPressed: () {},
                        child: const Icon(
                          Icons.emoji_emotions,
                          color: Colors.white,
                        )),
                    TextButton(
                        style: ButtonStyle(
                          minimumSize:
                              MaterialStateProperty.all(const Size(0, 0)),
                          padding: MaterialStateProperty.all<EdgeInsets>(
                              const EdgeInsets.fromLTRB(6, 0, 6, 0)),
                        ),
                        onPressed: () {},
                        child: const Icon(
                          Icons.gif_sharp,
                          color: Colors.white,
                        )),
                  ]),
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: textFieldHeight,
            width: textFieldwidth,
            child: TextField(
              onChanged: (value) {
                changeText(value);
              },
              onSubmitted: (value) {
                widget.chatBox.chat(Message(value,
                    FirebaseAuth.instance.currentUser!.uid, Timestamp.now()));
                _mess.clear();
                changeText(_mess.text);
              },
              controller: _mess,
              textAlignVertical: TextAlignVertical.center,
              decoration: InputDecoration(
                  contentPadding: const EdgeInsets.fromLTRB(10, 13, 10, 13),
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide.none,
                  )),
            ),
          ),
          TextButton(
              style: ButtonStyle(
                minimumSize: MaterialStateProperty.all(const Size(0, 0)),
                padding: MaterialStateProperty.all<EdgeInsets>(
                    const EdgeInsets.fromLTRB(4, 0, 4, 0)),
              ),
              onPressed: () {
                widget.chatBox.chat(Message(_mess.text,
                    FirebaseAuth.instance.currentUser!.uid, Timestamp.now()));
                _mess.clear();
                changeText(_mess.text);
              },
              child: sendOrEmoji)
        ],
      ),
    );
  }

  void changeText(String value) {
    if (value != "") {
      setState(() {
        textFieldwidth = 290;
        isVisible = false;
        opacity = 0;
        sendOrEmoji = const Icon(
          Icons.send,
          color: Colors.white,
        );
      });
    } else {
      setState(() {
        textFieldwidth = 150;
        opacity = 1;
        sendOrEmoji = const Icon(
          Icons.thumb_up_alt,
          color: Colors.white,
        );
      });
      Future.delayed(const Duration(milliseconds: 200)).then(
        (_) {
          setState(() {
            isVisible = true;
          });
        },
      );
    }
  }
}

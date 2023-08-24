import 'package:facebook_basic_layout/controller/chat_controller.dart';
import 'package:facebook_basic_layout/controller/friend_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controller/user_service.dart';

class FriendListView extends StatelessWidget {
  const FriendListView({super.key});

  @override
  Widget build(BuildContext context) {
    UserService userService = context.watch<UserService>();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Friends',
              style: TextStyle(
                  fontSize: 20, color: Theme.of(context).primaryColor),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: ChangeNotifierProvider<FriendController>.value(
                value: FriendController(userService.currentUser),
                child: Consumer<FriendController>(
                  builder: (context, friends, child) => ListView(
                    children: friends.friends
                        .map((friend) => Container(
                              margin: const EdgeInsets.fromLTRB(0, 6, 0, 6),
                              child:
                                  ChangeNotifierProvider<ChatController>.value(
                                value: ChatController(),
                                child: Consumer<ChatController>(
                                  builder: (context, chatBox, child) =>
                                      ElevatedButton(
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                Colors.white)),
                                    onPressed: () {
                                      chatBox.showChatBox(friend);
                                    },
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(0, 8, 0, 8),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          CircleAvatar(
                                              backgroundImage:
                                                  AssetImage(friend.avatar),
                                              radius: 18),
                                          SizedBox(
                                              width: 100,
                                              child: Text(
                                                friend.name,
                                                style: TextStyle(
                                                    color: Theme.of(context)
                                                        .primaryColor),
                                              )),
                                          Icon(
                                            Icons.circle,
                                            size: 10,
                                            color: friend.status
                                                ? const Color.fromARGB(
                                                    255, 33, 226, 40)
                                                : const Color.fromARGB(
                                                    255, 166, 167, 166),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

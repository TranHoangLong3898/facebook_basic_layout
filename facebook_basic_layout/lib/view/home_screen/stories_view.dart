import 'package:facebook_basic_layout/controller/story_controller.dart';
import 'package:facebook_basic_layout/controller/user_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Stories extends StatelessWidget {
  const Stories({super.key});

  @override
  Widget build(BuildContext context) {
    UserService userService = context.watch<UserService>();
    final ScrollController scrollController = ScrollController();
    return SizedBox(
        height: 300,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Stories',
                style: TextStyle(
                    fontSize: 20, color: Theme.of(context).primaryColor),
              ),
              Expanded(
                child: ChangeNotifierProvider<StoryController>.value(
                    value: StoryController(userService.currentUser),
                    child: Consumer<StoryController>(
                      builder: (context, snapshot, child) => Stack(children: [
                        ListView(
                          controller: scrollController,
                          scrollDirection: Axis.horizontal,
                          children: snapshot.friends
                              .map((friend) => Container(
                                    margin:
                                        const EdgeInsets.fromLTRB(0, 5, 10, 10),
                                    child: Stack(children: [
                                      Card(
                                        elevation: 10,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          child: Image(
                                            image: AssetImage(
                                                friend.stories[0].img),
                                            height: 220,
                                            width: 140,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: 10,
                                        left: 10,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                                color: friend.status
                                                    ? Theme.of(context)
                                                        .primaryColor
                                                    : const Color.fromARGB(
                                                        255, 166, 167, 166),
                                                width: 3),
                                          ),
                                          child: CircleAvatar(
                                              backgroundImage:
                                                  AssetImage(friend.avatar),
                                              radius: 18),
                                        ),
                                      )
                                    ]),
                                  ))
                              .toList(),
                        ),
                        Positioned(
                            left: 0,
                            top: 110,
                            child: Visibility(
                              visible: !snapshot.isStart,
                              child: Opacity(
                                opacity: 0.7,
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                      minimumSize: MaterialStateProperty.all(
                                          const Size(0, 0)),
                                      padding: MaterialStateProperty.all(
                                          const EdgeInsets.fromLTRB(
                                              3, 10, 3, 10))),
                                  onPressed: () {
                                    scrollController.animateTo(
                                      scrollController.offset - 100,
                                      duration:
                                          const Duration(milliseconds: 500),
                                      curve: Curves.fastOutSlowIn,
                                    );
                                    snapshot.changeIsEnd(false);

                                    if (scrollController.offset - 100 <= 0) {
                                      snapshot.changeIsStart(true);
                                    } else {
                                      snapshot.changeIsStart(false);
                                    }
                                  },
                                  child: const Icon(Icons.navigate_before),
                                ),
                              ),
                            )),
                        Positioned(
                            right: 0,
                            top: 110,
                            child: Visibility(
                              visible: !snapshot.isEnd,
                              child: Opacity(
                                opacity: 0.7,
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                      minimumSize: MaterialStateProperty.all(
                                          const Size(0, 0)),
                                      padding: MaterialStateProperty.all(
                                          const EdgeInsets.fromLTRB(
                                              3, 10, 3, 10))),
                                  onPressed: () {
                                    scrollController.animateTo(
                                      scrollController.offset + 100,
                                      duration: const Duration(seconds: 1),
                                      curve: Curves.fastOutSlowIn,
                                    );
                                    snapshot.changeIsStart(false);
                                    if (scrollController.offset + 100 >=
                                        scrollController
                                            .position.maxScrollExtent) {
                                      snapshot.changeIsEnd(true);
                                    } else {
                                      snapshot.changeIsEnd(false);
                                    }
                                  },
                                  child: const Icon(Icons.navigate_next),
                                ),
                              ),
                            ))
                      ]),
                    )),
              ),
            ],
          ),
        ));
  }
}

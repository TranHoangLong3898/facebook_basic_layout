import 'package:facebook_basic_layout/view/home_screen/friend_list_view.dart';
import 'package:flutter/material.dart';
import '../chat_screen/chat_box_view.dart';
import 'navigation_list_view.dart';
import 'news_feed_view.dart';

class PageBody extends StatelessWidget {
  const PageBody({super.key});

  @override
  Widget build(BuildContext context) {
    double navigationBarWidth = MediaQuery.of(context).size.width * 0.35;
    navigationBarWidth = navigationBarWidth > 250 ? 250 : navigationBarWidth;
    return Container(
      child: MediaQuery.of(context).size.width < 550
          ? Container(
              color: Colors.white,
              child: const NewsFeed(),
            )
          : MediaQuery.of(context).size.width < 950
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      width: navigationBarWidth,
                      color: const Color.fromARGB(255, 200, 231, 236),
                      child: const NaviagtionList(),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width -
                          navigationBarWidth,
                      color: Colors.white,
                      child: const NewsFeed(),
                    ),
                  ],
                )
              : Stack(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Container(
                          width: navigationBarWidth,
                          color: const Color.fromARGB(255, 235, 235, 235),
                          child: const NaviagtionList(),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width < 1100
                              ? MediaQuery.of(context).size.width -
                                  2 * navigationBarWidth
                              : 600,
                          color: Colors.white,
                          child: const NewsFeed(),
                        ),
                        Container(
                          width: navigationBarWidth,
                          color: const Color.fromARGB(255, 235, 235, 235),
                          child: const FriendListView(),
                        )
                      ],
                    ),
                    Positioned(
                      right: navigationBarWidth,
                      bottom: 0,
                      child: ChatBox(navigationBarWidth),
                    ),
                  ],
                ),
    );
  }
}

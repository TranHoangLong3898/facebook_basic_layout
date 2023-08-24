import 'package:facebook_basic_layout/view/home_screen/post_view.dart';
import 'package:facebook_basic_layout/view/home_screen/stories_view.dart';
import 'package:flutter/material.dart';
import 'new_post/new_post_view.dart';

class NewsFeed extends StatelessWidget {
  const NewsFeed({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: MediaQuery.of(context).size.width < 950
          ? Stack(
              children: [
                Center(
                  child: ListView(
                    children: const [
                      NewPost(),
                      Stories(),
                      Posts(),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: FloatingActionButton(
                    onPressed: () {},
                    child: const Icon(Icons.message),
                  ),
                )
              ],
            )
          : ListView(
              children: const [
                NewPost(),
                Stories(),
                Posts(),
              ],
            ),
    );
  }
}

import 'package:facebook_basic_layout/controller/post_controller.dart';
import 'package:facebook_basic_layout/controller/user_service.dart';
import 'package:facebook_basic_layout/model/user_model.dart';
import 'package:facebook_basic_layout/model/user_post.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Posts extends StatefulWidget {
  const Posts({super.key});

  @override
  State<Posts> createState() => _PostsState();
}

class _PostsState extends State<Posts> {
  @override
  Widget build(BuildContext context) {
    UserService userService = context.watch<UserService>();
    return Padding(
      padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
      child: Container(
        color: Colors.white,
        child: ChangeNotifierProvider.value(
            value: PostController(userService.currentUser),
            child: Consumer<PostController>(
              builder: (context, postController, child) => Column(
                children: postController.listPost
                    .map((userPost) => Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          elevation: 10,
                          child: postMainContent(userPost, postController,
                              userService.currentUser),
                        ))
                    .toList(),
              ),
            )),
      ),
    );
  }

  Column postMainContent(
      UserPost userPost, PostController postController, FUser currentUser) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Stack(
            children: [
              CircleAvatar(
                backgroundImage: AssetImage(userPost.user.avatar),
                radius: 20,
              ),
              Positioned(left: 45, top: 10, child: Text(userPost.user.name)),
              Positioned(
                  right: 0,
                  child: MyMoreOptions(
                    userPost: userPost,
                    postController: postController,
                    currentUser: currentUser,
                  ))
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(userPost.post.content),
        ),
        Image.network(
          userPost.post.img,
          height: 400,
          fit: BoxFit.cover,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: userPost.post.likes.isNotEmpty
              ? Stack(
                  children: [
                    Icon(
                      Icons.thumb_up,
                      color: Theme.of(context).primaryColor,
                      size: 20,
                    ),
                    const Positioned(
                        left: 20,
                        child: Icon(
                          Icons.favorite,
                          color: Colors.red,
                          size: 20,
                        )),
                    Positioned(
                        left: 40,
                        child: Text(
                          userPost.post.likes.length.toString(),
                          style: const TextStyle(fontSize: 15),
                        )),
                  ],
                )
              : null,
        ),
        const Divider(
          color: Colors.grey,
          thickness: 1,
          height: 20,
          indent: 10,
          endIndent: 10,
        ),
        actionButton(postController, userPost)
      ],
    );
  }

  Padding actionButton(PostController postController, UserPost userPost) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 255, 255, 255)),
            onPressed: () {
              postController.like(userPost.post.id, userPost.user.id);
            },
            icon: userPost.post.likes
                    .contains(FirebaseAuth.instance.currentUser!.uid.toString())
                ? Icon(
                    Icons.thumb_up_alt,
                    color: Theme.of(context).primaryColor,
                  )
                : Icon(
                    Icons.thumb_up_alt_outlined,
                    color: Theme.of(context).primaryColor,
                  ),
            label: Text(
              'Like',
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 255, 255, 255)),
            onPressed: () {},
            icon: Icon(
              Icons.insert_comment,
              color: Theme.of(context).primaryColor,
            ),
            label: Text(
              'Comment',
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 255, 255, 255)),
            onPressed: () {},
            icon: Icon(
              Icons.share,
              color: Theme.of(context).primaryColor,
            ),
            label: Text(
              'Share',
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
          ),
        ],
      ),
    );
  }
}

class MyMoreOptions extends StatefulWidget {
  final UserPost userPost;
  final PostController postController;
  final FUser currentUser;
  const MyMoreOptions(
      {super.key,
      required this.userPost,
      required this.postController,
      required this.currentUser});

  @override
  State<MyMoreOptions> createState() => _MyMoreOptionsState();
}

class _MyMoreOptionsState extends State<MyMoreOptions> {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      itemBuilder: (BuildContext context) => [
        const PopupMenuItem(
          value: 1,
          child: Text('Save'),
        ),
        const PopupMenuItem(
          value: 2,
          child: Text('Report'),
        ),
        const PopupMenuItem(
          value: 3,
          child: Text('Delete'),
        ),
      ],
      onSelected: (int selectedValue) {
        if (selectedValue == 3) {
          widget.postController.delete(widget.userPost, widget.currentUser);
        }
      },
      icon: const Icon(Icons.more_horiz),
    );
  }
}

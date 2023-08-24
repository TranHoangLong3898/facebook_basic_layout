import 'dart:io';

import 'package:facebook_basic_layout/controller/new_post_service.dart';
import 'package:facebook_basic_layout/controller/user_service.dart';
import 'package:facebook_basic_layout/view/home_screen/new_post/new_post_mobile_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

import 'new_post_modal_view.dart';

class NewPost extends StatelessWidget {
  const NewPost({super.key});

  @override
  Widget build(BuildContext context) {
    final File postImg;
    UserService userService = context.watch<UserService>();
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 500),
      child: Card(
        margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
        color: const Color.fromARGB(255, 255, 255, 255),
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Create post',
                  style: TextStyle(
                      fontSize: 20, color: Theme.of(context).primaryColor),
                ),
              ),
              SizedBox(
                width: 450,
                height: 35,
                child: ElevatedButton(
                    style: ButtonStyle(
                        shape: MaterialStateProperty.all<OutlinedBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: BorderSide(
                                color: Theme.of(context).primaryColor),
                          ),
                        ),
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.white)),
                    onPressed: () {
                      if (kIsWeb) {
                        showModal(context, 'text');
                      } else {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NewPostMobileView(
                                type: 'text',
                              ),
                            ));
                      }
                    },
                    child: Text(
                      'What\'s in your mind? ${userService.currentUser.name.split(' ').last}',
                      style:
                          TextStyle(color: Theme.of(context).primaryColorLight),
                    )),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: MediaQuery.of(context).size.width > 580
                          ? ElevatedButton.icon(
                              onPressed: () {
                                if (kIsWeb) {
                                  showModal(context, 'camera');
                                } else {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => NewPostMobileView(
                                          type: 'camera',
                                        ),
                                      ));
                                }
                              },
                              icon: const Icon(
                                Icons.camera_alt,
                              ),
                              label: const Text('camera'),
                            )
                          : IconButton(
                              onPressed: () {
                                if (kIsWeb) {
                                  showModal(context, 'camera');
                                } else {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => NewPostMobileView(
                                          type: 'camera',
                                        ),
                                      ));
                                }
                              },
                              icon: const Icon(Icons.camera_alt),
                              color: Theme.of(context).primaryColor),
                    ),
                    MediaQuery.of(context).size.width > 580
                        ? ElevatedButton.icon(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.photo_camera_front,
                            ),
                            label: const Text('Live'),
                          )
                        : IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.photo_camera_front),
                            color: Theme.of(context).primaryColor),
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.emoji_emotions),
                        color: Theme.of(context).primaryColor),
                    IconButton(
                      onPressed: () {
                        if (kIsWeb) {
                          showModal(context, 'gallery');
                        } else {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const NewPostMobileView(type: 'gallery'),
                              ));
                        }
                      },
                      icon: const Icon(Icons.photo_size_select_actual),
                      color: Theme.of(context).primaryColor,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showModal(BuildContext context, String type) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).primaryColor,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: (Radius.circular(38)),
                topRight: (Radius.circular(4)),
                bottomLeft: (Radius.circular(4)),
                bottomRight: (Radius.circular(38))),
          ),
          title: Stack(
            alignment: AlignmentDirectional.topCenter,
            children: [
              const Text(
                'Create Post',
                style: TextStyle(color: Colors.white),
              ),
              Positioned(
                right: 0,
                child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                    )),
              )
            ],
          ),
          contentPadding: const EdgeInsets.all(8),
          content: MyModal(type: type),
          titlePadding: const EdgeInsets.fromLTRB(8, 8, 0, 8),
        );
      },
    );
  }
}

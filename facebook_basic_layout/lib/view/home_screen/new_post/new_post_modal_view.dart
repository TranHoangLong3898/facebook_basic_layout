import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../controller/new_post_service.dart';
import '../../../controller/user_service.dart';

class MyModal extends StatefulWidget {
  final String type;
  const MyModal({super.key, required this.type});

  @override
  State<MyModal> createState() => _MyModalState();
}

class _MyModalState extends State<MyModal> {
  XFile? postImg;
  List<XFile>? listImage;
  @override
  Widget build(BuildContext context) {
    UserService userService = context.watch<UserService>();

    getImage(String type) async {
      final source =
          type == 'camera' ? ImageSource.camera : ImageSource.gallery;
      // await ImagePicker().pickMultiImage().then(
      //   (value) {
      //     listImage = value;
      //   },
      // ).onError((error, stackTrace) {
      //   log(error.toString());
      // });
      await ImagePicker().pickImage(source: source).then((value) {
        if (value != null) {
          setState(() {
            postImg = value;
          });
        }
      }).onError((error, stackTrace) {
        print(error);
      });
    }

    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: (Radius.circular(30)),
            topRight: (Radius.circular(4)),
            bottomLeft: (Radius.circular(4)),
            bottomRight: (Radius.circular(30))),
        color: Colors.white,
      ),
      width: 500,
      height: postImg == null ? 350 : 500,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage(userService.currentUser.avatar),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      userService.currentUser.name,
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  TextField(
                    style: TextStyle(
                        fontSize: widget.type == 'text' ? 20 : 15,
                        color: Theme.of(context).primaryColor),
                    controller: NewPostService.content,
                    maxLines: null,
                    decoration: InputDecoration(
                      hintText:
                          'What\'s in your mind? ${userService.currentUser.name.split(' ').last}',
                      hintStyle: TextStyle(
                          color: Theme.of(context).primaryColorLight,
                          fontSize: 20),
                    ),
                  ),
                  Visibility(
                    visible: widget.type != 'text',
                    child: SizedBox(
                        width: 400,
                        height: postImg == null ? 200 : 400,
                        child: postImg == null
                            ? ElevatedButton(
                                onPressed: () {
                                  getImage(widget.type);
                                },
                                child: widget.type == 'gallery'
                                    ? const Icon(
                                        Icons.add_photo_alternate_outlined)
                                    : const Icon(Icons.add_a_photo_outlined))
                            : kIsWeb
                                ? Image.network(postImg!.path)
                                : Image.file(postImg! as File)),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 500,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                child: ElevatedButton(
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: (Radius.circular(4)),
                                  bottomLeft: (Radius.circular(4)),
                                  bottomRight: (Radius.circular(30)))))),
                  onPressed: () async {
                    NewPostService.createNewPost(NewPostService.content.text,
                        postImg!, userService.currentUser.id);
                    Navigator.of(context).pop();
                  },
                  child: const Text('Post'),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

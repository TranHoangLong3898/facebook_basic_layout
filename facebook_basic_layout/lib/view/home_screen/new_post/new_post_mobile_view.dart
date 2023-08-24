import 'package:facebook_basic_layout/view/home_screen/new_post/new_post_modal_view.dart';
import 'package:flutter/material.dart';

class NewPostMobileView extends StatelessWidget {
  final String type;
  const NewPostMobileView({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: const Text(
          'Create Post',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: MyModal(type: type),
    ));
  }
}

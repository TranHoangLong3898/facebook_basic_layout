import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class NewPostService {
  static TextEditingController content = TextEditingController(text: "");

  static Future<void> createNewPost(
      String content, XFile img, String id) async {
    Reference storeRef = FirebaseStorage.instance.ref();
    Uint8List image = await img.readAsBytes();
    String imgName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference userPostsRef = storeRef.child('users/$id/posts');
    Reference imgTestRef = userPostsRef.child(imgName);
    SettableMetadata metadata = SettableMetadata(contentType: 'image/jpg');
    if (content != '' && img.path != '') {
      try {
        await imgTestRef.putData(image, metadata);
        await imgTestRef.getDownloadURL().then((url) async {
          dynamic post = {'img': url, 'content': content};
          final HttpsCallable callable =
              FirebaseFunctions.instance.httpsCallable('createNewPost');
          try {
            await callable.call(post);
          } catch (e) {
            print(e);
          }
        });
      } catch (e) {
        print(e);
      }
    }
  }
}

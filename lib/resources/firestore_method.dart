import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:insta/models/post.dart';
import 'package:insta/resources/storage_method.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethod {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> uploadPost({
    required String caption,
    required Uint8List file,
    required String uid,
    required String userName,
    required String photoImage,
  }) async {
    String res = "Error Occured";
    try {
      String photoUrl = await StorageMethod().uploadImageToStorage(
        "Posts",
        file,
        true,
      );
      String postId = Uuid().v1();
      Post post = Post(
        caption: caption,
        uid: uid,
        UserName: userName,
        postId: postId,
        datePublished: DateTime.now(),
        photoImage: photoImage,
        photoUrl: photoUrl,
        likes: [],
      );
      await _firestore.collection("posts").doc(postId).set(post.toJson());
      res = "Success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
}

import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:insta/models/post.dart';
import 'package:insta/resources/storage_method.dart';
import 'package:insta/utils/utils.dart';
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
        userName: userName,
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

  Future<void> likePost(
    String postId,
    String uid,
    List likes,
    BuildContext context,
  ) async {
    try {
      if (likes.contains(uid)) {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid]),
        });
      } else {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid]),
        });
      }
    } catch (e) {
      if (!context.mounted) return;
      showSnackbar(context, e.toString());
    }
  }

  Future<void> postComment(
    String postId,
    String text,
    String uid,
    String name,
    String profilePic,
    BuildContext context,
  ) async {
    try {
      if (text.isNotEmpty) {
        String commentId = Uuid().v1();
        await _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set({
              'profilePic': profilePic,
              'username': name,
              'uid': uid,
              'text': text,
              'commentid': commentId,
              'datepublished': DateTime.now(),
            });
      } else {
        showSnackbar(context, "Comment is Empty");
      }
    } catch (e) {
      if (!context.mounted) return;
      showSnackbar(context, e.toString());
    }
  }

  Future<void> deletePost(String postId, BuildContext context) async {
    try {
      await _firestore
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .doc()
          .delete();
      await _firestore.collection('posts').doc(postId).delete();
    } catch (e) {
      if (!context.mounted) return;
      showSnackbar(context, e.toString());
    }
  }

  Future<void> followUser(
    String uid,
    String followId,
    BuildContext context,
  ) async {
    try {
      DocumentSnapshot snap = await _firestore
          .collection("users")
          .doc(uid)
          .get();
      List following = (snap.data()! as dynamic)['following'];
      if (following.contains(followId)) {
        await _firestore.collection("users").doc(followId).update({
          'followers': FieldValue.arrayRemove([uid]),
        });
        await _firestore.collection("users").doc(uid).update({
          'following': FieldValue.arrayRemove([followId]),
        });
      } else {
        await _firestore.collection("users").doc(followId).update({
          'followers': FieldValue.arrayUnion([uid]),
        });
        await _firestore.collection("users").doc(uid).update({
          'following': FieldValue.arrayUnion([followId]),
        });
      }
    } catch (e) {
      showSnackbar(context, e.toString());
    }
  }
}

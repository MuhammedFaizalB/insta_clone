import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String caption;
  final String uid;
  final String UserName;
  final String postId;
  final DateTime datePublished;
  final String photoImage;
  final String photoUrl;
  final likes;

  const Post({
    required this.caption,
    required this.uid,
    required this.UserName,
    required this.postId,
    required this.datePublished,
    required this.photoImage,
    required this.photoUrl,
    required this.likes,
  });

  Map<String, dynamic> toJson() => {
    "caption": caption,
    "uid": uid,
    "username": UserName,
    "postid": postId,
    "datepublished": datePublished,
    "photoImage": photoImage,
    "photoUrl": photoUrl,
    "likes": likes,
  };

  static Post fromSnap(DocumentSnapshot snap) {
    var snapShot = snap.data() as Map<String, dynamic>;

    return Post(
      caption: snapShot['caption'],
      uid: snapShot['uid'],
      UserName: snapShot['username'],
      postId: snapShot['postid'],
      datePublished: snapShot['datepublished'],
      photoImage: snapShot["photoImage"],
      photoUrl: snapShot['photoUrl'],
      likes: snapShot['likes'],
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String userName;
  final String uid;
  final String email;
  final String bio;
  final List followers;
  final List following;
  final String photoUrl;

  const User({
    required this.userName,
    required this.uid,
    required this.email,
    required this.bio,
    required this.followers,
    required this.following,
    required this.photoUrl,
  });

  static User fromSnap(DocumentSnapshot snap) {
    var snapShot = snap.data() as Map<String, dynamic>;

    return User(
      userName: snapShot['username'],
      uid: snapShot['uid'],
      email: snapShot['email'],
      bio: snapShot['bio'],
      followers: snapShot["followers"],
      following: snapShot["following"],
      photoUrl: snapShot['photoUrl'],
    );
  }

  Map<String, dynamic> toJson() => {
    "username": userName,
    "uid": uid,
    "email": email,
    "bio": bio,
    "followers": followers,
    "following": following,
    "photoUrl": photoUrl,
  };
}

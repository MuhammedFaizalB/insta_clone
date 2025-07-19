import 'dart:typed_data';
import 'package:insta/models/user.dart' as model;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:insta/resources/storage_method.dart';

class AuthMethod {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot snap = await _firestore
        .collection("users")
        .doc(currentUser.uid)
        .get();

    return model.User.fromSnap(snap);
  }

  Future<String> signUpUser({
    required String userName,
    required String email,
    required String password,
    required String bio,
    required Uint8List file,
  }) async {
    String res = "An Error Occuured";
    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          userName.isNotEmpty ||
          bio.isNotEmpty) {
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        String photoUrl = await StorageMethod().uploadImageToStorage(
          "ProfilePics",
          file,
          false,
        );

        model.User user = model.User(
          userName: userName,
          uid: cred.user!.uid,
          email: email,
          bio: bio,
          followers: [],
          following: [],
          photoUrl: photoUrl,
        );

        await _firestore
            .collection("users")
            .doc(cred.user!.uid)
            .set(user.toJson());
        res = "Success";
      }
    } on FirebaseAuthException catch (err) {
      res = err.message.toString();
    }
    return res;
  }

  Future<String> logInUser({
    required String email,
    required String password,
  }) async {
    String res = "An Error Occured";
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        res = "Success";
      } else {
        res = "Please Fill all the fiels";
      }
    } on FirebaseAuthException catch (err) {
      res = err.message.toString();
    }
    return res;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}

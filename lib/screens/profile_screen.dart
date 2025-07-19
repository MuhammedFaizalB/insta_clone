import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:insta/resources/auth_method.dart';
import 'package:insta/resources/firestore_method.dart';
import 'package:insta/screens/login_screen.dart';
import 'package:insta/utils/colors.dart';
import 'package:insta/utils/utils.dart';
import 'package:insta/widgets/follow_button.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({super.key, required this.uid});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var userData = {};
  int postLen = 0;
  bool isFollowing = false;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();

      var postSnap = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: widget.uid)
          .get();
      userData = userSnap.data()!;
      postLen = postSnap.docs.length;
      isFollowing = userData['followers'].contains(
        FirebaseAuth.instance.currentUser!.uid,
      );
      setState(() {});
    } catch (e) {
      showSnackbar(context, e.toString());
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(child: CircularProgressIndicator())
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              title: Text(userData['username']),
              centerTitle: false,
            ),
            body: ListView(
              children: [
                Padding(
                  padding: EdgeInsets.all(18),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage(userData['photoUrl']),
                            radius: 40,
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    buildStatColumn(postLen, 'Posts'),
                                    buildStatColumn(
                                      userData['followers'].length,
                                      'Followers',
                                    ),
                                    buildStatColumn(
                                      userData['following'].length,
                                      'Followings',
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 15.0),
                                  child: Row(
                                    children: [
                                      FirebaseAuth.instance.currentUser!.uid ==
                                              widget.uid
                                          ? FollowButton(
                                              backgroundColor:
                                                  mobileBackgroundColor,
                                              text: "Sign Out",
                                              textColor: primaryColor,
                                              borderColor: Colors.grey,
                                              onFunction: () async {
                                                await AuthMethod().signOut();
                                                Navigator.of(
                                                  context,
                                                ).pushReplacement(
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        LoginScreen(),
                                                  ),
                                                );
                                              },
                                            )
                                          : isFollowing
                                          ? FollowButton(
                                              backgroundColor: Colors.white,
                                              text: "UnFollow",
                                              textColor: Colors.black,
                                              borderColor: Colors.grey,
                                              onFunction: () async {
                                                await FirestoreMethod()
                                                    .followUser(
                                                      FirebaseAuth
                                                          .instance
                                                          .currentUser!
                                                          .uid,
                                                      userData['uid'],
                                                      context,
                                                    );
                                                setState(() {
                                                  isFollowing = false;
                                                });
                                              },
                                            )
                                          : FollowButton(
                                              backgroundColor: Colors.blue,
                                              text: "Follow",
                                              textColor: primaryColor,
                                              borderColor: Colors.grey,
                                              onFunction: () async {
                                                await FirestoreMethod()
                                                    .followUser(
                                                      FirebaseAuth
                                                          .instance
                                                          .currentUser!
                                                          .uid,
                                                      userData['uid'],
                                                      context,
                                                    );
                                                setState(() {
                                                  isFollowing = true;
                                                });
                                              },
                                            ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(top: 10),
                        child: Text(
                          userData['username'],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(top: 2),
                        child: Text(userData['bio']),
                      ),
                    ],
                  ),
                ),
                const Divider(),
                FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection('posts')
                      .where('uid', isEqualTo: widget.uid)
                      .get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    return GridView.builder(
                      shrinkWrap: true,
                      itemCount: (snapshot.data! as dynamic).docs.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 1.5,
                        crossAxisSpacing: 5,
                        childAspectRatio: 1,
                      ),
                      itemBuilder: (context, index) {
                        DocumentSnapshot snap =
                            (snapshot.data! as dynamic).docs[index];
                        return Container(
                          child: Image(
                            image: NetworkImage(snap['photoImage']),
                            fit: BoxFit.cover,
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          );
  }

  Column buildStatColumn(int num, String text) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          num.toString(),
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 2),
        Text(text, style: TextStyle(fontSize: 15, color: Colors.grey)),
      ],
    );
  }
}

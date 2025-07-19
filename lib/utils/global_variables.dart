import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:insta/screens/add_post_screen.dart';
import 'package:insta/screens/feed_screen.dart';
import 'package:insta/screens/profile_screen.dart';
import 'package:insta/screens/search_screen.dart';

const webScreenSize = 600;

final homeScreenItems = [
  const FeedScreen(),
  const SearchScreen(),
  const AddPostScreen(),
  const Center(child: Text("No New Notifications")),
  ProfileScreen(uid: FirebaseAuth.instance.currentUser!.uid),
];

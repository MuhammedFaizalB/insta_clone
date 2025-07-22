import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:insta/models/user.dart';
import 'package:insta/providers/user_provider.dart';
import 'package:insta/resources/firestore_method.dart';
import 'package:insta/screens/comment_screen.dart';
import 'package:insta/utils/colors.dart';
import 'package:insta/utils/global_variables.dart';
import 'package:insta/utils/utils.dart';
import 'package:insta/widgets/like_animation.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PostCard extends StatefulWidget {
  final snap;
  const PostCard({super.key, required this.snap});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  int commentCount = 0;
  bool isLikeAnimation = false;

  @override
  void initState() {
    super.initState();
    getCommentLen();
  }

  void getCommentLen() async {
    try {
      QuerySnapshot snaps = await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.snap['postid'])
          .collection('comments')
          .get();

      commentCount = snaps.docs.length;
    } catch (e) {
      showSnackbar(context, e.toString());
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;
    final width = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      color: mobileBackgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              spacing: 15,
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(widget.snap['photoUrl']),
                ),

                Text(
                  widget.snap['username'],
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                ),

                Spacer(),
                widget.snap['uid'].toString() == user.uid
                    ? IconButton(
                        onPressed: () {
                          showDialog(
                            useRootNavigator: false,
                            context: context,
                            builder: (context) {
                              return Dialog(
                                child: ListView(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  shrinkWrap: true,
                                  children: ['Delete']
                                      .map(
                                        (e) => InkWell(
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 12,
                                              horizontal: 16,
                                            ),
                                            child: Text(e),
                                          ),
                                          onTap: () {
                                            FirestoreMethod().deletePost(
                                              widget.snap['postid'],
                                              context,
                                            );
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      )
                                      .toList(),
                                ),
                              );
                            },
                          );
                        },
                        icon: const Icon(Icons.more_vert),
                      )
                    : Container(),
              ],
            ),
          ),
          SizedBox(height: 8),
          GestureDetector(
            onDoubleTap: () async {
              setState(() {
                isLikeAnimation = true;
              });
              await FirestoreMethod().likePost(
                widget.snap['postid'],
                user.uid,
                widget.snap['likes'],
                context,
              );
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: width > webScreenSize ? width * .3 : width * 1,
                  width: double.infinity,
                  child: Image.network(
                    widget.snap['photoImage'],
                    fit: BoxFit.cover,
                  ),
                ),
                AnimatedOpacity(
                  duration: Duration(milliseconds: 150),
                  opacity: isLikeAnimation ? 1 : 0,
                  child: LikeAnimation(
                    isAnimation: isLikeAnimation,
                    duration: const Duration(milliseconds: 400),
                    onEnd: () {
                      setState(() {
                        isLikeAnimation = false;
                      });
                    },
                    child: Icon(Icons.favorite, color: Colors.red, size: 120),
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              LikeAnimation(
                isAnimation: widget.snap['likes'].contains(user.uid),
                smallLike: true,
                child: IconButton(
                  onPressed: () async {
                    await FirestoreMethod().likePost(
                      widget.snap['postid'],
                      user.uid,
                      widget.snap['likes'],
                      context,
                    );
                  },
                  icon: widget.snap['likes'].contains(user.uid)
                      ? Icon(Icons.favorite, color: Colors.red)
                      : Icon(Icons.favorite_border),
                ),
              ),
              IconButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        CommentScreen(postId: widget.snap['postid'].toString()),
                  ),
                ),
                icon: Icon(Icons.comment),
              ),
              IconButton(onPressed: () {}, icon: Icon(Icons.send_rounded)),
              Spacer(),
              IconButton(onPressed: () {}, icon: Icon(Icons.bookmark_border)),
            ],
          ),

          Container(
            padding: EdgeInsetsDirectional.symmetric(
              horizontal: 14,
              vertical: 4,
            ),
            child: Text(
              "${widget.snap['likes'].length} Likes",
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: widget.snap['username'],
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),

                  TextSpan(text: '   ${widget.snap['caption']}'),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            child: Text(
              "view $commentCount comments",
              style: TextStyle(color: secondaryColor, fontSize: 16),
            ),
          ),
          Padding(
            padding: EdgeInsetsGeometry.symmetric(horizontal: 14),
            child: Text(
              DateFormat.yMMMMEEEEd().format(
                widget.snap['datepublished'].toDate(),
              ),
              style: TextStyle(color: secondaryColor, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}

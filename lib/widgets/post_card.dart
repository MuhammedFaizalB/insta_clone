import 'package:flutter/material.dart';
import 'package:insta/utils/colors.dart';
import 'package:intl/intl.dart';

class PostCard extends StatelessWidget {
  final snap;
  const PostCard({super.key, required this.snap});

  @override
  Widget build(BuildContext context) {
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
                CircleAvatar(backgroundImage: NetworkImage(snap['photoUrl'])),

                Text(
                  snap['username'],
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                ),

                Spacer(),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.more_vert_outlined),
                ),
              ],
            ),
          ),
          SizedBox(height: 8),
          SizedBox(
            height: MediaQuery.of(context).size.width * 1,
            width: double.infinity,
            child: Image.network(snap['photoImage'], fit: BoxFit.cover),
          ),
          Row(
            children: [
              IconButton(onPressed: () {}, icon: Icon(Icons.favorite_border)),
              IconButton(onPressed: () {}, icon: Icon(Icons.comment)),
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
              "${snap['likes'].length} Likes",
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: snap['username'],
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),

                  TextSpan(text: '   ${snap['caption']}'),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            child: Text(
              "View 200 comments ",
              style: TextStyle(color: secondaryColor, fontSize: 16),
            ),
          ),
          Padding(
            padding: EdgeInsetsGeometry.symmetric(horizontal: 14),
            child: Text(
              DateFormat.yMMMMEEEEd().format(snap['datepublished'].toDate()),
              style: TextStyle(color: secondaryColor, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}

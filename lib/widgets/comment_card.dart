import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CommentCard extends StatefulWidget {
  final snap;
  const CommentCard({super.key, required this.snap});

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      child: Row(
        spacing: 17,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(widget.snap['profilePic']),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: widget.snap['username'],
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(text: "      ${widget.snap['text']}"),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 4),
                child: Text(
                  DateFormat.Hm().format(widget.snap['datepublished'].toDate()),
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
          Spacer(),
          Icon(Icons.favorite_border),
        ],
      ),
    );
  }
}

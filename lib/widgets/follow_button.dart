import 'package:flutter/material.dart';

class FollowButton extends StatelessWidget {
  final Function()? onFunction;
  final Color backgroundColor;
  final String text;
  final Color borderColor;
  final Color textColor;
  const FollowButton({
    super.key,
    this.onFunction,
    required this.backgroundColor,
    required this.text,
    required this.borderColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 8),
      child: TextButton(
        onPressed: onFunction,
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            border: Border.all(color: borderColor),
            borderRadius: BorderRadius.circular(5),
          ),
          alignment: Alignment.center,
          width: 250,
          height: 27,
          child: Text(
            text,
            style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}

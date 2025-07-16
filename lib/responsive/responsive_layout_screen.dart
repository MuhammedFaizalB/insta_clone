import 'package:flutter/material.dart';
import 'package:insta/providers/user_provider.dart';
import 'package:insta/utils/global_variables.dart';
import 'package:provider/provider.dart';

class ResponsiveLayoutScreen extends StatefulWidget {
  final Widget webScreenLayout;
  final Widget mobileScreenLayout;
  const ResponsiveLayoutScreen({
    super.key,
    required this.webScreenLayout,
    required this.mobileScreenLayout,
  });

  @override
  State<ResponsiveLayoutScreen> createState() => _ResponsiveLayoutScreenState();
}

class _ResponsiveLayoutScreenState extends State<ResponsiveLayoutScreen> {
  @override
  void initState() {
    super.initState();
    addData();
  }

  void addData() async {
    UserProvider userProvider = Provider.of<UserProvider>(
      context,
      listen: false,
    );
    await userProvider.refreshUser();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > webScreenSize) {
          return widget.webScreenLayout;
        }
        return widget.mobileScreenLayout;
      },
    );
  }
}

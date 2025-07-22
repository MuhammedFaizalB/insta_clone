import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:insta/utils/colors.dart';
import 'package:insta/utils/global_variables.dart';

class WebScreenLayout extends StatefulWidget {
  const WebScreenLayout({super.key});

  @override
  State<WebScreenLayout> createState() => _WebScreenLayoutState();
}

class _WebScreenLayoutState extends State<WebScreenLayout> {
  late PageController pageController;
  int index = 0;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  void onPageChanged(int page) {
    setState(() {
      index = page;
    });
  }

  void navigationTap(int page) {
    pageController.jumpToPage(page);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        centerTitle: false,
        title: SvgPicture.asset(
          'assets/ic_instagram.svg',
          color: primaryColor,
          height: 32,
        ),
        actions: [
          IconButton(
            onPressed: () => navigationTap(0),
            icon: Icon(Icons.home),
            color: index == 0 ? primaryColor : secondaryColor,
          ),
          IconButton(
            onPressed: () => navigationTap(1),
            icon: Icon(Icons.search),
            color: index == 1 ? primaryColor : secondaryColor,
          ),
          IconButton(
            onPressed: () => navigationTap(2),
            icon: Icon(Icons.add_box_outlined),
            color: index == 2 ? primaryColor : secondaryColor,
          ),
          IconButton(
            onPressed: () => navigationTap(3),
            icon: Icon(Icons.favorite),
            color: index == 3 ? primaryColor : secondaryColor,
          ),
          IconButton(
            onPressed: () => navigationTap(4),
            icon: Icon(Icons.person),
            color: index == 4 ? primaryColor : secondaryColor,
          ),
        ],
      ),
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: pageController,
        onPageChanged: onPageChanged,
        children: homeScreenItems,
      ),
    );
  }
}

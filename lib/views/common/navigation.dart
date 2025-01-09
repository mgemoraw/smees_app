import 'package:flutter/material.dart';

class SBottomNavBar extends StatefulWidget {
  const SBottomNavBar({super.key});

  @override
  State<SBottomNavBar> createState() => _SBottomNavBarState();
}

class _SBottomNavBarState extends State<SBottomNavBar> {
  int pageIndex = 0;
  String? pageKey = "home";

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 60,
        decoration: const BoxDecoration(
          // color: Theme.of(context).primaryColor,
          color: Colors.white10,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              enableFeedback: true,
              tooltip: 'Home',
              onPressed: () {
                setState(() {
                  pageIndex = 0;
                  pageKey = 'home';
                });
              },
              icon: pageIndex == 0
                  ? const Icon(
                      Icons.home_outlined,
                      color: Colors.green,
                      size: 35,
                    )
                  : const Icon(
                      Icons.home_outlined,
                      color: Colors.black54,
                      size: 35,
                    ),
            ),
            IconButton(
              enableFeedback: false,
              tooltip: 'Learn Zone',
              onPressed: () {
                setState(() {
                  pageIndex = 1;
                  pageKey = 'learn';
                });
              },
              icon: pageIndex == 1
                  ? const Icon(
                      Icons.menu_book_outlined,
                      color: Colors.green,
                      size: 35,
                    )
                  : const Icon(
                      Icons.menu_book_outlined,
                      color: Colors.black54,
                      size: 35,
                    ),
            ),
            IconButton(
                enableFeedback: false,
                tooltip: 'Statistics',
                onPressed: () {
                  setState(() {
                    pageIndex = 2;
                    pageKey = 'userstat';
                  });
                },
                icon: pageIndex == 2
                    ? const Icon(
                        Icons.bar_chart,
                        color: Colors.green,
                        size: 35,
                      )
                    : const Icon(
                        Icons.bar_chart,
                        color: Colors.black54,
                        size: 35,
                      )),
            IconButton(
              enableFeedback: false,
              tooltip: "Profile",
              onPressed: () {
                setState(() {
                  pageIndex = 3;
                  pageKey = 'profile';
                });
              },
              icon: pageIndex == 3
                  ? const Icon(
                      Icons.person_outline,
                      color: Colors.green,
                      size: 35,
                    )
                  : const Icon(
                      Icons.person_outline,
                      color: Colors.black54,
                      size: 35,
                    ),
            ),
          ],
        ));
  }
}

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavBar(
      {super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      items: const [
        BottomNavigationBarItem(
          activeIcon: Icon(
            Icons.home,
            color: Colors.green,
          ),
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          activeIcon: Icon(
            Icons.dashboard,
            color: Colors.green,
          ),
          icon: Icon(Icons.dashboard),
          label: 'Statistics',
        ),
        BottomNavigationBarItem(
          activeIcon: Icon(
            Icons.group,
            color: Colors.green,
          ),
          icon: Icon(Icons.group),
          label: 'Profile',
        ),
      ],
    );
  }
}

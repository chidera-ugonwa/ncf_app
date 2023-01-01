import 'package:flutter/material.dart';
import 'package:myapp/screens/account/account.dart';
import 'package:myapp/screens/give/give.dart';
import 'package:myapp/screens/library/library.dart';
import 'package:myapp/screens/meet/meet.dart';
import 'package:myapp/screens/scripture/scripture.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final PageController controller =
      PageController(); //initialize controller for pageview

  int _selectedIndex = 0;
  final tree = [
    const Library(),
    const Scripture(),
    const Meet(),
    const Give(),
    Account(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
          controller: controller,
          children: tree,
          onPageChanged: (index) {
            setState(() {
              _selectedIndex = index;

              /// Switching bottom tabs
            });
          }),
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey.shade600,
        showUnselectedLabels: true,
        currentIndex: _selectedIndex,
        onTap: (index) {
          controller.jumpToPage(index);

          /// Switching the PageView tabs
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.library_books_outlined),
            label: "Library",
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.menu_book_outlined), label: "Scripture"),
          BottomNavigationBarItem(
              icon: Icon(Icons.voice_chat_outlined), label: 'Meet'),
          BottomNavigationBarItem(
              icon: Icon(Icons.money_outlined), label: 'Give'),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle_outlined), label: 'Account')
        ],
      ),
    );
  }
}

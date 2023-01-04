import 'package:flutter/material.dart';
import 'package:myapp/screens/library/videos/videos_page.dart';
import 'package:myapp/screens/library/audios/audio_screen.dart';
import 'package:myapp/screens/library/books/book_screen.dart';

class Library extends StatefulWidget {
  const Library({Key? key}) : super(key: key);

  @override
  State<Library> createState() => _LibraryState();
}

class _LibraryState extends State<Library> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            bottom: const TabBar(
              tabs: [
                Tab(text: 'Videos'),
                Tab(text: 'Audio'),
                Tab(text: 'Books'),
              ],
            ),
            title: const Text('Library'),
            backgroundColor: Colors.blue[800],
          ),
          body: const TabBarView(
            children: [VideoPage(), AudioScreen(), BookScreen()],
          ),
        ),
      ),
    );
  }
}

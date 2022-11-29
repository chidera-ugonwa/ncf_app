import 'package:flutter/material.dart';
import 'package:myapp/screens/library/Videos/videos_page.dart';
import 'package:myapp/screens/library/Audios/audio_screen.dart';
import 'package:myapp/screens/library/Downloads/downloads_screen.dart';

class Library extends StatefulWidget {
  const Library({Key? key}) : super(key: key);

  @override
  State<Library> createState() => _LibraryState();
}

class _LibraryState extends State<Library> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            bottom: const TabBar(
              tabs: [
                Tab(text: 'Videos'),
                Tab(text: 'Audio'),
                Tab(text: 'Download'),
              ],
            ),
            title: const Text('Library'),
            backgroundColor: Colors.blue[800],
          ),
          body: const TabBarView(
            children: [VideoPage(), AudioScreen(), DownloadScreen()],
          ),
        ),
      ),
    );
  }
}

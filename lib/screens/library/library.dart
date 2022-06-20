import 'package:flutter/material.dart';
import 'package:vimeo_video_player/vimeo_video_player.dart';

class Library extends StatefulWidget {
  const Library({Key? key}) : super(key: key);

  @override
  State<Library> createState() => _LibraryState();
}

class _LibraryState extends State<Library> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        backgroundColor: Colors.grey,
        body: SafeArea(
          child: VimeoVideoPlayer(
            url: 'https://vimeo.com/722028980',
          ),
        ));
  }
}

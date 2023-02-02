import 'package:flutter/material.dart';
import 'package:myapp/screens/library/videos/videos_list.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoPlayer extends StatefulWidget {
  //
  const VideoPlayer({Key? key, required this.videoItem}) : super(key: key);
  final VideoItem videoItem;
  @override
  State<VideoPlayer> createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  //
  late YoutubePlayerController _controller;
  late bool _isPlayerReady;
  @override
  void initState() {
    super.initState();
    _isPlayerReady = false;
    _controller = YoutubePlayerController(
      initialVideoId: widget.videoItem.video.resourceId.videoId,
      flags: const YoutubePlayerFlags(
        mute: false,
        autoPlay: true,
      ),
    )..addListener(_listener);
  }

  void _listener() {
    if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
      //
    }
  }

  @override
  void deactivate() {
    _controller.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: const Text('Video'), backgroundColor: Colors.blue[800]),
      body: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              YoutubePlayer(
                controller: _controller,
                showVideoProgressIndicator: true,
                onReady: () {
                  debugPrint('Player is ready.');
                  _isPlayerReady = true;
                },
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(8.0),
                child: Text(widget.videoItem.video.title,
                    style: const TextStyle(fontSize: 24)),
              ),
              const Divider(thickness: 2.0, color: Colors.black),
              Container(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: const Text('Published At: ',
                      style: TextStyle(fontSize: 17))),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(widget.videoItem.video.publishedAt.toString(),
                    style: const TextStyle(fontSize: 17)),
              ),
              const Divider(thickness: 2.0, color: Colors.black),
              Container(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: const Text('Description: ',
                      style: TextStyle(fontSize: 17))),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(widget.videoItem.video.description,
                    style: const TextStyle(fontSize: 17)),
              )
            ],
          ),
        ),
      ),
    );
  }
}

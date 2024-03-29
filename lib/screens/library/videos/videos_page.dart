import 'package:flutter/material.dart';
import 'package:myapp/screens/library/videos/videos_list.dart';
import 'package:myapp/screens/library/videos/services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:myapp/screens/library/videos/video_player_screen.dart';

class VideoPage extends StatefulWidget {
  const VideoPage({Key? key}) : super(key: key);

  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage>
    with AutomaticKeepAliveClientMixin {
  dynamic _videoList;
  int _playList = 0;
  final String _playlistId = 'PLuX81RZk5-3Ys_CW7YE5SRTk9tVrLp0f_';
  dynamic _nextPageToken = '';
  dynamic _scrollController;
  bool isLoading = true;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _videoList = VideoList(
      kind: '',
      videos: [],
      pageInfo: [],
      etag: '',
      nextPageToken: '',
    );
    _loadPlaylist();
    _loadVideos();
    _scrollController = ScrollController();
  }

  retry() {
    _loadVideos();
  }

  _loadVideos() async {
    try {
      VideoList tempVideosList = await Services.getVideosList(
        playlistId: _playlistId,
        pageToken: _nextPageToken,
      );
      _nextPageToken = tempVideosList.nextPageToken;
      _videoList.videos.addAll(tempVideosList.videos);
      setState(() => isLoading = false);
    } catch (e) {
      retry();
    }
  }

  Future<List> _loadPlaylist() async {
    List tempPlaylist = await Services.getPlayList(
        playlistId: 'PLuX81RZk5-3Ys_CW7YE5SRTk9tVrLp0f_');
    final contentDetails = tempPlaylist[0]["contentDetails"];
    final itemCount = contentDetails["itemCount"];
    setState(() => _playList = itemCount);

    return tempPlaylist;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Container(
                color: Colors.white,
                child: Column(children: [
                  Expanded(
                    child: NotificationListener<ScrollEndNotification>(
                      onNotification: (ScrollNotification notification) {
                        if (_videoList.videos.length >= _playList) {
                          return true;
                        }
                        if (notification.metrics.pixels ==
                            notification.metrics.maxScrollExtent) {
                          _loadVideos();
                        }
                        return true;
                      },
                      child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio: 1.3,
                            crossAxisCount: 1,
                          ),
                          controller: _scrollController,
                          itemCount: _videoList.videos.length,
                          itemBuilder: (context, index) {
                            dynamic videoItem = _videoList.videos[index];
                            return InkWell(
                              onTap: () async {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return VideoPlayer(
                                    videoItem: videoItem,
                                  );
                                }));
                              },
                              child: GridTile(
                                child: CachedNetworkImage(
                                  fit: BoxFit.cover,
                                  imageUrl: videoItem.video.thumbnails.high.url,
                                ),
                                footer: Container(
                                  padding: const EdgeInsets.all(12.0),
                                  color: Colors.white,
                                  height: 60,
                                  child: Text(videoItem.video.title,
                                      style: const TextStyle(
                                        fontSize: 19,
                                        color: Colors.black87,
                                      )),
                                ),
                              ),
                            );
                          }),
                    ),
                  ),
                ])));
  }
}

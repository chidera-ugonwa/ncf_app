import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myapp/screens/library/string.dart';
import 'package:video_player/video_player.dart';
import 'mux_client.dart';

@immutable
class PreviewPage extends StatefulWidget {
  final Data assetData;

  const PreviewPage({Key? key, required this.assetData}) : super(key: key);

  @override
  _PreviewPageState createState() => _PreviewPageState();
}

class _PreviewPageState extends State<PreviewPage> {
  late VideoPlayerController _controller;
  late Data assetData;
  late String dateTimeString;

  @override
  void initState() {
    super.initState();

    assetData = widget.assetData;
    String playbackId = assetData.playbackIds![0].id;

    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(int.parse(assetData.createdAt) * 1000);
    DateFormat formatter = DateFormat.yMd().add_jm();
    dateTimeString = formatter.format(dateTime);

    _controller = VideoPlayerController.network('$muxStreamBaseUrl/$playbackId.$videoExtension')
      ..initialize().then((_) {
        setState(() {});
      });

    _controller.play();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Video preview'),
        backgroundColor: Colors.blue[800],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Container(
                    color: Colors.black,
                    width: double.maxFinite,
                    child: Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(
                          Colors.blue[800],
                        ),
                        strokeWidth: 2,
                      ),
                    ),
                  ),
                ),
                _controller.value.isInitialized
                    ? AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: VideoPlayer(_controller),
                      )
                    : AspectRatio(
                        aspectRatio: 16 / 9,
                        child: Container(
                          color: Colors.black,
                          width: double.maxFinite,
                          child: Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation(
                                Colors.blue[800],
                              ),
                              strokeWidth: 2,
                            ),
                          ),
                        ),
                      ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InfoTile(
                    name: 'Created',
                    data: dateTimeString,
                  ),
                  InfoTile(
                    name: 'Status',
                    data: assetData.status,
                  ),
                  InfoTile(
                    name: 'Duration',
                    data: '${assetData.duration.toStringAsFixed(2)} seconds',
                  ),
                  InfoTile(
                    name: 'Max Resolution',
                    data: assetData.maxStoredResolution,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

@immutable
class InfoTile extends StatelessWidget {
  final String name;
  final String data;

  const InfoTile({
    Key? key,
    required this.name,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 16.0,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4.0),
        Text(
          data,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 14.0,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 8.0),
      ],
    );
  }
}

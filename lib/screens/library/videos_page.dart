import 'package:flutter/material.dart';
import 'package:myapp/screens/library/mux_client.dart';
import 'package:myapp/screens/library/preview_page.dart';
import 'package:myapp/screens/library/string.dart';
import 'package:intl/intl.dart';

class VideoScreen extends StatefulWidget {
  const VideoScreen({Key? key}) : super(key: key);

  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class VideoTile extends StatelessWidget {
  final Data assetData;
  final String thumbnailUrl;
  final String dateTimeString;
  final bool isReady;

  const VideoTile({
    Key? key,
    required this.assetData,
    required this.thumbnailUrl,
    required this.dateTimeString,
    required this.isReady,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 16.0,
        right: 16.0,
        top: 8.0,
      ),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => PreviewPage(
                assetData: assetData,
              ),
            ),
          );
        },
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.all(
              Radius.circular(5.0),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.maxFinite,
                decoration: const BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5.0),
                    topRight: Radius.circular(5.0),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 8.0,
                    top: 8.0,
                    bottom: 8.0,
                  ),
                  child: RichText(
                    maxLines: 1,
                    softWrap: false,
                    overflow: TextOverflow.fade,
                    text: TextSpan(
                      text: 'ID: ',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                      ),
                      children: [
                        TextSpan(
                          text: assetData.id,
                          style: const TextStyle(
                            fontSize: 12.0,
                            color: Colors.white70,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  isReady
                      ? Image.network(
                          thumbnailUrl,
                          cacheWidth: 200,
                          cacheHeight: 110,
                        )
                      : Flexible(
                          child: AspectRatio(
                            aspectRatio: 16 / 9,
                            child: Container(
                              width: 200,
                              // height: 110,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 8.0,
                        top: 8.0,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            maxLines: 1,
                            softWrap: false,
                            overflow: TextOverflow.fade,
                            text: TextSpan(
                              text: 'Duration: ',
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 14.0,
                              ),
                              children: [
                                TextSpan(
                                  // ignore: unnecessary_null_comparison
                                  text: assetData.duration == null ? 'N/A' : assetData.duration.toStringAsFixed(2),
                                  style: const TextStyle(
                                    fontSize: 8.0,
                                    color: Colors.grey,
                                  ),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(height: 4.0),
                          RichText(
                            maxLines: 1,
                            softWrap: false,
                            overflow: TextOverflow.fade,
                            text: TextSpan(
                              text: 'Status: ',
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 14.0,
                              ),
                              children: [
                                TextSpan(
                                  text: assetData.status,
                                  style: const TextStyle(
                                    fontSize: 8.0,
                                    color: Colors.grey,
                                  ),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(height: 4.0),
                          RichText(
                            maxLines: 2,
                            overflow: TextOverflow.fade,
                            text: TextSpan(
                              text: 'Created at: ',
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 14.0,
                              ),
                              children: [
                                TextSpan(
                                  text: '\n$dateTimeString',
                                  style: const TextStyle(
                                    fontSize: 8.0,
                                    color: Colors.grey,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _VideoScreenState extends State<VideoScreen> {
  final MUXClient _muxClient = MUXClient();
  bool isProcessing = false;

  FocusNode _textFocusNodeVideoURL = FocusNode();

  @override
  void initState() {
    super.initState();
    _muxClient.initializeDio();
    _textFocusNodeVideoURL = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _textFocusNodeVideoURL.unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: FutureBuilder(
                future: _muxClient.getAssetList(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    dynamic assetData = snapshot.data;
                    int length = assetData?.data?.length;

                    return ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      itemCount: length,
                      itemBuilder: (context, index) {
                        DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(int.parse(assetData.data[index].createdAt) * 1000);
                        DateFormat formatter = DateFormat.yMd().add_jm();
                        String dateTimeString = formatter.format(dateTime);

                        String currentStatus = assetData.data[index].status;
                        bool isReady = currentStatus == 'ready';

                        String? playbackId = isReady ? assetData.data[index].playbackIds[0].id : null;

                        dynamic thumbnailURL = isReady ? '$muxImageBaseUrl/$playbackId/$imageTypeSize' : null;

                        return VideoTile(
                          assetData: assetData.data[index],
                          thumbnailUrl: thumbnailURL,
                          isReady: isReady,
                          dateTimeString: dateTimeString,
                        );
                      },
                      separatorBuilder: (_, __) => const SizedBox(
                        height: 16.0,
                      ),
                    );
                  }
                  return const Text(
                    'No videos present',
                    style: TextStyle(
                      color: Colors.black45,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

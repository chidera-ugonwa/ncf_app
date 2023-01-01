import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:myapp/screens/library/audios/common.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:audio_session/audio_session.dart';
import 'package:just_audio_background/just_audio_background.dart';

class AudioScreen extends StatefulWidget {
  const AudioScreen({Key? key}) : super(key: key);
  @override
  _AudioScreenState createState() => _AudioScreenState();
}

class _AudioScreenState extends State<AudioScreen>
    with AutomaticKeepAliveClientMixin {
  static int _nextMediaId = 0;
  final _player = AudioPlayer();
  List _audioList = [];
  bool isLoading = true;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.black,
    ));
    getAudioList();
  }

  Future<List> getAudioList() async {
    final url = Uri.https('www.googleapis.com', '/drive/v3/files', {
      'q': "'1UqJRO-5nvaeGPTxUlA8yNX7xv0WOqk18' in parents",
      'corpora': 'user',
      'includeItemsFromAllDrives': 'true',
      'supportsAllDrives': 'true',
      'key': "AIzaSyAdy4Bf1OhH-WhmjBOtapu-diTkp63YWCc"
    });

    // Await the HTTP GET response, then decode the
    // JSON data it contains.
    final response = await http.get(url);
    final jsonResponse = convert.jsonDecode(response.body);
    final files = jsonResponse['files'];

    //print(files);
    setState(() {
      _audioList = files;
      isLoading = false;
    });

    return files;
  }

  void displayPersistentBottomSheet(String id, String name) {
    _init(id, name);

    Scaffold.of(context).showBottomSheet<void>((BuildContext context) {
      return Column(mainAxisSize: MainAxisSize.min, children: [
        StreamBuilder<PositionData>(
          stream: _positionDataStream,
          builder: (context, snapshot) {
            final positionData = snapshot.data;
            return SeekBar(
              duration: positionData?.duration ?? Duration.zero,
              position: positionData?.position ?? Duration.zero,
              bufferedPosition: positionData?.bufferedPosition ?? Duration.zero,
              onChangeEnd: _player.seek,
            );
          },
        ),
        ListTile(
          title: Text(name),
          leading: Image.network(
              'https://drive.google.com/uc?export=view&id=193qhbAygSUyOHIxiFAonnsENpA6SuQmW'),
          trailing: ControlButtons(_player),
        )
      ]);
    });
  }

  Future<void> _init(String id, String title) async {
    // Inform the operating system of our app's audio attributes etc.
    // We pick a reasonable default for an app that plays speech.
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.speech());
    // Listen to errors during playback.
    _player.playbackEventStream.listen((event) {},
        onError: (Object e, StackTrace stackTrace) {
      debugPrint('A stream error occurred: $e');
    });
    // Try to load audio from a source and catch any errors.
    try {
      // AAC example: https://dl.espressif.com/dl/audio/ff-16b-2c-44100hz.aac
      await _player.setAudioSource(ConcatenatingAudioSource(children: [
        AudioSource.uri(
          Uri.parse(
              "https://drive.google.com/uc?export=download&confirm=no_antivirus&id=$id"),
          tag: MediaItem(
            id: '${_nextMediaId++}',
            album: "David Ogbueli",
            title: title,
            artUri: Uri.parse(
                'https://drive.google.com/uc?export=view&id=193qhbAygSUyOHIxiFAonnsENpA6SuQmW'),
          ),
        ),
      ]));
    } catch (e) {
      debugPrint("Error loading audio source: $e");
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  /// Collects the data useful for displaying in a seek bar, using a handy
  /// feature of rx_dart to combine the 3 streams of interest into one.
  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          _player.positionStream,
          _player.bufferedPositionStream,
          _player.durationStream,
          (position, bufferedPosition, duration) => PositionData(
              position, bufferedPosition, duration ?? Duration.zero));

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(top: 10),
        color: Colors.white,
        child: Center(
          child: isLoading
              ? const CircularProgressIndicator()
              : ListView.separated(
                  separatorBuilder: (context, index) => const SizedBox(
                        height: 10,
                      ),
                  itemCount: _audioList.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: Image.network(
                          'https://drive.google.com/uc?export=view&id=193qhbAygSUyOHIxiFAonnsENpA6SuQmW'),
                      title: Text(_audioList[index]["name"]),
                      onTap: () {
                        displayPersistentBottomSheet(
                            _audioList[index]['id'], _audioList[index]["name"]);
                      },
                    );
                  }),
        ),
      ),
    );
  }
}

/// Displays the play/pause button and volume/speed sliders.
class ControlButtons extends StatelessWidget {
  final AudioPlayer player;

  const ControlButtons(this.player, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        /// This StreamBuilder rebuilds whenever the player state changes, which
        /// includes the playing/paused state and also the
        /// loading/buffering/ready state. Depending on the state we show the
        /// appropriate button or loading indicator.
        StreamBuilder<PlayerState>(
          stream: player.playerStateStream,
          builder: (context, snapshot) {
            final playerState = snapshot.data;
            final processingState = playerState?.processingState;
            final playing = playerState?.playing;
            if (processingState == ProcessingState.loading ||
                processingState == ProcessingState.buffering) {
              return Container(
                margin: const EdgeInsets.all(1.0),
                width: 10.0,
                height: 10.0,
                child: const CircularProgressIndicator(),
              );
            } else if (playing != true) {
              return IconButton(
                icon: const Icon(Icons.play_arrow),
                iconSize: 30.0,
                onPressed: player.play,
              );
            } else if (processingState != ProcessingState.completed) {
              return IconButton(
                icon: const Icon(Icons.pause),
                iconSize: 30.0,
                onPressed: player.pause,
              );
            } else {
              return IconButton(
                icon: const Icon(Icons.replay),
                iconSize: 30.0,
                onPressed: () => player.seek(Duration.zero),
              );
            }
          },
        ),
      ],
    );
  }
}

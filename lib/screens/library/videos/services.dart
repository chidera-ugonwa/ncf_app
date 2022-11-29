import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:myapp/screens/library/videos/videos_list.dart';
import 'dart:io';
import 'dart:convert' as convert;

class Services {
  static Future<VideoList> getVideosList({
    String playlistId = 'PLuX81RZk5-3Ys_CW7YE5SRTk9tVrLp0f_',
    String pageToken = '',
  }) async {
    Map<String, String> parameters = {
      'part': 'snippet, contentDetails, status',
      'playlistId': playlistId,
      'pageToken': pageToken,
      'key': "AIzaSyAdy4Bf1OhH-WhmjBOtapu-diTkp63YWCc",
      'maxResults': '500',
    };
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };
    Uri uri = Uri.https(
      "www.googleapis.com",
      '/youtube/v3/playlistItems',
      parameters,
    );
    Response response = await http.get(uri, headers: headers);
    //print(response.body);
    VideoList videoList = videoListFromJson(response.body);
    return videoList;
  }

  static Future<List> getPlayList({
    String playlistId = 'PLuX81RZk5-3Ys_CW7YE5SRTk9tVrLp0f_',
  }) async {
    Map<String, String> parameters = {
      'part': 'contentDetails',
      'id': playlistId,
      'key': "AIzaSyAdy4Bf1OhH-WhmjBOtapu-diTkp63YWCc",
    };
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };
    Uri uri = Uri.https(
      "www.googleapis.com",
      '/youtube/v3/playlists',
      parameters,
    );
    Response response = await http.get(uri, headers: headers);
    //print(response.body);
    dynamic playList = convert.jsonDecode(response.body);
    final items = playList['items'];
    //print(items);
    return items;
  }
}

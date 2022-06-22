// ignore_for_file: unnecessary_null_comparison, prefer_null_aware_operators, prefer_if_null_operators

import 'package:dio/dio.dart';
import 'package:myapp/screens/library/string.dart';
import 'dart:convert';

class MUXClient {
  Dio _dio = Dio();

  initializeDio() {
    // initialize the dio here
    BaseOptions options = BaseOptions(
      baseUrl: muxServerUrl,
      connectTimeout: 8000,
      receiveTimeout: 5000,
      headers: {
        "Content-Type": contentType, // application/json
      },
    );
    _dio = Dio(options);
  }

  Future getAssetList() async {
    try {
      Response response = await _dio.get(
        "/assets",
      );

      if (response.statusCode == 200) {
        AssetData assetData = AssetData.fromJson(response.data);

        return assetData;
      }
    } catch (e) {
      print('Error starting build: $e');
      throw Exception('Failed to retrieve videos from MUX');
    }

    return null;
  }
}

class Data {
  Data({
    required this.test,
    required this.maxStoredFrameRate,
    required this.status,
    required this.tracks,
    required this.id,
    required this.maxStoredResolution,
    required this.masterAccess,
    required this.playbackIds,
    required this.createdAt,
    required this.duration,
    required this.mp4Support,
    required this.aspectRatio,
  }) {
    throw UnimplementedError();
  }

  bool test;
  double maxStoredFrameRate;
  String status;
  List<Track>? tracks;
  String id;
  String maxStoredResolution;
  String masterAccess;
  List<PlaybackId>? playbackIds;
  String createdAt;
  double duration;
  String mp4Support;
  String aspectRatio;

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        test: json["test"] == null ? null : json["test"],
        maxStoredFrameRate: json["max_stored_frame_rate"] == null ? null : json["max_stored_frame_rate"].toDouble(),
        status: json["status"] == null ? null : json["status"],
        tracks: json["tracks"] == null ? null : List<Track>.from(json["tracks"].map((x) => Track.fromJson(x))),
        id: json["id"] == null ? null : json["id"],
        maxStoredResolution: json["max_stored_resolution"] == null ? null : json["max_stored_resolution"],
        masterAccess: json["master_access"] == null ? null : json["master_access"],
        playbackIds: json["playback_ids"] == null ? null : List<PlaybackId>.from(json["playback_ids"].map((x) => PlaybackId.fromJson(x))),
        createdAt: json["created_at"] == null ? null : json["created_at"],
        duration: json["duration"] == null ? null : json["duration"].toDouble(),
        mp4Support: json["mp4_support"] == null ? null : json["mp4_support"],
        aspectRatio: json["aspect_ratio"] == null ? null : json["aspect_ratio"],
      );

  Map<String, dynamic> toJson() => {
        "test": test == null ? null : test,
        "max_stored_frame_rate": maxStoredFrameRate == null ? null : maxStoredFrameRate,
        "status": status == null ? null : status,
        "tracks": tracks == null ? null : List<dynamic>.from(tracks!.map((x) => x.toJson())),
        "id": id == null ? null : id,
        "max_stored_resolution": maxStoredResolution == null ? null : maxStoredResolution,
        "master_access": masterAccess == null ? null : masterAccess,
        "playback_ids": playbackIds == null ? null : List<dynamic>.from(playbackIds!.map((x) => x.toJson())),
        "created_at": createdAt == null ? null : createdAt,
        "duration": duration == null ? null : duration,
        "mp4_support": mp4Support == null ? null : mp4Support,
        "aspect_ratio": aspectRatio == null ? null : aspectRatio,
      };
}

class PlaybackId {
  PlaybackId({
    required this.policy,
    required this.id,
  });

  String policy;
  String id;

  factory PlaybackId.fromRawJson(String str) => PlaybackId.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PlaybackId.fromJson(Map<String, dynamic> json) => PlaybackId(
        policy: json["policy"] == null ? null : json["policy"],
        id: json["id"] == null ? null : json["id"],
      );

  Map<String, dynamic> toJson() => {
        "policy": policy == null ? null : policy,
        "id": id == null ? null : id,
      };
}

class Track {
  Track({
    required this.maxWidth,
    required this.type,
    required this.id,
    required this.duration,
    required this.maxFrameRate,
    required this.maxHeight,
    required this.maxChannelLayout,
    required this.maxChannels,
  });

  int maxWidth;
  String type;
  String id;
  double duration;
  double maxFrameRate;
  int maxHeight;
  String maxChannelLayout;
  int maxChannels;

  factory Track.fromRawJson(String str) => Track.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Track.fromJson(Map<String, dynamic> json) => Track(
        maxWidth: json["max_width"] == null ? null : json["max_width"],
        type: json["type"] == null ? null : json["type"],
        id: json["id"] == null ? null : json["id"],
        duration: json["duration"] == null ? null : json["duration"].toDouble(),
        maxFrameRate: json["max_frame_rate"] == null ? null : json["max_frame_rate"].toDouble(),
        maxHeight: json["max_height"] == null ? null : json["max_height"],
        maxChannelLayout: json["max_channel_layout"] == null ? null : json["max_channel_layout"],
        maxChannels: json["max_channels"] == null ? null : json["max_channels"],
      );

  Map<String, dynamic> toJson() => {
        "max_width": maxWidth == null ? null : maxWidth,
        "type": type == null ? null : type,
        "id": id == null ? null : id,
        "duration": duration == null ? null : duration,
        "max_frame_rate": maxFrameRate == null ? null : maxFrameRate,
        "max_height": maxHeight == null ? null : maxHeight,
        "max_channel_layout": maxChannelLayout == null ? null : maxChannelLayout,
        "max_channels": maxChannels == null ? null : maxChannels,
      };
}

class AssetData {
  AssetData({
    required this.data,
  });

  List? data;

  factory AssetData.fromRawJson(String str) => AssetData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AssetData.fromJson(Map<String, dynamic> json) => AssetData(
        data: json["data"] == null ? null : List<dynamic>.from(json["data"].map((x) => Data.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": data == null ? null : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

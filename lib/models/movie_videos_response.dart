import 'package:json_annotation/json_annotation.dart';
import 'video_model.dart';

part 'movie_videos_response.g.dart';

@JsonSerializable()
class MovieVideosResponse {
  final List<VideoModel> results;
  MovieVideosResponse({required this.results});
  factory MovieVideosResponse.fromJson(Map<String, dynamic> json) =>
      _$MovieVideosResponseFromJson(json);
}

import 'package:json_annotation/json_annotation.dart';
import 'package:tmdb_movies/models/tv_show_model.dart';

part 'tv_show_list_response.g.dart';

@JsonSerializable()
class TvShowListResponse {
  @JsonKey(name: 'results')
  final List<TvShowModel> results;

  TvShowListResponse({required this.results});

  factory TvShowListResponse.fromJson(Map<String, dynamic> json) =>
      _$TvShowListResponseFromJson(json);

  Map<String, dynamic> toJson() => _$TvShowListResponseToJson(this);
}

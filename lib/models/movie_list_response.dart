import 'package:json_annotation/json_annotation.dart';
import 'package:tmdb_movies/models/movie_model.dart';

part 'movie_list_response.g.dart';

@JsonSerializable()
class MovieListResponse {
  @JsonKey(name: 'results')
  final List<MovieModel> results;

  MovieListResponse({required this.results});

  factory MovieListResponse.fromJson(Map<String, dynamic> json) =>
      _$MovieListResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MovieListResponseToJson(this);
}

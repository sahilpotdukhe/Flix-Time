
import 'package:json_annotation/json_annotation.dart';
import 'package:tmdb_movies/models/cast_model.dart';

part 'movie_casts_response.g.dart';

@JsonSerializable()
class MovieCastsResponse{
  @JsonKey(name: 'cast')
  final List<CastModel> casts;

  MovieCastsResponse({required this.casts});

  factory MovieCastsResponse.fromJson(Map<String,dynamic> json) => _$MovieCastsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MovieCastsResponseToJson(this);
}
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'movie_model.g.dart';

@HiveType(typeId: 1)
@JsonSerializable()
class MovieModel {
  @HiveField(0)
  final int id;

  @HiveField(1)
  @JsonKey(name: 'title')
  final String title;

  @HiveField(2)
  @JsonKey(name: 'poster_path')
  final String? posterPath;

  @HiveField(3)
  @JsonKey(name: 'overview')
  final String overview;

  @HiveField(4)
  @JsonKey(name: 'release_date')
  final String releaseDate;

  @HiveField(5)
  @JsonKey(name: 'vote_average')
  final double voteAverage;

  MovieModel({
    required this.id,
    required this.title,
    required this.posterPath,
    required this.overview,
    required this.releaseDate,
    required this.voteAverage,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) =>
      _$MovieModelFromJson(json);

  Map<String, dynamic> toJson() => _$MovieModelToJson(this);
}

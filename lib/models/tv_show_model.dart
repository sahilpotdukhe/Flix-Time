import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'tv_show_model.g.dart';

@HiveType(typeId: 2)
@JsonSerializable()
class TvShowModel {
  @HiveField(0)
  final int id;

  @HiveField(1)
  @JsonKey(name: 'name')
  final String title;

  @HiveField(2)
  @JsonKey(name: 'poster_path')
  final String? posterPath;

  @HiveField(3)
  @JsonKey(name: 'overview')
  final String overview;

  @HiveField(4)
  @JsonKey(name: 'first_air_date')
  final String? firstAirDate;

  @HiveField(5)
  @JsonKey(name: 'vote_average')
  final double voteAverage;

  @HiveField(6)
  @JsonKey(name: 'backdrop_path')
  final String? backdropPath;

  TvShowModel({
    required this.id,
    required this.title,
    required this.posterPath,
    required this.overview,
    required this.firstAirDate,
    required this.voteAverage,
    required this.backdropPath,
  });

  factory TvShowModel.fromJson(Map<String, dynamic> json) =>
      _$TvShowModelFromJson(json);

  Map<String, dynamic> toJson() => _$TvShowModelToJson(this);
}

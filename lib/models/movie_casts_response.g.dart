// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_casts_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MovieCastsResponse _$MovieCastsResponseFromJson(Map<String, dynamic> json) =>
    MovieCastsResponse(
      casts: (json['cast'] as List<dynamic>)
          .map((e) => CastModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MovieCastsResponseToJson(MovieCastsResponse instance) =>
    <String, dynamic>{
      'cast': instance.casts,
    };

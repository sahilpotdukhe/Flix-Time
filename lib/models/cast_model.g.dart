// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cast_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CastModel _$CastModelFromJson(Map<String, dynamic> json) => CastModel(
      id: (json['id'] as num).toInt(),
      castType: json['known_for_department'] as String,
      character: json['character'] as String,
      name: json['name'] as String,
      profileUrl: json['profile_path'] as String,
      gender: (json['gender'] as num).toInt(),
    );

Map<String, dynamic> _$CastModelToJson(CastModel instance) => <String, dynamic>{
      'id': instance.id,
      'known_for_department': instance.castType,
      'name': instance.name,
      'character': instance.character,
      'profile_path': instance.profileUrl,
      'gender': instance.gender,
    };

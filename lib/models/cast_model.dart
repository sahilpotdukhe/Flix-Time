import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'cast_model.g.dart';

// @HiveType(typeId: 2)
@JsonSerializable()
class CastModel {
  // @HiveField(0)
  final int id;

  // @HiveField(1)
  @JsonKey(name: 'known_for_department')
  final String castType;

  // @HiveField(2)
  @JsonKey(name: 'name')
  final String name;

  // @HiveField(3)
  @JsonKey(name: 'character')
  final String character;

  // @HiveField(4)
  @JsonKey(name: 'profile_path')
  final String profileUrl;

  // @HiveField(5)
  @JsonKey(name: 'gender')
  final int gender;

  CastModel({
    required this.id,
    required this.castType,
    required this.character,
    required this.name,
    required this.profileUrl,
    required this.gender,
  });

  factory CastModel.fromJson(Map<String,dynamic> json) => _$CastModelFromJson(json);

  Map<String,dynamic> toJson() => _$CastModelToJson(this);
}

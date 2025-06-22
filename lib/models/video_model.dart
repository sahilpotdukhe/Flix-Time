import 'package:json_annotation/json_annotation.dart';

part 'video_model.g.dart';

@JsonSerializable()
class VideoModel {
  final String key;
  final String site;
  final String type;
  final String name;

  VideoModel({required this.key, required this.site, required this.type, required this.name});
  factory VideoModel.fromJson(Map<String, dynamic> json) => _$VideoModelFromJson(json);
}

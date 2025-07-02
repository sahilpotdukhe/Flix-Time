// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tv_show_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TvShowModelAdapter extends TypeAdapter<TvShowModel> {
  @override
  final int typeId = 2;

  @override
  TvShowModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TvShowModel(
      id: fields[0] as int,
      title: fields[1] as String,
      posterPath: fields[2] as String?,
      overview: fields[3] as String,
      firstAirDate: fields[4] as String?,
      voteAverage: fields[5] as double,
      backdropPath: fields[6] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, TvShowModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.posterPath)
      ..writeByte(3)
      ..write(obj.overview)
      ..writeByte(4)
      ..write(obj.firstAirDate)
      ..writeByte(5)
      ..write(obj.voteAverage)
      ..writeByte(6)
      ..write(obj.backdropPath);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TvShowModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TvShowModel _$TvShowModelFromJson(Map<String, dynamic> json) => TvShowModel(
      id: (json['id'] as num).toInt(),
      title: json['name'] as String,
      posterPath: json['poster_path'] as String?,
      overview: json['overview'] as String,
      firstAirDate: json['first_air_date'] as String?,
      voteAverage: (json['vote_average'] as num).toDouble(),
      backdropPath: json['backdrop_path'] as String?,
    );

Map<String, dynamic> _$TvShowModelToJson(TvShowModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.title,
      'poster_path': instance.posterPath,
      'overview': instance.overview,
      'first_air_date': instance.firstAirDate,
      'vote_average': instance.voteAverage,
      'backdrop_path': instance.backdropPath,
    };

import 'package:tmdb_movies/models/cast_model.dart';

class CastState{
  final List<CastModel> casts;
  final bool isLoading;
  final String? errorMessage;

  CastState({this.casts =const [], this.isLoading = false, this.errorMessage});

  CastState copyWith({List<CastModel>? casts,bool? isLoading,String? errorMessage}){
    return CastState(
      casts: casts ?? this.casts,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage
    );
  }
}
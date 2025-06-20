import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchTrendingMovies extends HomeEvent {}

class FetchNowPlayingMovies extends HomeEvent {}

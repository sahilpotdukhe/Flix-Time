import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchTrendingMovies extends HomeEvent {}

class FetchNowPlayingMovies extends HomeEvent {}

class FetchTopRatedMovies extends HomeEvent {}

class FetchPopularMovies extends HomeEvent {}

class FetchUpcomingMovies extends HomeEvent {}

import 'package:equatable/equatable.dart';
import 'package:tmdb_movies/models/movie_model.dart';

class HomeState extends Equatable {
  final List<MovieModel> trendingMovies;
  final List<MovieModel> nowPlayingMovies;
  final List<MovieModel> popularMovies;
  final List<MovieModel> topRatedMovies;
  final List<MovieModel> upcomingMovies;
  final bool isLoading;
  final String? errorMessage;

  const HomeState({
    this.trendingMovies = const [],
    this.nowPlayingMovies = const [],
    this.topRatedMovies = const [],
    this.popularMovies = const [],
    this.upcomingMovies = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  HomeState copyWith({
    List<MovieModel>? trendingMovies,
    List<MovieModel>? nowPlayingMovies,
    List<MovieModel>? topRatedMovies,
    List<MovieModel>? popularMovies,
    List<MovieModel>? upcomingMovies,
    bool? isLoading,
    String? errorMessage,
  }) {
    return HomeState(
      trendingMovies: trendingMovies ?? this.trendingMovies,
      nowPlayingMovies: nowPlayingMovies ?? this.nowPlayingMovies,
      popularMovies: popularMovies ?? this.popularMovies,
      topRatedMovies: topRatedMovies ?? this.topRatedMovies,
      upcomingMovies: upcomingMovies ?? this.upcomingMovies,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    trendingMovies,
    nowPlayingMovies,
    popularMovies,
    topRatedMovies,
    upcomingMovies,
    isLoading,
    errorMessage,
  ];
}

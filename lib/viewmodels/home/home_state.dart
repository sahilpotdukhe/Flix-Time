import 'package:equatable/equatable.dart';
import 'package:tmdb_movies/models/movie_model.dart';

class HomeState extends Equatable {
  final List<MovieModel> trendingMovies;
  final List<MovieModel> nowPlayingMovies;
  final bool isLoading;
  final String? errorMessage;

  const HomeState({
    this.trendingMovies = const [],
    this.nowPlayingMovies = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  HomeState copyWith({
    List<MovieModel>? trendingMovies,
    List<MovieModel>? nowPlayingMovies,
    bool? isLoading,
    String? errorMessage,
  }) {
    return HomeState(
      trendingMovies: trendingMovies ?? this.trendingMovies,
      nowPlayingMovies: nowPlayingMovies ?? this.nowPlayingMovies,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    trendingMovies,
    nowPlayingMovies,
    isLoading,
    errorMessage,
  ];
}

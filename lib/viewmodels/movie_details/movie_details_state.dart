import 'package:tmdb_movies/models/movie_model.dart';

class MovieDetailsState {
  final bool isLoading;
  final MovieModel? movie;
  final String? error;
  final List<MovieModel> similarMovies;

  MovieDetailsState({
    this.isLoading = false,
    this.movie,
    this.error,
    this.similarMovies = const [],
  });

  MovieDetailsState copyWith({
    bool? isLoading,
    MovieModel? movie,
    String? error,
    List<MovieModel>? similarMovies
  }) {
    return MovieDetailsState(
      isLoading: isLoading ?? this.isLoading,
      movie: movie ?? this.movie,
      error: error,
      similarMovies: similarMovies ?? this.similarMovies
    );
  }
}

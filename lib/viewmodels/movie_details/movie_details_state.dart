import 'package:tmdb_movies/models/movie_model.dart';

class MovieDetailsState {
  final bool isLoading;
  final MovieModel? movie;
  final String? error;

  MovieDetailsState({this.isLoading = false, this.movie, this.error});

  MovieDetailsState copyWith({
    bool? isLoading,
    MovieModel? movie,
    String? error,
  }) {
    return MovieDetailsState(
      isLoading: isLoading ?? this.isLoading,
      movie: movie ?? this.movie,
      error: error,
    );
  }
}

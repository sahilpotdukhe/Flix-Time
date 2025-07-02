abstract class MovieDetailsEvent {}

class FetchMovieDetails extends MovieDetailsEvent {
  final int movieId;

  FetchMovieDetails({required this.movieId});
}

class FetchSimilarMovies extends MovieDetailsEvent {
  final int movieId;

  FetchSimilarMovies({required this.movieId});
}

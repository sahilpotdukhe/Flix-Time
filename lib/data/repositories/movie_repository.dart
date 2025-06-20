import 'package:tmdb_movies/models/movie_model.dart';

abstract class MovieRepository {
  Future<List<MovieModel>> getTrendingMovies();
  Future<List<MovieModel>> getNowPlayingMovies();
  Future<List<MovieModel>> searchMovies(String query);
  Future<MovieModel> getMovieDetails(int movieId);
  Future<void> toggleBookmark(MovieModel movie);
  List<MovieModel> getBookMarkedMovies();
  bool isBookmarked(int movieId);
}

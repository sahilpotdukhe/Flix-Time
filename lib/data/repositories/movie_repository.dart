import 'package:tmdb_movies/models/cast_model.dart';
import 'package:tmdb_movies/models/movie_model.dart';

abstract class MovieRepository {
  Future<List<MovieModel>> getTrendingMovies();
  Future<List<MovieModel>> getNowPlayingMovies();
  Future<List<MovieModel>> getPopularMovies();
  Future<List<MovieModel>> getTopRatedMovies();
  Future<List<MovieModel>> getUpcomingMovies();
  Future<List<CastModel>> getMoviesCast(int movieId);
  Future<List<MovieModel>> getSimilarMovies(int movieId);
  Future<List<MovieModel>> searchMovies(String query);
  Future<MovieModel> getMovieDetails(int movieId);
  Future<String?> getMovieTrailerKey(int movieId);
  Future<void> toggleBookmark(MovieModel movie);
  List<MovieModel> getBookMarkedMovies();
  bool isBookmarked(int movieId);
}

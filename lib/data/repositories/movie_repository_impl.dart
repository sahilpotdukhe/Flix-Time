import 'package:hive/hive.dart';
import 'package:tmdb_movies/data/api/tmdb_api.dart';
import 'package:tmdb_movies/data/repositories/movie_repository.dart';
import 'package:tmdb_movies/models/movie_model.dart';

class MovieRepositoryImp extends MovieRepository {
  final TMDBApi tmdbApi;
  final Box<List<MovieModel>> cacheBox;
  final Box<MovieModel> movieDetailsBox;
  final String apiKey;

  MovieRepositoryImp({
    required this.tmdbApi,
    required this.cacheBox,
    required this.movieDetailsBox,
    required this.apiKey,
  });

  @override
  Future<List<MovieModel>> getTrendingMovies() async {
    try {
      final response = await tmdbApi.getTrendingMovies(apiKey, 'en-US');
      print("Raw response JSON: ${response.toJson()}");
      print("Trending movies fetched: ${response.results.length}");
      await cacheBox.put('trending', response.results);
      return response.results;
    } catch (_) {
      return cacheBox.get('trending', defaultValue: [])!.cast<MovieModel>();
    }
  }

  @override
  Future<List<MovieModel>> getNowPlayingMovies() async {
    try {
      final response = await tmdbApi.getNowPlayingMovies(apiKey);
      await cacheBox.put('now_playing', response.results);
      return response.results;
    } catch (_) {
      return cacheBox.get('now_playing', defaultValue: [])!.cast<MovieModel>();
    }
  }

  @override
  Future<List<MovieModel>> searchMovies(String query) async {
    final response = await tmdbApi.searchMovie(apiKey, query);
    return response.results;
  }

  @override
  Future<MovieModel> getMovieDetails(int movieId) async {
    try {
      final movieDetails = await tmdbApi.getMovieDetails(movieId, apiKey);
      await movieDetailsBox.put(movieId, movieDetails);
      return movieDetails;
    } catch (_) {
      final cached = movieDetailsBox.get(movieId);
      if (cached != null) return cached;
      rethrow;
    }
  }
}

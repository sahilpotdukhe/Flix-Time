import 'dart:developer';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:hive/hive.dart';
import 'package:tmdb_movies/data/api/tmdb_api.dart';
import 'package:tmdb_movies/data/repositories/movie_repository.dart';
import 'package:tmdb_movies/models/movie_model.dart';

class MovieRepositoryImp implements MovieRepository {
  final TMDBApi tmdbApi;
  final Box<MovieModel> trendingBox;
  final Box<MovieModel> nowPlayingBox;
  final Box<MovieModel> movieDetailsBox;
  final Box<MovieModel> bookmarksBox;
  final String apiKey;

  MovieRepositoryImp({
    required this.tmdbApi,
    required this.trendingBox,
    required this.nowPlayingBox,
    required this.movieDetailsBox,
    required this.bookmarksBox,
    required this.apiKey,
  });

  Future<bool> _isConnected() async {
    final result = await Connectivity().checkConnectivity();
    return result != ConnectivityResult.none;
  }

  @override
  Future<List<MovieModel>> getTrendingMovies() async {
    try {
      if (!await _isConnected()) throw Exception("Offline");

      final response = await tmdbApi.getTrendingMovies(apiKey, 'en-US');
      final movies = response.results;

      await trendingBox.clear();
      for (final movie in movies) {
        await trendingBox.put(movie.id.toString(), movie);
      }

      return movies;
    } catch (e, stack) {
      log("Error fetching trending movies: $e", stackTrace: stack);
      final cachedMovies = trendingBox.values.toList();
      return cachedMovies; // ✅ return empty list if cache empty
    }
  }

  @override
  Future<List<MovieModel>> getNowPlayingMovies() async {
    try {
      if (!await _isConnected()) throw Exception("Offline");

      final response = await tmdbApi.getNowPlayingMovies(apiKey);
      final movies = response.results;

      await nowPlayingBox.clear();
      for (final movie in movies) {
        await nowPlayingBox.put(movie.id.toString(), movie);
      }

      return movies;
    } catch (e, stack) {
      log("Error fetching now playing movies: $e", stackTrace: stack);
      final cachedMovies = nowPlayingBox.values.toList();
      return cachedMovies;
    }
  }
  
  @override
  Future<MovieModel> getMovieDetails(int movieId) async {
    final key = movieId.toString();

    final cached = movieDetailsBox.get(key);
    if (cached != null) return cached;

    if (!await _isConnected()) {
      log("Offline and no cached detail for movie ID: $movieId");
      throw Exception("You are offline. No cached details available.");
    }

    try {
      final movie = await tmdbApi.getMovieDetails(movieId, apiKey);
      await movieDetailsBox.put(key, movie);
      return movie;
    } catch (e, stack) {
      log("Failed to fetch movie details: $e", stackTrace: stack);
      throw Exception("Failed to load movie details.");
    }
  }

  @override
  Future<List<MovieModel>> searchMovies(String query) async {
    try {
      if (!await _isConnected()) throw Exception("Offline");
      final response = await tmdbApi.searchMovie(apiKey, query);
      return response.results;
    } catch (e, stack) {
      log("Search error: $e", stackTrace: stack);
      return [];
    }
  }

  @override
  List<MovieModel> getBookMarkedMovies() {
    return bookmarksBox.values.toList();
  }

  @override
  bool isBookmarked(int movieId) {
    return bookmarksBox.containsKey(movieId.toString());
  }

  @override
  Future<void> toggleBookmark(MovieModel movie) async {
    final key = movie.id.toString();
    if (bookmarksBox.containsKey(key)) {
      await bookmarksBox.delete(key);
      log("Removed bookmark: ${movie.title}");
    } else {
      await bookmarksBox.put(key, movie);
      log("Added bookmark: ${movie.title}");
    }
  }
}

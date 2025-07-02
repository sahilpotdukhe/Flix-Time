import 'dart:developer';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:hive/hive.dart';
import 'package:tmdb_movies/data/api/tmdb_api.dart';
import 'package:tmdb_movies/data/repositories/movie_repository.dart';
import 'package:tmdb_movies/models/cast_model.dart';
import 'package:tmdb_movies/models/movie_model.dart';

class MovieRepositoryImp implements MovieRepository {
  final TMDBApi tmdbApi;
  final Box<MovieModel> moviesBox;
  final String apiKey;

  MovieRepositoryImp({
    required this.tmdbApi,
    required this.moviesBox,
    required this.apiKey,
  });

  Future<bool> _isConnected() async {
    final result = await Connectivity().checkConnectivity();
    return result != ConnectivityResult.none;
  }

  // Helper: Prefix keys
  String _createKey(String prefix, int id) => '${prefix}_$id';

  // Remove keys by prefix
  Future<void> _clearCategory(String prefix) async {
    final keys =
        moviesBox.keys.where((k) => k.toString().startsWith(prefix)).toList();
    await moviesBox.deleteAll(keys);
  }

  List<MovieModel> _getCachedByPrefix(String prefix) {
    return moviesBox.toMap().entries
        .where((e) => e.key.toString().startsWith(prefix))
        .map((e) => e.value)
        .toList();
  }

  @override
  Future<List<MovieModel>> getTrendingMovies() async {
    try {
      if (!await _isConnected()) throw Exception("Offline");

      final response = await tmdbApi.getTrendingMovies(apiKey, 'en-US');
      final trendingMovies = response.results;

      // store in local storage with key as trending_1234 and value as movieModel
      await _clearCategory('trending');
      for (final movie in trendingMovies) {
        await moviesBox.put(_createKey('trending', movie.id), movie);
      }

      return trendingMovies;
    } catch (e) {
      // return from local storage
      return _getCachedByPrefix('trending');
    }
  }

  @override
  Future<List<MovieModel>> getNowPlayingMovies() async {
    try {
      if (!await _isConnected()) throw Exception("Offline");

      final response = await tmdbApi.getNowPlayingMovies(apiKey);
      final nowPlayingMovies = response.results;

      await _clearCategory('nowPlaying');
      for (final movie in nowPlayingMovies) {
        await moviesBox.put(_createKey('nowPlaying', movie.id), movie);
      }

      return nowPlayingMovies;
    } catch (e) {
      return _getCachedByPrefix('nowPlaying');
    }
  }

  @override
  Future<List<MovieModel>> getPopularMovies() async {
    try {
      if (!await _isConnected()) throw Exception("offline");

      final response = await tmdbApi.getPopularMovies(apiKey);
      final popularMovies = response.results;

      await _clearCategory('popular');
      for (final movie in popularMovies) {
        await moviesBox.put(_createKey('popular', movie.id), movie);
      }

      return popularMovies;
    } catch (e) {
      return _getCachedByPrefix('popular');
    }
  }

  @override
  Future<List<MovieModel>> getTopRatedMovies() async {
    try {
      if (!await _isConnected()) throw Exception("offline");
      final response = await tmdbApi.getTopRatedMovies(apiKey);
      final topRatedMovies = response.results;

      await _clearCategory('popular');
      for (final movie in topRatedMovies) {
        await moviesBox.put(_createKey('topRated', movie.id), movie);
      }

      return topRatedMovies;
    } catch (e) {
      return _getCachedByPrefix('topRated');
    }
  }

  @override
  Future<List<MovieModel>> getUpcomingMovies() async {
    try {
      if (!await _isConnected()) throw Exception("offline");
      final response = await tmdbApi.getUpcomingMovies(apiKey);
      final upcomingMovies = response.results;

      await _clearCategory('upcoming');
      for (final movie in upcomingMovies) {
        await moviesBox.put(_createKey('upcoming', movie.id), movie);
      }

      return upcomingMovies;
    } catch (e) {
      return _getCachedByPrefix('upcoming');
    }
  }

  @override
  Future<MovieModel> getMovieDetails(int movieId) async {
    final key = _createKey('details', movieId);
    final cached = moviesBox.get(key);
    if (cached != null) return cached;

    if (!await _isConnected()) {
      log("Offline and no cached detail for movie ID: $movieId");
      throw Exception("You are offline. No cached details available.");
    }

    try {
      final movieDetails = await tmdbApi.getMovieDetails(movieId, apiKey);
      await moviesBox.put(key, movieDetails);
      return movieDetails;
    } catch (e) {
      throw Exception("Failed to load movie details.");
    }
  }

  @override
  Future<List<CastModel>> getMoviesCast(int movieId) async {
    if (!await _isConnected()) {
      throw Exception("You are offline. No cached cast available.");
    }
    try {
      final response = await tmdbApi.getMovieCast(movieId, apiKey);
      return response.casts;
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List<MovieModel>> searchMovies(String query) async {
    try {
      if (!await _isConnected()) throw Exception("Offline");
      final response = await tmdbApi.searchMovie(apiKey, query);
      return response.results;
    } catch (e) {
      log("Search error: $e");
      return [];
    }
  }

  @override
  Future<String?> getMovieTrailerKey(int movieId) async {
    try {
      if (!await _isConnected()) throw Exception("Offline");

      final resp = await tmdbApi.getMovieVideos(movieId, apiKey, 'en-US');

      final trailerList =
          resp.results
              .where(
                (v) =>
                    v.site.toLowerCase() == 'youtube' &&
                    v.type.toLowerCase() == 'trailer',
              )
              .toList();

      if (trailerList.isNotEmpty) {
        return trailerList.first.key;
      }

      return null;
    } catch (e) {
      print('Trailer fetch failed: $e');
      return null;
    }
  }

  @override
  Future<void> toggleBookmark(MovieModel movie) async {
    final key = _createKey('bookmark', movie.id);

    if (moviesBox.containsKey(key)) {
      await moviesBox.delete(key);
      log("Removed bookmark: ${movie.title}");
    } else {
      await moviesBox.put(key, movie);
      log("Added bookmark: ${movie.title}");
    }
  }

  @override
  List<MovieModel> getBookMarkedMovies() {
    return _getCachedByPrefix('bookmark');
  }

  @override
  bool isBookmarked(int movieId) {
    final key = _createKey('bookmark', movieId);
    return moviesBox.containsKey(key);
  }
}

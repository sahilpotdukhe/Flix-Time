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
  final String apiKey;

  MovieRepositoryImp({
    required this.tmdbApi,
    required this.trendingBox,
    required this.nowPlayingBox,
    required this.movieDetailsBox,
    required this.apiKey,
  });

  Future<bool> _isConnected() async {
    final result = await Connectivity().checkConnectivity();
    return result != ConnectivityResult.none;
  }

  Future<List<MovieModel>> getTrendingMovies() async {
    try {
      print("📡 Trying to fetch trending movies from API...");

      if (!await _isConnected()) throw Exception("Offline");

      final response = await tmdbApi.getTrendingMovies(apiKey, 'en-US');
      final movies = response.results;

      print("✅ Got ${movies.length} trending movies from API");

      // Clear old cache and store individually
      await trendingBox.clear();
      for (final movie in movies) {
        await trendingBox.put(movie.id.toString(), movie);
      }

      print("💾 Stored ${movies.length} trending movies in Hive");
      return movies;
    } catch (e) {
      print("⚠️ Error fetching trending movies: $e");

      final cachedMovies = trendingBox.values.toList();
      if (cachedMovies.isEmpty) {
        print("❌ No cached trending movies found");
        throw Exception("No trending movies available offline.");
      }

      print("📦 Loaded ${cachedMovies.length} trending movies from Hive");
      return cachedMovies;
    }
  }

  Future<List<MovieModel>> getNowPlayingMovies() async {
    try {
      print("📡 Trying to fetch now playing movies from API...");

      if (!await _isConnected()) throw Exception("Offline");

      final response = await tmdbApi.getNowPlayingMovies(apiKey);
      final movies = response.results;

      print("✅ Got ${movies.length} now playing movies from API");

      // Clear old cache and store individually
      await nowPlayingBox.clear();
      for (final movie in movies) {
        await nowPlayingBox.put(movie.id.toString(), movie);
      }

      print("💾 Stored ${movies.length} now playing movies in Hive");
      return movies;
    } catch (e) {
      print("⚠️ Error fetching now playing movies: $e");

      final cachedMovies = nowPlayingBox.values.toList();
      if (cachedMovies.isEmpty) {
        print("❌ No cached now playing movies found");
        throw Exception("No now playing movies available offline.");
      }

      print("📦 Loaded ${cachedMovies.length} now playing movies from Hive");
      return cachedMovies;
    }
  }

  Future<void> cacheMovieDetails(MovieModel movie) async {
    await movieDetailsBox.put(movie.id.toString(), movie);
    print("💾 Cached movie detail for: ${movie.title}");
  }

  MovieModel? getCachedMovieDetails(int movieId) {
    final movie = movieDetailsBox.get(movieId.toString());
    if (movie != null) {
      print("📦 Loaded movie detail from cache: ${movie.title}");
    } else {
      print("❌ No cached details found for movie ID: $movieId");
    }
    return movie;
  }

  @override
  Future<MovieModel> getMovieDetails(int movieId) {
    // TODO: implement getMovieDetails
    throw UnimplementedError();
  }

  @override
  Future<List<MovieModel>> searchMovies(String query) {
    // TODO: implement searchMovies
    throw UnimplementedError();
  }
}

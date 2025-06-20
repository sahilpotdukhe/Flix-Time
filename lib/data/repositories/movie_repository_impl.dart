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

  @override
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

  @override
  Future<MovieModel> getMovieDetails(int movieId) async {
    final key = movieId.toString();

    // 1. Try from cache first
    final cached = movieDetailsBox.get(key);
    if (cached != null) {
      print("📦 Loaded movie detail from Hive cache: ${cached.title}");
      return cached;
    }

    // 2. Check network status
    if (!await _isConnected()) {
      print("❌ Offline and no cached data for movie ID: $movieId");
      throw Exception("You are offline. No cached details available.");
    }

    try {
      // 3. Fetch from API
      print("🌐 Fetching movie detail from TMDB API...");
      final movie = await tmdbApi.getMovieDetails(movieId, apiKey);

      // 4. Cache in Hive
      await movieDetailsBox.put(key, movie);
      print("💾 Cached movie detail for: ${movie.title}");

      return movie;
    } catch (e) {
      print("⚠️ Failed to fetch movie details: $e");
      throw Exception("Failed to load movie details.");
    }
  }

  @override
  Future<List<MovieModel>> searchMovies(String query) async {
    try {
      if (!await _isConnected()) throw Exception("Offline");
      final response = await tmdbApi.searchMovie(apiKey, query);
      return response.results;
    } catch (e) {
      print("Search error: $e");
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
      print("🔖 Removed bookmark: ${movie.title}");
    } else {
      await bookmarksBox.put(key, movie);
      print("🔖 Added bookmark: ${movie.title}");
    }
  }
}

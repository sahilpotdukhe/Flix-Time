import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:hive/hive.dart';
import 'package:tmdb_movies/data/api/tmdb_api.dart';
import 'package:tmdb_movies/models/tv_show_model.dart';
import 'package:tmdb_movies/data/repositories/tv_show_repository.dart';

class TvShowRepositoryImpl implements TvShowRepository {
  final TMDBApi tmdbApi;
  final Box<TvShowModel> tvBox;
  final String apiKey;

  TvShowRepositoryImpl({
    required this.tmdbApi,
    required this.tvBox,
    required this.apiKey,
  });

  Future<bool> _isConnected() async {
    final result = await Connectivity().checkConnectivity();
    return result != ConnectivityResult.none;
  }

  String _createKey(String prefix, int id) => '${prefix}_$id';

  Future<void> _clearCategory(String prefix) async {
    final keys = tvBox.keys.where((k) => k.toString().startsWith(prefix)).toList();
    await tvBox.deleteAll(keys);
  }

  List<TvShowModel> _getCachedByPrefix(String prefix) {
    return tvBox.toMap().entries
        .where((e) => e.key.toString().startsWith(prefix))
        .map((e) => e.value)
        .toList();
  }

  @override
  Future<List<TvShowModel>> getTrendingTvShows() async {
    try {
      if (!await _isConnected()) throw Exception("Offline");

      final response = await tmdbApi.getTrendingTVShows(apiKey);
      final trending = response.results;

      await _clearCategory('tvTrending');
      for (final tv in trending) {
        await tvBox.put(_createKey('tvTrending', tv.id), tv);
      }

      return trending;
    } catch (e) {
      return _getCachedByPrefix('tvTrending');
    }
  }

  @override
  Future<List<TvShowModel>> getPopularTvShows() async {
    try {
      if (!await _isConnected()) throw Exception("Offline");

      final response = await tmdbApi.getPopularTVShows(apiKey);
      final popular = response.results;

      await _clearCategory('tvPopular');
      for (final tv in popular) {
        await tvBox.put(_createKey('tvPopular', tv.id), tv);
      }

      return popular;
    } catch (e) {
      return _getCachedByPrefix('tvPopular');
    }
  }

  @override
  Future<List<TvShowModel>> getTopRatedTvShows() async {
    try {
      if (!await _isConnected()) throw Exception("Offline");

      final response = await tmdbApi.getTopRatedTVShows(apiKey);
      final topRated = response.results;

      await _clearCategory('tvTopRated');
      for (final tv in topRated) {
        await tvBox.put(_createKey('tvTopRated', tv.id), tv);
      }

      return topRated;
    } catch (e) {
      return _getCachedByPrefix('tvTopRated');
    }
  }

  @override
  Future<TvShowModel> getTvShowDetails(int tvId) async {
    final key = _createKey('tvDetails', tvId);
    final cached = tvBox.get(key);
    if (cached != null) return cached;

    if (!await _isConnected()) {
      throw Exception("You are offline. No cached details available.");
    }

    try {
      final details = await tmdbApi.getTvShowDetails(tvId, apiKey);
      await tvBox.put(key, details);
      return details;
    } catch (e) {
      throw Exception("Failed to fetch TV show details.");
    }
  }

  @override
  Future<void> toggleBookmark(TvShowModel tvShow) async {
    final key = _createKey('bookmark', tvShow.id);

    if (tvBox.containsKey(key)) {
      await tvBox.delete(key);
      log("Removed bookmark: ${tvShow.title}");
    } else {
      await tvBox.put(key, tvShow);
      log("Added bookmark: ${tvShow.title}");
    }
  }

  @override
  List<TvShowModel> getBookMarkedTvShows() {
    return _getCachedByPrefix('bookmark');
  }

  @override
  bool isBookmarked(int tvShowId) {
    final key = _createKey('bookmark', tvShowId);
    return tvBox.containsKey(key);
  }

  @override
  Future<List<TvShowModel>> searchTvShows(String query) async {
    try {
      if (!await _isConnected()) throw Exception("Offline");
      final response = await tmdbApi.searchTvShows(apiKey, query);
      return response.results;
    } catch (e) {
      log("Search error: $e");
      return [];
    }
  }

}

import 'package:tmdb_movies/models/movie_model.dart';
import 'package:tmdb_movies/models/tv_show_model.dart';

class SearchState {
  final List<MovieModel> searchMoviesResult;
  final List<TvShowModel> searchTvShowsResult;
  final bool isLoading;
  final String? error;

  SearchState({
    this.isLoading = false,
    this.searchMoviesResult = const [],
    this.searchTvShowsResult = const [],
    this.error,
  });

  SearchState copyWith({
    bool? isLoading,
    List<MovieModel>? searchMoviesResult,
    List<TvShowModel>? searchTvShowsResult,
    String? error,
  }) {
    return SearchState(
      isLoading: isLoading ?? this.isLoading,
      searchMoviesResult: searchMoviesResult ?? this.searchMoviesResult,
      searchTvShowsResult: searchTvShowsResult ?? this.searchTvShowsResult,
      error: error,
    );
  }
}

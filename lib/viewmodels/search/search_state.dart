import 'package:tmdb_movies/models/movie_model.dart';

class SearchState {
  final List<MovieModel> searchResult;
  final bool isLoading;
  final String? error;

  SearchState({
    this.isLoading = false,
    this.searchResult = const [],
    this.error,
  });

  SearchState copyWith({
    bool? isLoading,
    List<MovieModel>? searchResult,
    String? error,
  }) {
    return SearchState(
      isLoading: isLoading ?? this.isLoading,
      searchResult: searchResult ?? this.searchResult,
      error: error,
    );
  }
}

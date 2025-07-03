import 'package:tmdb_movies/models/movie_model.dart';
import 'package:tmdb_movies/models/tv_show_model.dart';

class BookmarksState {
  final List<MovieModel> movieBookmarks;
  final List<TvShowModel> tvShowBookmarks;

  BookmarksState({
    this.movieBookmarks = const [],
    this.tvShowBookmarks = const [],
  });

  BookmarksState copyWith({
    List<MovieModel>? movieBookmarks,
    List<TvShowModel>? tvShowBookmarks,
  }) {
    return BookmarksState(
      movieBookmarks: movieBookmarks ?? this.movieBookmarks,
      tvShowBookmarks: tvShowBookmarks ?? this.tvShowBookmarks,
    );
  }
}

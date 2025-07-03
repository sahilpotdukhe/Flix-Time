import 'package:tmdb_movies/models/movie_model.dart';
import 'package:tmdb_movies/models/tv_show_model.dart';

abstract class BookmarksEvent {}

class LoadMoviesBookmarks extends BookmarksEvent {}

class ToggleMoviesBookmark extends BookmarksEvent {
  final MovieModel movie;
  ToggleMoviesBookmark(this.movie);
}

class LoadTvShowBookmarks extends BookmarksEvent{}

class ToggleTvShowBookmark extends BookmarksEvent{
  final TvShowModel tvShowModel;
  ToggleTvShowBookmark(this.tvShowModel);
}

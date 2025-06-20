import 'package:tmdb_movies/models/movie_model.dart';

abstract class BookmarksEvent {}

class LoadBookmarks extends BookmarksEvent {}

class ToggleBookmark extends BookmarksEvent {
  final MovieModel movie;
  ToggleBookmark(this.movie);
}

import 'package:tmdb_movies/models/movie_model.dart';

class BookmarksState {
  final List<MovieModel> bookmarks;

  BookmarksState({this.bookmarks = const []});

  BookmarksState copyWith({List<MovieModel>? bookmarks}) {
    return BookmarksState(bookmarks: bookmarks ?? this.bookmarks);
  }
}

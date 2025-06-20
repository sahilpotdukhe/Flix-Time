import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tmdb_movies/data/repositories/movie_repository.dart';
import 'package:tmdb_movies/viewmodels/bookmarks/bookmarks_event.dart';
import 'package:tmdb_movies/viewmodels/bookmarks/bookmarks_state.dart';

class BookmarksBloc extends Bloc<BookmarksEvent, BookmarksState> {
  final MovieRepository movieRepository;

  BookmarksBloc({required this.movieRepository}) : super(BookmarksState()) {
    on<LoadBookmarks>(_onLoadBookmarks);
    on<ToggleBookmark>(_onToggleBookmark);
  }

  void _onLoadBookmarks(LoadBookmarks event, Emitter<BookmarksState> emit) {
    final bookmarks = movieRepository.getBookMarkedMovies();
    emit(state.copyWith(bookmarks: bookmarks));
  }

  void _onToggleBookmark(
    ToggleBookmark event,
    Emitter<BookmarksState> emit,
  ) async {
    await movieRepository.toggleBookmark(event.movie);
    final bookmarks = movieRepository.getBookMarkedMovies();
    emit(state.copyWith(bookmarks: bookmarks));
  }
}

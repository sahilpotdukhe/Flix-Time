import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tmdb_movies/data/repositories/movie_repository.dart';
import 'package:tmdb_movies/data/repositories/tv_show_repository.dart';
import 'package:tmdb_movies/viewmodels/bookmarks/bookmarks_event.dart';
import 'package:tmdb_movies/viewmodels/bookmarks/bookmarks_state.dart';

class BookmarksBloc extends Bloc<BookmarksEvent, BookmarksState> {
  final MovieRepository movieRepository;
  final TvShowRepository tvShowRepository;

  BookmarksBloc({required this.movieRepository, required this.tvShowRepository}) : super(BookmarksState()) {
    on<LoadMoviesBookmarks>(_onLoadMoviesBookmarks);
    on<LoadTvShowBookmarks>(_onLoadTvShowBookmarks);
    on<ToggleMoviesBookmark>(_onToggleMoviesBookmark);
    on<ToggleTvShowBookmark>(_onToggleTvShowBookmark);
  }

  void _onLoadMoviesBookmarks(LoadMoviesBookmarks event, Emitter<BookmarksState> emit) {
    final movieBookmarks = movieRepository.getBookMarkedMovies();
    emit(state.copyWith(movieBookmarks: movieBookmarks));
  }

  void _onToggleMoviesBookmark(
    ToggleMoviesBookmark event,
    Emitter<BookmarksState> emit,
  ) async {
    await movieRepository.toggleBookmark(event.movie);
    final movieBookmarks = movieRepository.getBookMarkedMovies();
    emit(state.copyWith(movieBookmarks: movieBookmarks));
  }

  void _onLoadTvShowBookmarks(LoadTvShowBookmarks event, Emitter<BookmarksState> emit) {
    final tvShowBookmarks = tvShowRepository.getBookMarkedTvShows();
    emit(state.copyWith(tvShowBookmarks: tvShowBookmarks));
  }

  void _onToggleTvShowBookmark(
      ToggleTvShowBookmark event,
      Emitter<BookmarksState> emit,
      ) async {
    await tvShowRepository.toggleBookmark(event.tvShowModel);
    final tvShowBookmarks = tvShowRepository.getBookMarkedTvShows();
    emit(state.copyWith(tvShowBookmarks:  tvShowBookmarks));
  }




}

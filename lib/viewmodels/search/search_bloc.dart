import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tmdb_movies/data/repositories/movie_repository.dart';
import 'package:tmdb_movies/viewmodels/search/search_event.dart';
import 'package:tmdb_movies/viewmodels/search/search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final MovieRepository movieRepository;

  SearchBloc({required this.movieRepository}) : super(SearchState()) {
    on<SearchQueryChanged>(_onSearchQueryChanged);
  }

  Future<void> _onSearchQueryChanged(
    SearchQueryChanged event,
    Emitter<SearchState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final searchResults = await movieRepository.searchMovies(event.query);
      emit(state.copyWith(isLoading: false, searchResult: searchResults));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }
}

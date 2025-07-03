import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tmdb_movies/data/repositories/movie_repository.dart';
import 'package:tmdb_movies/data/repositories/tv_show_repository.dart';
import 'trailer_event.dart';
import 'trailer_state.dart';

class TrailerBloc extends Bloc<TrailerEvent, TrailerState> {
  final MovieRepository movieRepository;
  final TvShowRepository tvShowRepository;

  TrailerBloc({required this.movieRepository, required this.tvShowRepository}) : super(TrailerState()) {
    on<FetchMovieTrailer>(_onFetchMovieTrailer);
    on<FetchTvShowTrailer>(_onFetchTvShowTrailer);
  }

  Future<void> _onFetchMovieTrailer(FetchMovieTrailer e, Emitter<TrailerState> emit) async {
    emit(state.copyWith(isLoading: true, error: null));
    final movieKey = await movieRepository.getMovieTrailerKey(e.movieId);
    if (movieKey != null) {
      emit(state.copyWith(isLoading: false, movieKey: movieKey));
    } else {
      emit(state.copyWith(isLoading: false, error: 'No trailer available'));
    }
  }

  Future<void> _onFetchTvShowTrailer(FetchTvShowTrailer e, Emitter<TrailerState> emit) async {
    emit(state.copyWith(isLoading: true, error: null));
    final tvKey = await tvShowRepository.getTvShowTrailerKey(e.tvShowId);
    if (tvKey != null) {
      emit(state.copyWith(isLoading: false, tvKey: tvKey));
    } else {
      emit(state.copyWith(isLoading: false, error: 'No trailer available'));
    }
  }
}

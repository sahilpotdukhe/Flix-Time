import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tmdb_movies/data/repositories/tv_show_repository.dart';
import 'tv_shows_event.dart';
import 'tv_shows_state.dart';

class TvShowsBloc extends Bloc<TvShowsEvent, TvShowsState> {
  final TvShowRepository tvRepository;

  TvShowsBloc({required this.tvRepository}) : super(TvShowsState()) {
    on<FetchTrendingTvShows>(_onFetchTrending);
    on<FetchPopularTvShows>(_onFetchPopular);
    on<FetchTopRatedTvShows>(_onFetchTopRated);
    on<FetchTvShowDetails>(_onFetchTvShowDetails);
  }

  Future<void> _onFetchTrending(
      FetchTrendingTvShows event, Emitter<TvShowsState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      final shows = await tvRepository.getTrendingTvShows();
      emit(state.copyWith(isLoading: false, trendingTvShows: shows));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> _onFetchPopular(
      FetchPopularTvShows event, Emitter<TvShowsState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      final shows = await tvRepository.getPopularTvShows();
      emit(state.copyWith(isLoading: false, popularTvShows: shows));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> _onFetchTopRated(
      FetchTopRatedTvShows event, Emitter<TvShowsState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      final shows = await tvRepository.getTopRatedTvShows();
      emit(state.copyWith(isLoading: false, topRatedTvShows: shows));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> _onFetchTvShowDetails(
      FetchTvShowDetails event,
      Emitter<TvShowsState> emit,
      ) async {
    emit(state.copyWith(isLoading: true, error: null));

    try {
      final tvShow = await tvRepository.getTvShowDetails(event.tvId);
      emit(state.copyWith(isLoading: false, tvShowDetails: tvShow));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }
}

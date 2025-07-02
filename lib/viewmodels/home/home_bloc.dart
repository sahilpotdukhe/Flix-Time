import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tmdb_movies/data/repositories/movie_repository.dart';
import 'package:tmdb_movies/viewmodels/home/home_events.dart';
import 'package:tmdb_movies/viewmodels/home/home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final MovieRepository movieRepository;

  HomeBloc({required this.movieRepository}) : super(const HomeState()) {
    on<FetchTrendingMovies>(_onFetchTrendingMovies);
    on<FetchNowPlayingMovies>(_onFetchNowPlayingMovies);
    on<FetchPopularMovies>(_onFetchPopularMovies);
    on<FetchTopRatedMovies>(_onFetchTopRatedMovies);
    on<FetchUpcomingMovies>(_onFetchUpcomingMovies);
  }

  Future<void> _onFetchTrendingMovies(
    FetchTrendingMovies event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final trendingMovies = await movieRepository.getTrendingMovies();
      emit(state.copyWith(trendingMovies: trendingMovies, isLoading: false));
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: "Failed to load trending movies",
        ),
      );
    }
  }

  Future<void> _onFetchNowPlayingMovies(
    FetchNowPlayingMovies event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final nowPlayingMovies = await movieRepository.getNowPlayingMovies();
      emit(
        state.copyWith(nowPlayingMovies: nowPlayingMovies, isLoading: false),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: "Failed to fetch now playing movies",
        ),
      );
    }
  }

  Future<void> _onFetchPopularMovies(
    FetchPopularMovies event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final popularMovies = await movieRepository.getPopularMovies();
      emit(state.copyWith(isLoading: false, popularMovies: popularMovies));
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: "Failed to fetch popular movies",
        ),
      );
    }
  }

  Future<void> _onFetchTopRatedMovies(
    FetchTopRatedMovies event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final topRated = await movieRepository.getTopRatedMovies();
      emit(state.copyWith(isLoading: false, topRatedMovies: topRated));
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: "Failed to fetch top rated movies",
        ),
      );
    }
  }

  Future<void> _onFetchUpcomingMovies(
      FetchUpcomingMovies event,
      Emitter<HomeState> emit,
      ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final upcoming = await movieRepository.getUpcomingMovies();
      emit(state.copyWith(isLoading: false, upcomingMovies: upcoming));
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: "Failed to fetch upcoming movies",
        ),
      );
    }
  }
}

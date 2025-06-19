import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tmdb_movies/data/repositories/movie_repository.dart';
import 'package:tmdb_movies/viewmodels/home/home_events.dart';
import 'package:tmdb_movies/viewmodels/home/home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final MovieRepository movieRepository;

  HomeBloc({required this.movieRepository}) : super(const HomeState()) {
    on<FetchTrendingMovies>(_onFetchTrendingMovies);
    on<FetchNowPlayingMovies>(_onFetchNowPlayingMovies);
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
      print("Trending error: $e"); // ✅ Add this
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
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tmdb_movies/data/repositories/movie_repository.dart';

import 'movie_details_event.dart';
import 'movie_details_state.dart';

class MovieDetailsBloc extends Bloc<MovieDetailsEvent, MovieDetailsState> {
  final MovieRepository movieRepository;

  MovieDetailsBloc({required this.movieRepository})
    : super(MovieDetailsState()) {
    on<FetchMovieDetails>(_onFetchMovieDetails);
    on<FetchSimilarMovies>(_onFetchSimilarMovies);
  }

  Future<void> _onFetchMovieDetails(
    FetchMovieDetails event,
    Emitter<MovieDetailsState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));

    try {
      final movie = await movieRepository.getMovieDetails(event.movieId);
      emit(state.copyWith(isLoading: false, movie: movie));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> _onFetchSimilarMovies(FetchSimilarMovies event,Emitter<MovieDetailsState> emit) async{
    emit(state.copyWith(isLoading: true,error: null));
    try{
      final similarMovies = await movieRepository.getSimilarMovies(event.movieId);
      emit(state.copyWith(isLoading: false,similarMovies: similarMovies));
    }catch(e){
      emit(state.copyWith(isLoading: false,error: e.toString()));
    }

  }
}

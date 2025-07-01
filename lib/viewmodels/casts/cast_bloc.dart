import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tmdb_movies/data/repositories/movie_repository.dart';
import 'package:tmdb_movies/data/repositories/movie_repository_impl.dart';
import 'package:tmdb_movies/viewmodels/casts/cast_event.dart';
import 'package:tmdb_movies/viewmodels/casts/cast_state.dart';

class CastBloc extends Bloc<CastEvent, CastState> {
  final MovieRepository movieRepository;

  CastBloc({required this.movieRepository}) : super(CastState()) {
    on<FetchCast>(_onFetchCast);
  }

  void _onFetchCast(FetchCast event,Emitter<CastState> emit) async{
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try{
      final casts = await movieRepository.getMoviesCast(event.movieId);
      emit(state.copyWith(isLoading: false,casts: casts));
    }catch(e){
      emit(state.copyWith(isLoading: false,errorMessage: e.toString()));
    }
  }
}

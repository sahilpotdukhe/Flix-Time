import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tmdb_movies/data/repositories/movie_repository.dart';
import 'trailer_event.dart';
import 'trailer_state.dart';

class TrailerBloc extends Bloc<TrailerEvent, TrailerState> {
  final MovieRepository repo;
  TrailerBloc(this.repo) : super(TrailerState()) {
    on<FetchTrailer>(_onFetchTrailer);
  }

  Future<void> _onFetchTrailer(FetchTrailer e, Emitter<TrailerState> emit) async {
    emit(state.copyWith(isLoading: true, error: null));
    final key = await repo.getMovieTrailerKey(e.movieId);
    if (key != null) {
      emit(state.copyWith(isLoading: false, key: key));
    } else {
      emit(state.copyWith(isLoading: false, error: 'No trailer available'));
    }
  }
}

abstract class TrailerEvent {}
class FetchMovieTrailer extends TrailerEvent {
  final int movieId;
  FetchMovieTrailer(this.movieId);
}

class FetchTvShowTrailer extends TrailerEvent {
  final int tvShowId;
  FetchTvShowTrailer(this.tvShowId);
}
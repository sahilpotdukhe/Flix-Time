abstract class TrailerEvent {}
class FetchTrailer extends TrailerEvent {
  final int movieId;
  FetchTrailer(this.movieId);
}

abstract class CastEvent {}

class FetchCast extends CastEvent{
  final int movieId;

  FetchCast(this.movieId);
}
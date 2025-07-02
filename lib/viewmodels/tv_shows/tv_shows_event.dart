import 'package:equatable/equatable.dart';

abstract class TvShowsEvent extends Equatable {
  const TvShowsEvent();

  @override
  List<Object?> get props => [];
}

class FetchTrendingTvShows extends TvShowsEvent {}

class FetchPopularTvShows extends TvShowsEvent {}

class FetchTopRatedTvShows extends TvShowsEvent {}

class FetchTvShowDetails extends TvShowsEvent {
  final int tvId;
  const FetchTvShowDetails({required this.tvId});
}

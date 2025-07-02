import 'package:equatable/equatable.dart';
import 'package:tmdb_movies/models/tv_show_model.dart';

class TvShowsState extends Equatable {
  final bool isLoading;
  final List<TvShowModel> trendingTvShows;
  final List<TvShowModel> popularTvShows;
  final List<TvShowModel> topRatedTvShows;
  final TvShowModel? tvShowDetails;
  final String? error;

  const TvShowsState({
    this.isLoading = false,
    this.trendingTvShows= const [],
    this.popularTvShows= const [],
    this.topRatedTvShows= const [],
    this.tvShowDetails,
    this.error,
  });

  TvShowsState copyWith({
    bool? isLoading,
    List<TvShowModel>? trending,
    List<TvShowModel>? popular,
    List<TvShowModel>? topRated,
    TvShowModel? tvShowDetails,
    String? error,
  }) {
    return TvShowsState(
      isLoading: isLoading ?? this.isLoading,
      trendingTvShows: trending ?? this.trendingTvShows,
      popularTvShows: popular ?? this.popularTvShows,
      topRatedTvShows: topRated ?? this.topRatedTvShows,
      tvShowDetails: tvShowDetails ?? this.tvShowDetails,
      error: error,
    );
  }

  @override
  List<Object?> get props => [isLoading, trendingTvShows, popularTvShows, topRatedTvShows, error];
}

import 'package:tmdb_movies/models/tv_show_model.dart';

abstract class TvShowRepository {
  Future<List<TvShowModel>> getTrendingTvShows();
  Future<List<TvShowModel>> getPopularTvShows();
  Future<List<TvShowModel>> getTopRatedTvShows();
  Future<TvShowModel> getTvShowDetails(int tvId);
  Future<void> toggleBookmark(TvShowModel tvShow);
  List<TvShowModel> getBookMarkedTvShows();
  bool isBookmarked(int tvShowId);
  Future<List<TvShowModel>> searchTvShows(String query);
}

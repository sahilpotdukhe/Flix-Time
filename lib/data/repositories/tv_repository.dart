import 'package:tmdb_movies/models/tv_show_model.dart';

abstract class TvRepository {
  Future<List<TvShowModel>> getTrendingTvShows();
  Future<List<TvShowModel>> getPopularTvShows();
  Future<List<TvShowModel>> getTopRatedTvShows();
  Future<TvShowModel> getTvShowDetails(int tvId);
}

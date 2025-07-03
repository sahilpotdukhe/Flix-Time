import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';
import 'package:tmdb_movies/models/movie_casts_response.dart';
import 'package:tmdb_movies/models/movie_list_response.dart';
import 'package:tmdb_movies/models/movie_model.dart';
import 'package:tmdb_movies/models/movie_videos_response.dart';
import 'package:tmdb_movies/models/tv_show_list_response.dart';
import 'package:tmdb_movies/models/tv_show_model.dart';

part 'tmdb_api.g.dart';

@RestApi(baseUrl: 'https://api.themoviedb.org/3/')
abstract class TMDBApi {
  factory TMDBApi(Dio dio, {String baseUrl}) = _TMDBApi;

  @GET("trending/movie/day")
  Future<MovieListResponse> getTrendingMovies(
    @Query("api_key") String apiKey,
    @Query("language") String language,
  );

  @GET("movie/now_playing")
  Future<MovieListResponse> getNowPlayingMovies(
    @Query("api_key") String apiKey,
  );

  @GET("movie/top_rated")
  Future<MovieListResponse> getTopRatedMovies(@Query("api_key") String apiKey);

  @GET("movie/popular")
  Future<MovieListResponse> getPopularMovies(@Query("api_key") String apiKey);

  @GET("movie/upcoming")
  Future<MovieListResponse> getUpcomingMovies(@Query("api_key") String apiKey);

  @GET("movie/{movie_id}/similar")
  Future<MovieListResponse> getSimilarMovies(
    @Path("movie_id") int movieId,
    @Query("api_key") String apiKey,
  );

  @GET("movie/{movie_id}")
  Future<MovieModel> getMovieDetails(
    @Path("movie_id") int movieId,
    @Query("api_key") String apiKey,
  );

  @GET("movie/{movie_id}/credits")
  Future<MovieCastsResponse> getMovieCast(
    @Path("movie_id") int movieId,
    @Query("api_key") String apiKey,
  );

  @GET("search/movie")
  Future<MovieListResponse> searchMovie(
    @Query("api_key") String apiKey,
    @Query("query") String query,
  );

  @GET('movie/{movie_id}/videos')
  Future<MovieVideosResponse> getMovieVideos(
    @Path('movie_id') int id,
    @Query('api_key') String apiKey,
    @Query('language') String lang,
  );

  @GET("trending/tv/day")
  Future<TvShowListResponse> getTrendingTVShows(
    @Query("api_key") String apiKey,
  );

  @GET("tv/popular")
  Future<TvShowListResponse> getPopularTVShows(@Query("api_key") String apiKey);

  @GET("tv/top_rated")
  Future<TvShowListResponse> getTopRatedTVShows(
    @Query("api_key") String apiKey,
  );

  @GET("tv/{tv_id}")
  Future<TvShowModel> getTvShowDetails(
    @Path("tv_id") int tvId,
    @Query("api_key") String apiKey,
  );

  @GET("search/tv")
  Future<TvShowListResponse> searchTvShows(
    @Query("api_key") String apiKey,
    @Query("query") String query,
  );

  @GET('tv/{tvShowId}/videos')
  Future<MovieVideosResponse> getTvShowVideos(
    @Path('tvShowId') int tvShowId,
    @Query('api_key') String apiKey,
    @Query('language') String lang,
  );
}

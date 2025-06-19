import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';
import 'package:tmdb_movies/models/movie_list_response.dart';
import 'package:tmdb_movies/models/movie_model.dart';

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

  @GET("movie/{movie_id}")
  Future<MovieModel> getMovieDetails(
    @Path("movie_id") int movieId,
    @Query("api_key") String apiKey,
  );

  @GET("search/movie")
  Future<MovieListResponse> searchMovie(
    @Query("api_key") String apiKey,
    @Query("query") String query,
  );
}

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:tmdb_movies/data/api/tmdb_api.dart';
import 'package:tmdb_movies/data/repositories/movie_repository.dart';
import 'package:tmdb_movies/data/repositories/movie_repository_impl.dart';
import 'package:tmdb_movies/data/repositories/tv_show_repository.dart';
import 'package:tmdb_movies/data/repositories/tv_show_repository_impl.dart';
import 'package:tmdb_movies/models/movie_model.dart';
import 'package:tmdb_movies/viewmodels/bookmarks/bookmarks_bloc.dart';
import 'package:tmdb_movies/viewmodels/bookmarks/bookmarks_event.dart';
import 'package:tmdb_movies/viewmodels/home/home_bloc.dart';
import 'package:tmdb_movies/viewmodels/home/home_events.dart';
import 'package:tmdb_movies/viewmodels/tv_shows/tv_shows_bloc.dart';
import 'package:tmdb_movies/viewmodels/tv_shows/tv_shows_event.dart';
import 'package:tmdb_movies/views/splash/splash_screen.dart';

import 'models/tv_show_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  await Hive.initFlutter();
  Hive.registerAdapter(MovieModelAdapter());
  Hive.registerAdapter(TvShowModelAdapter());

  final moviesBox = await Hive.openBox<MovieModel>('moviesBox');
  final tvBox = await Hive.openBox<TvShowModel>('tvBox');

  final dio = Dio();
  final apiKey = dotenv.env['TMDB_API_KEY'];

  if (apiKey == null || apiKey.isEmpty) {
    throw Exception("API key not found in .env file.");
  }

  final tmdbApi = TMDBApi(dio);
  final MovieRepository movieRepository = MovieRepositoryImp(
    tmdbApi: tmdbApi,
    moviesBox: moviesBox,
    apiKey: apiKey
  );

  final tvShowRepository = TvShowRepositoryImpl(
    tmdbApi: tmdbApi,
    tvBox: tvBox,
    apiKey: apiKey,
  );

  runApp(MyApp(movieRepository: movieRepository,tvShowRepository: tvShowRepository,));
}

class MyApp extends StatelessWidget {
  final MovieRepository movieRepository;
  final TvShowRepository tvShowRepository;

  const MyApp({
    super.key,
    required this.movieRepository,
    required this.tvShowRepository,
  });

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<MovieRepository>.value(value: movieRepository),
        RepositoryProvider<TvShowRepository>.value(value: tvShowRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => HomeBloc(movieRepository: movieRepository)
              ..add(FetchTrendingMovies())
              ..add(FetchNowPlayingMovies())
              ..add(FetchPopularMovies())
              ..add(FetchTopRatedMovies())
              ..add(FetchUpcomingMovies()),
          ),
          BlocProvider(
            create: (_) => BookmarksBloc(
              movieRepository: movieRepository,
              tvShowRepository: tvShowRepository,
            )
              ..add(LoadMoviesBookmarks())
              ..add(LoadTvShowBookmarks()),
          ),
          BlocProvider(
            create: (_) => TvShowsBloc(tvRepository: tvShowRepository)
              ..add(FetchTrendingTvShows())
              ..add(FetchPopularTvShows())
              ..add(FetchTopRatedTvShows()),
          ),
        ],
        child: MaterialApp(
          title: 'Movies App',
          debugShowCheckedModeBanner: false,
          theme: ThemeData.dark().copyWith(
            scaffoldBackgroundColor: Colors.black,
            appBarTheme: const AppBarTheme(backgroundColor: Colors.black),
          ),
          home: const SplashScreen(),
        ),
      ),
    );
  }
}

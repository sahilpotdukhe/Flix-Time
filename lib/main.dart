import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:tmdb_movies/data/api/tmdb_api.dart';
import 'package:tmdb_movies/data/repositories/movie_repository.dart';
import 'package:tmdb_movies/data/repositories/movie_repository_impl.dart';
import 'package:tmdb_movies/models/movie_model.dart';
import 'package:tmdb_movies/viewmodels/bookmarks/bookmarks_bloc.dart';
import 'package:tmdb_movies/viewmodels/bookmarks/bookmarks_event.dart';
import 'package:tmdb_movies/viewmodels/home/home_bloc.dart';
import 'package:tmdb_movies/viewmodels/home/home_events.dart';
import 'package:tmdb_movies/views/home/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  await Hive.initFlutter();
  Hive.registerAdapter(MovieModelAdapter());

  final trendingBox = await Hive.openBox<MovieModel>('trendingBox');
  final nowPlayingBox = await Hive.openBox<MovieModel>('nowPlayingBox');
  final detailsBox = await Hive.openBox<MovieModel>('movieDetailsBox');
  final bookmarksBox = await Hive.openBox<MovieModel>('bookmarksBox');

  final dio = Dio();
  final apiKey = dotenv.env['TMDB_API_KEY'];

  if (apiKey == null || apiKey.isEmpty) {
    throw Exception("API key not found in .env file.");
  }

  final tmdbApi = TMDBApi(dio);
  final MovieRepository movieRepository = MovieRepositoryImp(
    tmdbApi: tmdbApi,
    trendingBox: trendingBox,
    nowPlayingBox: nowPlayingBox,
    movieDetailsBox: detailsBox,
    bookmarksBox: bookmarksBox,
    apiKey: apiKey,
  );

  runApp(MyApp(movieRepository: movieRepository));
}

class MyApp extends StatelessWidget {
  final MovieRepository movieRepository;
  const MyApp({super.key, required this.movieRepository});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<MovieRepository>.value(
      value: movieRepository,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create:
                (_) =>
                    HomeBloc(movieRepository: movieRepository)
                      ..add(FetchTrendingMovies())
                      ..add(FetchNowPlayingMovies()),
          ),
          BlocProvider(
            create:
                (_) =>
                    BookmarksBloc(movieRepository: movieRepository)
                      ..add(LoadBookmarks()),
          ),
        ],
        child: MaterialApp(
          title: 'Movies App',
          debugShowCheckedModeBanner: false,
          theme: ThemeData.dark().copyWith(
            scaffoldBackgroundColor: Colors.black,
            appBarTheme: const AppBarTheme(backgroundColor: Colors.black),
          ),
          home: const HomeScreen(),
        ),
      ),
    );
  }
}

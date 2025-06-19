import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:tmdb_movies/data/api/tmdb_api.dart';
import 'package:tmdb_movies/data/repositories/movie_repository_impl.dart';
import 'package:tmdb_movies/models/movie_model.dart';
import 'package:tmdb_movies/viewmodels/home/home_bloc.dart';
import 'package:tmdb_movies/viewmodels/home/home_events.dart';
import 'package:tmdb_movies/views/home/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  await Hive.initFlutter();
  Hive.registerAdapter(MovieModelAdapter());

  await Hive.openBox<List<MovieModel>>('movieBox');
  await Hive.openBox<MovieModel>('movieDetailsBox');

  final moviesBox = Hive.box<List<MovieModel>>('movieBox');
  final detailsBox = Hive.box<MovieModel>('movieDetailsBox');

  final dio = Dio();
  final apiKey = dotenv.env['TMDB_API_KEY'];
  final tmdbApi = TMDBApi(dio);
  final movieRepository = MovieRepositoryImp(
    tmdbApi: tmdbApi,
    cacheBox: moviesBox,
    movieDetailsBox: detailsBox,
    apiKey: apiKey!,
  );

  runApp(MyApp(movieRepository: movieRepository));
}

class MyApp extends StatelessWidget {
  final MovieRepositoryImp movieRepository;
  const MyApp({super.key, required this.movieRepository});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movies App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: const AppBarTheme(backgroundColor: Colors.black),
      ),
      home: BlocProvider(
        create:
            (_) =>
                HomeBloc(movieRepository: movieRepository)
                  ..add(FetchTrendingMovies())
                  ..add(FetchNowPlayingMovies()),
        child: const HomeScreen(),
      ),
    );
  }
}

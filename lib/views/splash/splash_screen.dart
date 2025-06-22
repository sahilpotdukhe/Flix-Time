import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tmdb_movies/data/repositories/movie_repository.dart';
import 'package:tmdb_movies/viewmodels/home/home_bloc.dart';
import 'package:tmdb_movies/viewmodels/home/home_events.dart';
import 'package:tmdb_movies/views/home/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late final MovieRepository repository;

  @override
  void initState() {
    super.initState();
    repository = RepositoryProvider.of<MovieRepository>(context);
    _preloadData();
  }

  Future<void> _preloadData() async {
    await repository.getTrendingMovies();
    await repository.getNowPlayingMovies();

    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: CircularProgressIndicator(color: Colors.redAccent),
      ),
    );
  }
}

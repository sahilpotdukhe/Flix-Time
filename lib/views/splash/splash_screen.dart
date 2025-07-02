import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tmdb_movies/viewmodels/home/home_bloc.dart';
import 'package:tmdb_movies/viewmodels/home/home_state.dart';
import 'package:tmdb_movies/views/home/bottom_navigation_bar.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: BlocConsumer<HomeBloc, HomeState>(
        listener: (context, state) {
          final hasData = state.trendingMovies.isNotEmpty ||
              state.nowPlayingMovies.isNotEmpty ||
              state.popularMovies.isNotEmpty ||
              state.topRatedMovies.isNotEmpty ||
              state.upcomingMovies.isNotEmpty;

          if (hasData) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const HomeScreen()),
            );
          }
        },
        builder: (context, state) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.redAccent),
          );
        },
      ),
    );
  }
}

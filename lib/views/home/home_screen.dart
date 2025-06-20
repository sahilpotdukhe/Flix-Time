import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tmdb_movies/models/movie_model.dart';
import 'package:tmdb_movies/viewmodels/home/home_bloc.dart';
import 'package:tmdb_movies/viewmodels/home/home_events.dart';
import 'package:tmdb_movies/viewmodels/home/home_state.dart';
import 'package:tmdb_movies/views/widgets/network_image_with_fallback.dart';
import 'package:tmdb_movies/views/widgets/network_status_banner.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movies App'),
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          const NetworkStatusBanner(),
          Expanded(
            child: BlocBuilder<HomeBloc, HomeState>(
              builder: (context, state) {
                if (state.isLoading &&
                    state.trendingMovies.isEmpty &&
                    state.nowPlayingMovies.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state.errorMessage != null) {
                  return Center(child: Text(state.errorMessage!));
                }
                return RefreshIndicator(
                  onRefresh: () async {
                    context.read<HomeBloc>().add(FetchTrendingMovies());
                    context.read<HomeBloc>().add(FetchNowPlayingMovies());
                  },
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionTitle("Trending Movies"),
                        const SizedBox(height: 8),
                        _buildMovieList(state.trendingMovies),

                        const SizedBox(height: 24),

                        _buildSectionTitle("Now Playing Movies"),
                        const SizedBox(height: 8),
                        _buildMovieList(state.nowPlayingMovies),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildMovieList(List<MovieModel> movies) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 230,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          separatorBuilder: (context, index) => const SizedBox(width: 14),
          itemCount: movies.length,
          itemBuilder: (context, index) {
            final movie = movies[index];
            final posterUrl =
                'https://image.tmdb.org/t/p/w500${movie.posterPath}';
            return GestureDetector(
              onTap: () {},
              child: SizedBox(
                width: 140,
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: NetworkImageWithFallback(
                        imageUrl: posterUrl,
                        height: 180,
                        width: 140,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      movie.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

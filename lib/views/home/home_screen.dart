import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tmdb_movies/models/movie_model.dart';
import 'package:tmdb_movies/viewmodels/home/home_bloc.dart';
import 'package:tmdb_movies/viewmodels/home/home_events.dart';
import 'package:tmdb_movies/viewmodels/home/home_state.dart';
import 'package:tmdb_movies/views/bookmarks/bookmarks_screen.dart';
import 'package:tmdb_movies/views/movie_details/movie_details_screen.dart';
import 'package:tmdb_movies/views/search/search_screen.dart';
import 'package:tmdb_movies/views/widgets/network_image_with_fallback.dart';
import 'package:tmdb_movies/views/widgets/network_status_banner.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF101010),
      appBar: AppBar(
        title: const Text(
          'Movies',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SearchScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.bookmark, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => BookmarksScreen()),
              );
            },
          ),
        ],
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
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.redAccent),
                  );
                }

                if (state.errorMessage != null) {
                  return Center(
                    child: Text(
                      state.errorMessage!,
                      style: const TextStyle(color: Colors.white70),
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    context.read<HomeBloc>().add(FetchTrendingMovies());
                    context.read<HomeBloc>().add(FetchNowPlayingMovies());
                  },
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionTitle("Trending"),
                        _buildMovieList(state.trendingMovies),

                        const SizedBox(height: 20),

                        _buildSectionTitle("Now Playing"),
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildMovieList(List<MovieModel> movies) {
    return SizedBox(
      height: 250,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        scrollDirection: Axis.horizontal,
        itemCount: movies.length,
        separatorBuilder: (_, __) => const SizedBox(width: 14),
        itemBuilder: (context, index) {
          final movie = movies[index];
          final posterUrl =
              'https://image.tmdb.org/t/p/w500${movie.posterPath}';

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MovieDetailsScreen(movieId: movie.id),
                ),
              );
            },
            child: Container(
              width: 140,
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    offset: const Offset(2, 4),
                    blurRadius: 6,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                    child: NetworkImageWithFallback(
                      imageUrl: posterUrl,
                      height: 180,
                      width: 140,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      movie.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

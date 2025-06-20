import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tmdb_movies/viewmodels/bookmarks/bookmarks_bloc.dart';
import 'package:tmdb_movies/viewmodels/bookmarks/bookmarks_event.dart';
import 'package:tmdb_movies/viewmodels/bookmarks/bookmarks_state.dart';
import 'package:tmdb_movies/viewmodels/movie_details/movie_details_bloc.dart';
import 'package:tmdb_movies/viewmodels/movie_details/movie_details_event.dart';
import 'package:tmdb_movies/viewmodels/movie_details/movie_details_state.dart';
import 'package:tmdb_movies/views/widgets/network_image_with_fallback.dart';

class MovieDetailsScreen extends StatelessWidget {
  final int movieId;

  const MovieDetailsScreen({super.key, required this.movieId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MovieDetailsBloc>(
      create:
          (context) =>
              MovieDetailsBloc(movieRepository: context.read())
                ..add(FetchMovieDetails(movieId: movieId)),
      child: Builder(builder: (context) => _MovieDetailsView(movieId: movieId)),
    );
  }
}

class _MovieDetailsView extends StatelessWidget {
  final int movieId;
  const _MovieDetailsView({required this.movieId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E0E0E),
      appBar: AppBar(
        backgroundColor: Colors.black87,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Movie Details',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: BlocBuilder<MovieDetailsBloc, MovieDetailsState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.redAccent),
            );
          }

          if (state.error != null) {
            return Center(
              child: Text(
                "Error: ${state.error!}",
                style: const TextStyle(color: Colors.white),
              ),
            );
          }

          final movie = state.movie;
          if (movie == null) {
            return const Center(
              child: Text(
                "Movie not found",
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          final posterUrl =
              'https://image.tmdb.org/t/p/w500${movie.posterPath}';

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: NetworkImageWithFallback(
                      imageUrl: posterUrl,
                      height: 350,
                      width: 240,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // 🔖 Bookmark Button
                Center(
                  child: BlocBuilder<BookmarksBloc, BookmarksState>(
                    builder: (context, state) {
                      final isBookmarked = state.bookmarks.any(
                        (m) => m.id == movie.id,
                      );

                      return GestureDetector(
                        onTap: () {
                          context.read<BookmarksBloc>().add(
                            ToggleBookmark(movie),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                isBookmarked
                                    ? Icons.bookmark
                                    : Icons.bookmark_border,
                                color: Colors.amber,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                isBookmarked
                                    ? "Bookmarked"
                                    : "Add to Bookmarks",
                                style: const TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 24),

                Text(
                  movie.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 10),

                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today_rounded,
                      size: 18,
                      color: Colors.white70,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      movie.releaseDate ?? 'Unknown',
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amberAccent, size: 20),
                    const SizedBox(width: 6),
                    Text(
                      movie.voteAverage.toString(),
                      style: const TextStyle(color: Colors.amberAccent),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                const Text(
                  "Overview",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  movie.overview.isNotEmpty
                      ? movie.overview
                      : 'No description available.',
                  style: const TextStyle(
                    fontSize: 15,
                    height: 1.5,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

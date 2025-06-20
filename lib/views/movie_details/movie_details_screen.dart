import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tmdb_movies/models/movie_model.dart';
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
          (context) => MovieDetailsBloc(
            movieRepository: context.read(), // Provided at root
          )..add(FetchMovieDetails(movieId: movieId)),
      child: Builder(
        builder: (context) {
          return _MovieDetailsView(movieId: movieId);
        },
      ),
    );
  }
}

class _MovieDetailsView extends StatelessWidget {
  final int movieId;
  const _MovieDetailsView({required this.movieId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Movie Details")),
      body: BlocBuilder<MovieDetailsBloc, MovieDetailsState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.error != null) {
            return Center(child: Text("Error: ${state.error!}"));
          }

          final MovieModel? movie = state.movie;
          if (movie == null) {
            return const Center(child: Text("Movie not found"));
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
                    borderRadius: BorderRadius.circular(12),
                    child: NetworkImageWithFallback(
                      imageUrl: posterUrl,
                      height: 300,
                      width: 200,
                    ),
                  ),
                ),
                BlocBuilder<BookmarksBloc, BookmarksState>(
                  builder: (context, state) {
                    final isBookmarked = state.bookmarks.any(
                      (m) => m.id == movie.id,
                    );

                    return Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        icon: Icon(
                          isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                          color: Colors.amber,
                          size: 30,
                        ),
                        onPressed: () {
                          context.read<BookmarksBloc>().add(
                            ToggleBookmark(movie),
                          );
                        },
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                Text(
                  movie.title,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Release Date: ${movie.releaseDate ?? 'Unknown'}",
                  style: const TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 8),
                Text(
                  "Rating: ${movie.voteAverage.toString()} ⭐",
                  style: const TextStyle(color: Colors.amberAccent),
                ),
                const SizedBox(height: 16),
                Text(
                  movie.overview.isNotEmpty
                      ? movie.overview
                      : 'No description available.',
                  style: const TextStyle(fontSize: 16, color: Colors.white70),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tmdb_movies/data/repositories/movie_repository_impl.dart';
import 'package:tmdb_movies/viewmodels/bookmarks/bookmarks_bloc.dart';
import 'package:tmdb_movies/viewmodels/bookmarks/bookmarks_state.dart';
import 'package:tmdb_movies/views/movie_details/movie_details_screen.dart';
import 'package:tmdb_movies/views/widgets/network_image_with_fallback.dart';

class BookmarksScreen extends StatelessWidget {
  const BookmarksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E0E0E),
      appBar: AppBar(
        backgroundColor: Colors.black87,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Bookmarked Movies',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: BlocBuilder<BookmarksBloc, BookmarksState>(
        builder: (context, state) {
          if (state.bookmarks.isEmpty) {
            return const Center(
              child: Text(
                'No bookmarks found',
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: state.bookmarks.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final movie = state.bookmarks[index];
              final posterUrl =
                  'https://image.tmdb.org/t/p/w500${movie.posterPath}';

              return GestureDetector(
                onTap: () {
                  // final movieRepository = context.read<MovieRepositoryImp>();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) => MovieDetailsScreen(
                            // movieRepository: movieRepository,
                            movieId: movie.id,
                          ),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: NetworkImageWithFallback(
                          imageUrl: posterUrl,
                          height: 80,
                          width: 60,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              movie.title,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "⭐ ${movie.voteAverage}   |   📅 ${movie.releaseDate ?? 'N/A'}",
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.amberAccent,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              movie.overview.isNotEmpty
                                  ? movie.overview.length > 100
                                      ? "${movie.overview.substring(0, 100)}..."
                                      : movie.overview
                                  : "No description available.",
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

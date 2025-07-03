import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tmdb_movies/viewmodels/bookmarks/bookmarks_bloc.dart';
import 'package:tmdb_movies/viewmodels/bookmarks/bookmarks_state.dart';
import 'package:tmdb_movies/viewmodels/casts/cast_bloc.dart';
import 'package:tmdb_movies/viewmodels/movie_details/movie_details_bloc.dart';
import 'package:tmdb_movies/viewmodels/trailer/trailer_bloc.dart';
import 'package:tmdb_movies/views/movie_details/movie_details_screen.dart';
import 'package:tmdb_movies/views/tv_show_details/tv_show_detail_screen.dart';
import 'package:tmdb_movies/views/widgets/network_image_with_fallback.dart';
import 'package:tmdb_movies/views/widgets/quiet_state_box.dart';

class BookmarksScreen extends StatelessWidget {
  const BookmarksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E0E0E),
      appBar: AppBar(
        backgroundColor: Colors.amberAccent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Bookmarks',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: BlocBuilder<BookmarksBloc, BookmarksState>(
        builder: (context, state) {
          final movies = state.movieBookmarks;
          final tvShows = state.tvShowBookmarks;

          if (movies.isEmpty && tvShows.isEmpty) {
            return const Center(
              child: QuietStateBox(title: 'No bookmarks found', subtitle: 'You haven\'t bookmarked any movies or tv shows')
            );
          }

          return ListView(
            padding: const EdgeInsets.all(12),
            children: [
              if (movies.isNotEmpty) ...[
                const _SectionHeader(title: "Bookmarked Movies"),
                const SizedBox(height: 10),
                ...movies.map((movie) => _BookmarkCard(
                  posterUrl:
                  'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                  title: movie.title,
                  subtitle:
                  "⭐ ${movie.voteAverage}   |   📅 ${movie.releaseDate}",
                  description: movie.overview,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => MultiBlocProvider(
                          providers: [
                            BlocProvider(create: (_) => MovieDetailsBloc(movieRepository: context.read())),
                            BlocProvider(create: (_) => CastBloc(movieRepository: context.read())),
                            BlocProvider(create: (_) => TrailerBloc(movieRepository: context.read(),tvShowRepository: context.read())),
                          ],
                          child: MovieDetailsScreen(movieId: movie.id),
                        ),
                      ),
                    );
                  },
                )),
              ],
              if (tvShows.isNotEmpty) ...[
                const SizedBox(height: 20),
                const _SectionHeader(title: "Bookmarked TV Shows"),
                const SizedBox(height: 10),
                ...tvShows.map((tv) => _BookmarkCard(
                  posterUrl:
                  'https://image.tmdb.org/t/p/w500${tv.posterPath}',
                  title: tv.title,
                  subtitle:
                  "⭐ ${tv.voteAverage}   |   📅 ${tv.firstAirDate}",
                  description: tv.overview,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => TvShowDetailsScreen(tvShowId: tv.id),
                      ),
                    );
                  },
                )),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }
}

class _BookmarkCard extends StatelessWidget {
  final String posterUrl;
  final String title;
  final String subtitle;
  final String description;
  final VoidCallback onTap;

  const _BookmarkCard({
    required this.posterUrl,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
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
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.amberAccent,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    description.isNotEmpty
                        ? description.length > 100
                        ? "${description.substring(0, 100)}..."
                        : description
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
  }
}

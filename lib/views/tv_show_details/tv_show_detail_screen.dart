import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tmdb_movies/viewmodels/bookmarks/bookmarks_bloc.dart';
import 'package:tmdb_movies/viewmodels/bookmarks/bookmarks_event.dart';
import 'package:tmdb_movies/viewmodels/bookmarks/bookmarks_state.dart';
import 'package:tmdb_movies/viewmodels/tv_shows/tv_shows_bloc.dart';
import 'package:tmdb_movies/viewmodels/tv_shows/tv_shows_event.dart';
import 'package:tmdb_movies/viewmodels/tv_shows/tv_shows_state.dart';
import 'package:tmdb_movies/viewmodels/trailer/trailer_bloc.dart';
import 'package:tmdb_movies/viewmodels/trailer/trailer_event.dart';
import 'package:tmdb_movies/viewmodels/trailer/trailer_state.dart';
import 'package:tmdb_movies/views/widgets/network_image_with_fallback.dart';
import 'package:tmdb_movies/views/widgets/quiet_state_box.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class TvShowDetailsScreen extends StatefulWidget {
  final int tvShowId;

  const TvShowDetailsScreen({super.key, required this.tvShowId});

  @override
  State<TvShowDetailsScreen> createState() => _TvShowDetailsScreenState();
}

class _TvShowDetailsScreenState extends State<TvShowDetailsScreen> {
  YoutubePlayerController? _ytController;

  @override
  void initState() {
    super.initState();
    context.read<TvShowsBloc>().add(FetchTvShowDetails(tvId: widget.tvShowId));
    context.read<TrailerBloc>().add(FetchTvShowTrailer(widget.tvShowId));
  }

  void _initYoutube(String key) {
    _ytController?.dispose();
    _ytController = YoutubePlayerController(
      initialVideoId: key,
      flags: const YoutubePlayerFlags(autoPlay: false),
    );
  }

  @override
  void dispose() {
    _ytController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF101010),
      appBar: AppBar(
        title: const Text("TV Show Details"),
        backgroundColor: Colors.amberAccent,
        foregroundColor: Colors.black,
      ),
      body: BlocBuilder<TvShowsBloc, TvShowsState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.error != null) {
            return QuietStateBox(
              title: 'TV Show details not fetched',
              subtitle: 'Please refresh or revisit.\n${state.error}',
            );
          }

          final tvShow = state.tvShowDetails;
          if (tvShow == null) {
            return const QuietStateBox(
              title: 'TV Show details not fetched',
              subtitle: 'Please refresh or revisit to load the TV show details.',
            );
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: NetworkImageWithFallback(
                    imageUrl: 'https://image.tmdb.org/t/p/w500${tvShow.posterPath}',
                    height: 300,
                    width: 200,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Center(
                child: BlocBuilder<BookmarksBloc, BookmarksState>(
                  builder: (context, state) {
                    final isBookmarked = state.tvShowBookmarks.any((tv) => tv.id == tvShow.id);
                    return GestureDetector(
                      onTap: () {
                        context.read<BookmarksBloc>().add(ToggleTvShowBookmark(tvShow));
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                              isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                              color: Colors.amber,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              isBookmarked ? "Bookmarked" : "Add to Bookmarks",
                              style: const TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              Text(
                tvShow.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              if (tvShow.firstAirDate != null)
                Text(
                  "First Air Date: ${tvShow.firstAirDate}",
                  style: const TextStyle(color: Colors.white70),
                ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.amberAccent),
                  const SizedBox(width: 4),
                  Text(
                    "${tvShow.voteAverage}",
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                "Overview",
                style: TextStyle(
                  color: Colors.amberAccent,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                tvShow.overview,
                style: const TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 24),
              BlocBuilder<TrailerBloc, TrailerState>(
                builder: (context, trailerState) {
                  if (trailerState.tvKey != null) {
                    _initYoutube(trailerState.tvKey!);
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Trailer",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 12),
                        YoutubePlayer(controller: _ytController!),
                      ],
                    );
                  } else if (trailerState.error != null) {
                    return const SizedBox(); // Or show a fallback message
                  }
                  return const SizedBox();
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

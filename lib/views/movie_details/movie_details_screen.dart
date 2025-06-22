import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:tmdb_movies/models/movie_model.dart';
import 'package:tmdb_movies/viewmodels/bookmarks/bookmarks_bloc.dart';
import 'package:tmdb_movies/viewmodels/bookmarks/bookmarks_event.dart';
import 'package:tmdb_movies/viewmodels/bookmarks/bookmarks_state.dart';
import 'package:tmdb_movies/viewmodels/movie_details/movie_details_bloc.dart';
import 'package:tmdb_movies/viewmodels/movie_details/movie_details_event.dart';
import 'package:tmdb_movies/viewmodels/movie_details/movie_details_state.dart';
import 'package:tmdb_movies/viewmodels/trailer/trailer_bloc.dart';
import 'package:tmdb_movies/viewmodels/trailer/trailer_event.dart';
import 'package:tmdb_movies/viewmodels/trailer/trailer_state.dart';
import 'package:tmdb_movies/views/widgets/network_image_with_fallback.dart';

class MovieDetailsScreen extends StatelessWidget {
  final int movieId;

  const MovieDetailsScreen({super.key, required this.movieId});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MovieDetailsBloc>(
          create: (_) => MovieDetailsBloc(movieRepository: context.read())
            ..add(FetchMovieDetails(movieId: movieId)),
        ),
        BlocProvider<TrailerBloc>(
          create: (_) => TrailerBloc(context.read())
            ..add(FetchTrailer(movieId)),
        ),
      ],
      child: _MovieDetailsView(),
    );
  }
}

class _MovieDetailsView extends StatefulWidget {
  @override
  State<_MovieDetailsView> createState() => _MovieDetailsViewState();
}

class _MovieDetailsViewState extends State<_MovieDetailsView> {
  YoutubePlayerController? _ytController;

  @override
  void dispose() {
    _ytController?.dispose();
    super.dispose();
  }

  void _initYoutube(String key) {
    if (_ytController == null || _ytController!.initialVideoId != key) {
      _ytController = YoutubePlayerController(
        initialVideoId: key,
        flags: const YoutubePlayerFlags(autoPlay: false),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E0E0E),
      appBar: AppBar(
        backgroundColor: Colors.black87,
        elevation: 0,
        centerTitle: true,
        title: const Text('Movie Details', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: BlocBuilder<MovieDetailsBloc, MovieDetailsState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator(color: Colors.redAccent));
          }
          if (state.error != null) {
            return Center(child: Text("Error: ${state.error!}", style: TextStyle(color: Colors.white)));
          }

          final movie = state.movie;
          if (movie == null) {
            return const Center(child: Text("Movie not found", style: TextStyle(color: Colors.white)));
          }

          final posterUrl = 'https://image.tmdb.org/t/p/w500${movie.posterPath}';

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

                /// 🔖 Bookmark Button
                Center(
                  child: BlocBuilder<BookmarksBloc, BookmarksState>(
                    builder: (context, bState) {
                      final isBookmarked = bState.bookmarks.any((m) => m.id == movie.id);
                      return GestureDetector(
                        onTap: () {
                          context.read<BookmarksBloc>().add(ToggleBookmark(movie));
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 6),
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
                const SizedBox(height: 24),

                Text(movie.title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: Colors.white)),
                const SizedBox(height: 10),

                Row(
                  children: [
                    const Icon(Icons.calendar_today_rounded, size: 18, color: Colors.white70),
                    const SizedBox(width: 6),
                    Text(movie.releaseDate ?? 'Unknown', style: const TextStyle(color: Colors.white70)),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amberAccent, size: 20),
                    const SizedBox(width: 6),
                    Text(movie.voteAverage.toString(), style: const TextStyle(color: Colors.amberAccent)),
                  ],
                ),
                const SizedBox(height: 24),

                const Text("Overview", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white)),
                const SizedBox(height: 10),
                Text(
                  movie.overview.isNotEmpty ? movie.overview : 'No description available.',
                  style: const TextStyle(fontSize: 15, height: 1.5, color: Colors.white70),
                ),
                const SizedBox(height: 24),

                BlocBuilder<TrailerBloc, TrailerState>(
                  builder: (context, tState) {
                    if (tState.isLoading) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Center(
                          child: CircularProgressIndicator(color: Colors.white),
                        ),
                      );
                    }

                    if (tState.key == null) {
                      return const SizedBox.shrink();
                    }

                    _initYoutube(tState.key!);

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Trailer",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 12),

                        /// Wrap in a Card with shadow
                        AnimatedOpacity(
                          duration: const Duration(milliseconds: 500),
                          opacity: 1.0,
                          child: Card(
                            elevation: 6,
                            color: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: YoutubePlayer(
                                  controller: _ytController!,
                                  showVideoProgressIndicator: true,
                                  progressIndicatorColor: Colors.redAccent,
                                  progressColors: const ProgressBarColors(
                                    playedColor: Colors.redAccent,
                                    handleColor: Colors.red,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    );
                  },
                ),

              ],
            ),
          );
        },
      ),
    );
  }
}

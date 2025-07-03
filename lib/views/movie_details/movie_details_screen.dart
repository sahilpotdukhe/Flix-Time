import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tmdb_movies/views/widgets/quiet_state_box.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:tmdb_movies/viewmodels/bookmarks/bookmarks_bloc.dart';
import 'package:tmdb_movies/viewmodels/bookmarks/bookmarks_event.dart';
import 'package:tmdb_movies/viewmodels/bookmarks/bookmarks_state.dart';
import 'package:tmdb_movies/viewmodels/casts/cast_bloc.dart';
import 'package:tmdb_movies/viewmodels/casts/cast_event.dart';
import 'package:tmdb_movies/viewmodels/casts/cast_state.dart';
import 'package:tmdb_movies/viewmodels/movie_details/movie_details_bloc.dart';
import 'package:tmdb_movies/viewmodels/movie_details/movie_details_event.dart';
import 'package:tmdb_movies/viewmodels/movie_details/movie_details_state.dart';
import 'package:tmdb_movies/viewmodels/trailer/trailer_bloc.dart';
import 'package:tmdb_movies/viewmodels/trailer/trailer_event.dart';
import 'package:tmdb_movies/viewmodels/trailer/trailer_state.dart';
import 'package:tmdb_movies/views/widgets/network_image_with_fallback.dart';

class MovieDetailsScreen extends StatefulWidget {
  final int movieId;

  const MovieDetailsScreen({super.key, required this.movieId});

  @override
  State<MovieDetailsScreen> createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> {
  YoutubePlayerController? _ytController;

  @override
  void initState() {
    super.initState();
    context.read<MovieDetailsBloc>().add(
      FetchMovieDetails(movieId: widget.movieId),
    );
    context.read<MovieDetailsBloc>().add(
      FetchSimilarMovies(movieId: widget.movieId),
    );
    context.read<CastBloc>().add(FetchCast(widget.movieId));
    context.read<TrailerBloc>().add(FetchMovieTrailer(widget.movieId));
  }

  void _initYoutube(String key) {
    if (_ytController == null || _ytController!.initialVideoId != key) {
      _ytController?.dispose(); // dispose old one
      _ytController = YoutubePlayerController(
        initialVideoId: key,
        flags: const YoutubePlayerFlags(autoPlay: false),
      );
    }
  }

  @override
  void dispose() {
    _ytController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E0E0E),
      appBar: AppBar(
        title: const Text('Movie Details'),
        backgroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: BlocBuilder<MovieDetailsBloc, MovieDetailsState>(
        builder: (context, state) {
          final movie = state.movie;
          final similarMovies = state.similarMovies;

          if (state.isLoading && movie == null) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.redAccent),
            );
          }

          if (state.error != null) {
            return QuietStateBox(
              title: 'Movie details not fetched',
              subtitle:
                  'Please Refresh or revisit to load with movies details.\n ${state.error}',
            );
          }

          if (movie == null)
            return QuietStateBox(
              title: 'Movie details not fetched',
              subtitle: 'Please Refresh or revisit to load with movies details',
            );

          return RefreshIndicator(
            onRefresh: () async {
              context.read<MovieDetailsBloc>().add(
                FetchMovieDetails(movieId: widget.movieId),
              );
              context.read<MovieDetailsBloc>().add(
                FetchSimilarMovies(movieId: widget.movieId),
              );
              context.read<CastBloc>().add(FetchCast(widget.movieId));
              context.read<TrailerBloc>().add(FetchMovieTrailer(widget.movieId));
            },
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: NetworkImageWithFallback(
                      imageUrl:
                          'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                      height: 350,
                      width: 240,
                    ),
                  ),
                ),

                Center(
                  child: BlocBuilder<BookmarksBloc, BookmarksState>(
                    builder: (context, state) {
                      final isBookmarked = state.movieBookmarks.any(
                        (m) => m.id == movie.id,
                      );

                      return GestureDetector(
                        onTap: () {
                          context.read<BookmarksBloc>().add(
                            ToggleMoviesBookmark(movie),
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

                const SizedBox(height: 16),
                Text(
                  movie.title,
                  style: const TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Release: ${movie.releaseDate}",
                  style: const TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 6),
                Text(
                  "Rating: ${movie.voteAverage.toStringAsFixed(1)}/10",
                  style: const TextStyle(color: Colors.amberAccent),
                ),

                if (movie.tagline != null && movie.tagline!.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    "Tagline: ${movie.tagline}",
                    style: const TextStyle(color: Colors.amberAccent),
                  ),
                ],

                const SizedBox(height: 24),
                const Text(
                  "Overview",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  movie.overview,
                  style: const TextStyle(color: Colors.white70),
                ),

                const SizedBox(height: 24),
                BlocBuilder<CastBloc, CastState>(
                  builder: (context, castState) {
                    if (castState.casts.isEmpty) return const SizedBox();

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Cast",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 180,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: castState.casts.length,
                            itemBuilder: (context, index) {
                              final cast = castState.casts[index];
                              return Padding(
                                padding: const EdgeInsets.only(right: 12),
                                child: Column(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
                                      child: Image.network(
                                        'https://image.tmdb.org/t/p/w200${cast.profileUrl}',
                                        width: 80,
                                        height: 80,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    SizedBox(
                                      width: 80,
                                      child: Text(
                                        cast.name,
                                        textAlign: TextAlign.center,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color: Colors.white70,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),

                const SizedBox(height: 24),
                BlocBuilder<TrailerBloc, TrailerState>(
                  builder: (context, trailerState) {
                    if (trailerState.movieKey != null) {
                      _initYoutube(trailerState.movieKey!);
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
                    }

                    return const SizedBox();
                  },
                ),

                const SizedBox(height: 24),
                if (similarMovies.isNotEmpty) ...[
                  const Text(
                    "Similar Movies",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 250,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: similarMovies.length,
                      itemBuilder: (context, index) {
                        final movie = similarMovies[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (_) => MultiBlocProvider(
                                      providers: [
                                        BlocProvider(
                                          create:
                                              (_) => MovieDetailsBloc(
                                                movieRepository: context.read(),
                                              ),
                                        ),
                                        BlocProvider(
                                          create:
                                              (_) => CastBloc(
                                                movieRepository: context.read(),
                                              ),
                                        ),
                                        BlocProvider(
                                          create:
                                              (_) =>
                                                  TrailerBloc(movieRepository: context.read(), tvShowRepository: context.read()),
                                        ),
                                      ],
                                      child: MovieDetailsScreen(
                                        movieId: movie.id,
                                      ),
                                    ),
                              ),
                            );
                          },
                          child: Container(
                            width: 140,
                            margin: const EdgeInsets.only(right: 12),
                            child: Column(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: NetworkImageWithFallback(
                                    imageUrl:
                                        'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                                    height: 180,
                                    width: 140,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  movie.title,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}

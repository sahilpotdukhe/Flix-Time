import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tmdb_movies/models/tv_show_model.dart';
import 'package:tmdb_movies/viewmodels/tv_shows/tv_shows_bloc.dart';
import 'package:tmdb_movies/viewmodels/tv_shows/tv_shows_event.dart';
import 'package:tmdb_movies/viewmodels/tv_shows/tv_shows_state.dart';
import 'package:tmdb_movies/views/widgets/network_image_with_fallback.dart';

class TvShowDetailsScreen extends StatefulWidget {
  final int tvShowId;

  const TvShowDetailsScreen({super.key, required this.tvShowId});

  @override
  State<TvShowDetailsScreen> createState() => _TvShowDetailsScreenState();
}

class _TvShowDetailsScreenState extends State<TvShowDetailsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<TvShowsBloc>().add(FetchTvShowDetails( tvId: widget.tvShowId));
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
            return Center(
              child: Text(
                state.error!,
                style: const TextStyle(color: Colors.white70),
              ),
            );
          }

          final tv = state.tvShowDetails;
          if (tv == null) {
            return const Center(
              child: Text(
                "No details available",
                style: TextStyle(color: Colors.white70),
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: NetworkImageWithFallback(
                      imageUrl: 'https://image.tmdb.org/t/p/w500${tv.posterPath}',
                      height: 300,
                      width: 200,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  tv.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                if (tv.firstAirDate != null)
                  Text(
                    "First Air Date: ${tv.firstAirDate}",
                    style: const TextStyle(color: Colors.white70),
                  ),
                const SizedBox(height: 8),
                if (tv.voteAverage != null)
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amberAccent),
                      const SizedBox(width: 4),
                      Text(
                        "${tv.voteAverage}",
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
                  tv.overview ?? "No description available.",
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

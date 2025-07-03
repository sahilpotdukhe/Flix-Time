import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tmdb_movies/viewmodels/tv_shows/tv_shows_bloc.dart';
import 'package:tmdb_movies/viewmodels/tv_shows/tv_shows_event.dart';
import 'package:tmdb_movies/viewmodels/tv_shows/tv_shows_state.dart';
import 'package:tmdb_movies/views/bookmarks/bookmarks_screen.dart';
import 'package:tmdb_movies/views/search/search_screen.dart';
import 'package:tmdb_movies/views/tv_show_details/tv_show_detail_screen.dart';
import 'package:tmdb_movies/views/widgets/network_image_with_fallback.dart';
import 'package:tmdb_movies/views/widgets/network_status_banner.dart';
import 'package:tmdb_movies/models/tv_show_model.dart';

class TvShowsTab extends StatelessWidget {
  const TvShowsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF101010),
      appBar: AppBar(
        title: const Text(
          'TV Shows',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.amberAccent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SearchScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.bookmark, color: Colors.black),
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
            child: BlocBuilder<TvShowsBloc, TvShowsState>(
              builder: (context, state) {
                final hasData = state.trendingTvShows.isNotEmpty ||
                    state.popularTvShows.isNotEmpty ||
                    state.topRatedTvShows.isNotEmpty;

                if (state.isLoading && !hasData) {
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.redAccent),
                  );
                }

                if (!hasData) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          state.error ?? "No TV shows available.",
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton.icon(
                          onPressed: () {
                            context
                              ..read<TvShowsBloc>().add(FetchTrendingTvShows())
                              ..read<TvShowsBloc>().add(FetchPopularTvShows())
                              ..read<TvShowsBloc>().add(FetchTopRatedTvShows());
                          },
                          icon: const Icon(Icons.refresh),
                          label: const Text("Retry"),
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    context
                      ..read<TvShowsBloc>().add(FetchTrendingTvShows())
                      ..read<TvShowsBloc>().add(FetchPopularTvShows())
                      ..read<TvShowsBloc>().add(FetchTopRatedTvShows());
                  },
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (state.trendingTvShows.isNotEmpty) ...[
                          _buildSectionTitle("Trending TV Shows"),
                          _buildTvShowList(state.trendingTvShows),
                        ],
                        if (state.popularTvShows.isNotEmpty) ...[
                          _buildSectionTitle("Popular TV Shows"),
                          _buildTvShowList(state.popularTvShows),
                        ],
                        if (state.topRatedTvShows.isNotEmpty) ...[
                          _buildSectionTitle("Top Rated TV Shows"),
                          _buildTvShowList(state.topRatedTvShows),
                        ],
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

  Widget _buildTvShowList(List<TvShowModel> tvShows) {
    return SizedBox(
      height: 250,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        scrollDirection: Axis.horizontal,
        itemCount: tvShows.length,
        separatorBuilder: (_, __) => const SizedBox(width: 14),
        itemBuilder: (context, index) {
          final show = tvShows[index];
          final tvShowId = show.id;
          final posterUrl = 'https://image.tmdb.org/t/p/w500${show.posterPath}';

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => TvShowDetailsScreen(tvShowId: tvShowId ),
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
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    child: NetworkImageWithFallback(
                      imageUrl: posterUrl,
                      height: 180,
                      width: 140,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      show.title,
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

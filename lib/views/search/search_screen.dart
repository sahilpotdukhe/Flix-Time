import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tmdb_movies/viewmodels/casts/cast_bloc.dart';
import 'package:tmdb_movies/viewmodels/movie_details/movie_details_bloc.dart';
import 'package:tmdb_movies/viewmodels/search/search_bloc.dart';
import 'package:tmdb_movies/viewmodels/search/search_event.dart';
import 'package:tmdb_movies/viewmodels/search/search_state.dart';
import 'package:tmdb_movies/viewmodels/trailer/trailer_bloc.dart';
import 'package:tmdb_movies/views/movie_details/movie_details_screen.dart';
import 'package:tmdb_movies/views/tv_show_details/tv_show_detail_screen.dart';
import 'package:tmdb_movies/views/widgets/network_image_with_fallback.dart';
import 'package:tmdb_movies/views/widgets/quiet_state_box.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => SearchBloc(
            movieRepository: context.read(),
            tvShowRepository: context.read(),
          ),
      child: const _SearchView(),
    );
  }
}

class _SearchView extends StatelessWidget {
  const _SearchView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF101010),
      appBar: AppBar(
        backgroundColor: Colors.amberAccent,
        title: TextField(
          style: const TextStyle(color: Colors.black),
          decoration: const InputDecoration(
            hintText: 'Search movies or TV shows...',
            hintStyle: TextStyle(color: Colors.black),
            border: InputBorder.none,
          ),
          onChanged: (query) {
            context.read<SearchBloc>().add(SearchQueryChanged(query: query));
          },
        ),
        iconTheme: const IconThemeData(color: Colors.black),

      ),
      body: BlocBuilder<SearchBloc, SearchState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.searchMoviesResult.isEmpty &&
              state.searchTvShowsResult.isEmpty) {
            return QuietStateBox(title: 'No Movies or Tv Shows found!', subtitle: 'Please enter relevant input to see results.');
          }

          return ListView(
            children: [
              if (state.searchMoviesResult.isNotEmpty) ...[
                _sectionTitle("Movies"),
                ...state.searchMoviesResult.map(
                  (m) => _resultTile(
                    title: m.title,
                    subtitle: "⭐ ${m.voteAverage} | 📅 ${m.releaseDate}",
                    imagePath: m.posterPath,
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
                                    create: (_) => TrailerBloc(context.read()),
                                  ),
                                ],
                                child: MovieDetailsScreen(movieId: m.id),
                              ),
                        ),
                      );
                    },
                  ),
                ),
              ],
              if (state.searchTvShowsResult.isNotEmpty) ...[
                _sectionTitle("TV Shows"),
                ...state.searchTvShowsResult.map(
                  (tv) => _resultTile(
                    title: tv.title,
                    subtitle: "⭐ ${tv.voteAverage} | 📅 ${tv.firstAirDate}",
                    imagePath: tv.posterPath,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => TvShowDetailsScreen(tvShowId: tv.id),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, color: Colors.white),
      ),
    );
  }

  Widget _resultTile({
    required String title,
    required String subtitle,
    required String? imagePath,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: NetworkImageWithFallback(
          imageUrl: 'https://image.tmdb.org/t/p/w200$imagePath',
          width: 50,
          height: 75,
        ),
      ),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      subtitle: Text(subtitle, style: const TextStyle(color: Colors.white70)),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tmdb_movies/models/movie_model.dart';
import 'package:tmdb_movies/viewmodels/search/search_bloc.dart';
import 'package:tmdb_movies/viewmodels/search/search_event.dart';
import 'package:tmdb_movies/viewmodels/search/search_state.dart';
import 'package:tmdb_movies/views/movie_details/movie_details_screen.dart';
import 'package:tmdb_movies/views/widgets/network_image_with_fallback.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchBloc(movieRepository: context.read()),
      child: const _SearchView(),
    );
  }
}

class _SearchView extends StatelessWidget {
  const _SearchView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Search Movies")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Search for a movie...",
                hintStyle: const TextStyle(color: Colors.white54),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.search),
              ),
              onChanged: (query) {
                context.read<SearchBloc>().add(
                  SearchQueryChanged(query: query),
                );
              },
            ),
          ),
          Expanded(
            child: BlocBuilder<SearchBloc, SearchState>(
              builder: (context, state) {
                if (state.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state.error != null) {
                  return Center(child: Text("Error: ${state.error!}"));
                }

                if (state.searchResult.isEmpty) {
                  return const Center(child: Text("No results found"));
                }

                return ListView.builder(
                  itemCount: state.searchResult.length,
                  itemBuilder: (context, index) {
                    final MovieModel movie = state.searchResult[index];
                    final posterUrl =
                        'https://image.tmdb.org/t/p/w500${movie.posterPath}';
                    return ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: NetworkImageWithFallback(
                          imageUrl: posterUrl,
                          height: 60,
                          width: 40,
                        ),
                      ),
                      title: Text(
                        movie.title,
                        style: const TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(movie.releaseDate),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => MovieDetailsScreen(movieId: movie.id),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

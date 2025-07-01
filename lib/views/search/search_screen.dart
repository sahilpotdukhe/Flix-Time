import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tmdb_movies/data/repositories/movie_repository_impl.dart';
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
      backgroundColor: const Color(0xFF0E0E0E),
      appBar: AppBar(
        backgroundColor: Colors.black87,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Search Movies",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              style: const TextStyle(color: Colors.white),
              cursorColor: Colors.amber,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[850],
                hintText: "Search for a movie...",
                hintStyle: const TextStyle(color: Colors.white54),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: const Icon(Icons.search, color: Colors.white54),
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
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.amber),
                  );
                }

                if (state.error != null) {
                  return Center(
                    child: Text(
                      "Error: ${state.error!}",
                      style: const TextStyle(color: Colors.white),
                    ),
                  );
                }

                if (state.searchResult.isEmpty) {
                  return const Center(
                    child: Text(
                      "No results found",
                      style: TextStyle(color: Colors.white70),
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  itemCount: state.searchResult.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final MovieModel movie = state.searchResult[index];
                    final posterUrl =
                        'https://image.tmdb.org/t/p/w500${movie.posterPath}';

                    return GestureDetector(
                      onTap: () {
                        // final movieRepository =
                        //     context.read<MovieRepositoryImp>();
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
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: NetworkImageWithFallback(
                                imageUrl: posterUrl,
                                height: 80,
                                width: 55,
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
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    "📅 ${movie.releaseDate ?? 'N/A'}   ⭐ ${movie.voteAverage}",
                                    style: const TextStyle(
                                      color: Colors.amberAccent,
                                      fontSize: 13,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    movie.overview.isNotEmpty
                                        ? (movie.overview.length > 80
                                            ? "${movie.overview.substring(0, 80)}..."
                                            : movie.overview)
                                        : "No description available.",
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 13,
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
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tmdb_movies/viewmodels/bookmarks/bookmarks_bloc.dart';
import 'package:tmdb_movies/viewmodels/bookmarks/bookmarks_state.dart';
import 'package:tmdb_movies/views/movie_details/movie_details_screen.dart';
import 'package:tmdb_movies/views/widgets/network_image_with_fallback.dart';

class BookmarksScreen extends StatelessWidget {
  const BookmarksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Bookmarked Movies')),
      body: BlocBuilder<BookmarksBloc, BookmarksState>(
        builder: (context, state) {
          if (state.bookmarks.isEmpty) {
            return Center(child: Text('No bookmarks found'));
          }
          return ListView.builder(
            itemCount: state.bookmarks.length,
            itemBuilder: (context, index) {
              final movie = state.bookmarks[index];
              final posterUrl =
                  'https://image.tmdb.org/t/p/w500${movie.posterPath}';
              return ListTile(
                leading: NetworkImageWithFallback(
                  imageUrl: posterUrl,
                  height: 50,
                  width: 50,
                ),
                title: Text(
                  movie.title,
                  style: const TextStyle(color: Colors.white),
                ),
                subtitle: Text("⭐ ${movie.voteAverage}"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => MovieDetailsScreen(movieId: movie.id),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

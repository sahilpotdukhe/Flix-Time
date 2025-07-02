import 'package:flutter/material.dart';
import 'package:tmdb_movies/models/tv_show_model.dart';
import 'package:tmdb_movies/views/widgets/network_image_with_fallback.dart';

class TvCarousel extends StatelessWidget {
  final List<TvShowModel> tvShows;

  const TvCarousel({super.key, required this.tvShows});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        scrollDirection: Axis.horizontal,
        itemCount: tvShows.length,
        separatorBuilder: (_, __) => const SizedBox(width: 14),
        itemBuilder: (context, index) {
          final tv = tvShows[index];
          final posterUrl = 'https://image.tmdb.org/t/p/w500${tv.posterPath}';

          return GestureDetector(
            onTap: () {
              // Handle TV show details navigation (optional)
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
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                    child: NetworkImageWithFallback(
                      imageUrl: posterUrl,
                      height: 180,
                      width: 140,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      tv.title,
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

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class NetworkImageWithFallback extends StatelessWidget {
  final String imageUrl;
  final double height;
  final double width;

  const NetworkImageWithFallback({
    super.key,
    required this.imageUrl,
    required this.height,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      height: height,
      width: width,
      fit: BoxFit.cover,
      placeholder:
          (context, url) => Shimmer.fromColors(
            baseColor: Colors.grey[800]!,
            highlightColor: Colors.grey[600]!,
            child: Container(
              width: width,
              height: height,
              color: Colors.grey[900],
            ),
          ),
      errorWidget:
          (context, url, error) => Image.asset(
            'assets/placeholder.png',
            width: width,
            height: height,
            fit: BoxFit.cover,
          ),
    );
  }
}

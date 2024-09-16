import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../core/model/image_data_view_model.dart';

class ImageDetailScreen extends StatelessWidget {
  final ImageData image;

  ImageDetailScreen({required this.image});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Hero(
            tag: image.imageUrl,
            child: CachedNetworkImage(
              imageUrl: image.imageUrl,
              fit: BoxFit.cover,
              placeholder: (context, url) =>
              const Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) =>
              const Icon(Icons.error, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../../../../models/media.dart';
import 'widgets/media_item.dart';

class MediaGallery extends StatelessWidget {
  final List<Media> medias;
  final double height;

  const MediaGallery({
    super.key,
    required this.medias,
    this.height = 120,
  });

  @override
  Widget build(BuildContext context) {
    if (medias.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: height,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: medias.length,
        itemBuilder: (context, index) {
          final media = medias[index];
          final isLast = index == medias.length - 1;

          return Padding(
            padding: EdgeInsets.only(right: isLast ? 0 : 12),
            child: MediaItem(
              media: media,
              size: height,
            ),
          );
        },
      ),
    );
  }
}

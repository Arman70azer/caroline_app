import 'package:flutter/material.dart';
import '../../../../../../models/media.dart';
import 'package:application_nutrition/config/api_config.dart';
import 'package:application_nutrition/config/colors.dart';
import 'image_item.dart';
import 'video_item.dart';
import 'document_item.dart';
import '../viewers/image_viewer.dart';
import '../viewers/video_player_screen.dart';
import '../viewers/document_opener.dart';

class MediaItem extends StatelessWidget {
  final Media media;
  final double size;

  const MediaItem({
    super.key,
    required this.media,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    final mediaUrl = '${ApiConfig.baseUrl}/${media.path}';

    return GestureDetector(
      onTap: () => _handleTap(context, mediaUrl),
      child: Container(
        width: size,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.border,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(11),
          child: _buildMediaContent(mediaUrl),
        ),
      ),
    );
  }

  Widget _buildMediaContent(String mediaUrl) {
    if (media.isImage) {
      return ImageItem(imageUrl: mediaUrl);
    } else if (media.isVideo) {
      return const VideoItem();
    } else if (media.isDocument) {
      return DocumentItem(path: media.path);
    }
    return const SizedBox.shrink();
  }

  void _handleTap(BuildContext context, String mediaUrl) {
    if (media.isImage) {
      ImageViewer.show(context, mediaUrl);
    } else if (media.isVideo) {
      VideoPlayerScreen.open(context, mediaUrl);
    } else if (media.isDocument) {
      DocumentOpener.open(context, mediaUrl);
    }
  }
}

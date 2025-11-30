import 'package:flutter/material.dart';
import '../../../../../models/media.dart';
import 'widgets/media_item.dart';
import '../../../../../config/colors.dart';

class MediaGallery extends StatefulWidget {
  final List<Media> medias;
  final double height;

  const MediaGallery({
    super.key,
    required this.medias,
    this.height = 120,
  });

  @override
  State<MediaGallery> createState() => _MediaGalleryState();
}

class _MediaGalleryState extends State<MediaGallery> {
  late final ScrollController _scrollController;
  bool _canScrollLeft = false;
  bool _canScrollRight = true;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final offset = _scrollController.offset;

    setState(() {
      _canScrollLeft = offset > 0;
      _canScrollRight = offset < maxScroll;
    });
  }

  void _scrollBy(double offset) {
    _scrollController.animateTo(
      _scrollController.offset + offset,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.medias.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: widget.height,
      child: Stack(
        children: [
          ListView.builder(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            itemCount: widget.medias.length,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            itemBuilder: (context, index) {
              final media = widget.medias[index];
              final isLast = index == widget.medias.length - 1;

              return Padding(
                padding: EdgeInsets.only(right: isLast ? 0 : 12),
                child: MediaItem(
                  media: media,
                  size: widget.height,
                ),
              );
            },
          ),

          // Flèche gauche avec gradient accentué
          if (_canScrollLeft)
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              child: Container(
                width: 36,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.background, // blanc opaque
                      AppColors.background.withOpacity(0.0) // transparent
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  color: AppColors.primaryGreen,
                  iconSize: 20,
                  onPressed: () => _scrollBy(-widget.height * 1.5),
                ),
              ),
            ),

          // Flèche droite avec gradient accentué
          if (_canScrollRight)
            Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              child: Container(
                width: 36,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.background.withOpacity(0.0), // transparent
                      AppColors.background, // blanc opaque
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
                child: IconButton(
                  icon: const Icon(Icons.arrow_forward_ios),
                  color: AppColors.primaryGreen,
                  iconSize: 20,
                  onPressed: () => _scrollBy(widget.height * 1.5),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

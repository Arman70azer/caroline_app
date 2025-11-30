import 'package:flutter/material.dart';
import 'package:application_nutrition/config/colors.dart';

class ImageItem extends StatelessWidget {
  final String imageUrl;

  const ImageItem({
    super.key,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Image.network(
      imageUrl,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => _errorPlaceholder(),
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return _loadingIndicator(progress);
      },
    );
  }

  Widget _errorPlaceholder() {
    return Container(
      color: AppColors.lightGrey,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.broken_image_rounded,
              color: AppColors.textHint,
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              'Image\nindisponible',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                color: AppColors.textHint,
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _loadingIndicator(ImageChunkEvent progress) {
    return Container(
      color: AppColors.lightGrey,
      child: Center(
        child: CircularProgressIndicator(
          value: progress.expectedTotalBytes != null
              ? progress.cumulativeBytesLoaded / progress.expectedTotalBytes!
              : null,
          strokeWidth: 2.5,
          valueColor:
              const AlwaysStoppedAnimation<Color>(AppColors.primaryGreen),
          backgroundColor: AppColors.border,
        ),
      ),
    );
  }
}

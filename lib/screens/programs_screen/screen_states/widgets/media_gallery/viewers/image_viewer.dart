import 'package:flutter/material.dart';
import 'package:application_nutrition/config/colors.dart';

class ImageViewer {
  static void show(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.95),
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.zero,
        child: Stack(
          children: [
            // Image zoomable
            Center(
              child: InteractiveViewer(
                minScale: 0.5,
                maxScale: 4.0,
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return _buildError();
                  },
                ),
              ),
            ),
            // Bouton fermer
            Positioned(
              top: MediaQuery.of(context).padding.top + 16,
              right: 16,
              child: _buildCloseButton(context),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildError() {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline_rounded,
            color: AppColors.textLight,
            size: 64,
          ),
          const SizedBox(height: 16),
          const Text(
            'Impossible de charger l\'image',
            style: TextStyle(
              color: AppColors.textLight,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  static Widget _buildCloseButton(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 12,
          ),
        ],
      ),
      child: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(
          Icons.close_rounded,
          color: AppColors.textPrimary,
          size: 24,
        ),
        style: IconButton.styleFrom(
          padding: const EdgeInsets.all(12),
        ),
      ),
    );
  }
}

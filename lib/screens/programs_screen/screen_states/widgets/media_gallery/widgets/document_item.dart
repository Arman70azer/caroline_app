import 'package:flutter/material.dart';
import 'package:application_nutrition/config/colors.dart';
import '../utils/document_helper.dart';

class DocumentItem extends StatelessWidget {
  final String path;

  const DocumentItem({
    super.key,
    required this.path,
  });

  @override
  Widget build(BuildContext context) {
    final fileType = DocumentHelper.getFileType(path);
    final icon = DocumentHelper.getIcon(path);
    final color = DocumentHelper.getColor(path);

    return Container(
      color: AppColors.lightGrey,
      child: Stack(
        children: [
          // Icône et type de fichier
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: 32,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  fileType,
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          // Badge "ouvrir"
          Positioned(
            bottom: 8,
            right: 8,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColors.surface,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.border,
                  width: 1,
                ),
              ),
              child: Icon(
                Icons.open_in_new_rounded,
                size: 14,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

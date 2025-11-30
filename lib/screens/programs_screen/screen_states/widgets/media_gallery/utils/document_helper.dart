import 'package:flutter/material.dart';
import 'package:application_nutrition/config/colors.dart';

class DocumentHelper {
  /// Détermine le type de fichier basé sur l'extension
  static String getFileType(String path) {
    final extension = path.split('.').last.toLowerCase();

    if (['pdf'].contains(extension)) return 'PDF';
    if (['doc', 'docx'].contains(extension)) return 'Word';
    if (['xls', 'xlsx'].contains(extension)) return 'Excel';
    if (['ppt', 'pptx'].contains(extension)) return 'PowerPoint';
    if (['txt'].contains(extension)) return 'Texte';
    if (['zip', 'rar'].contains(extension)) return 'Archive';

    return 'Document';
  }

  /// Retourne l'icône appropriée pour le type de fichier
  static IconData getIcon(String path) {
    final extension = path.split('.').last.toLowerCase();

    if (['pdf'].contains(extension)) return Icons.picture_as_pdf_rounded;
    if (['doc', 'docx'].contains(extension)) return Icons.description_rounded;
    if (['xls', 'xlsx'].contains(extension)) return Icons.table_chart_rounded;
    if (['ppt', 'pptx'].contains(extension)) return Icons.slideshow_rounded;
    if (['txt'].contains(extension)) return Icons.text_snippet_rounded;
    if (['zip', 'rar'].contains(extension)) return Icons.folder_zip_rounded;

    return Icons.insert_drive_file_rounded;
  }

  /// Retourne la couleur appropriée pour le type de fichier
  static Color getColor(String path) {
    final extension = path.split('.').last.toLowerCase();

    if (['pdf'].contains(extension)) return AppColors.primaryRed;
    if (['doc', 'docx'].contains(extension)) return AppColors.primaryBlue;
    if (['xls', 'xlsx'].contains(extension)) return AppColors.primaryGreen;
    if (['ppt', 'pptx'].contains(extension)) return AppColors.primaryOrange;
    if (['txt'].contains(extension)) return AppColors.textSecondary;
    if (['zip', 'rar'].contains(extension)) return AppColors.primaryPurple;

    return AppColors.textSecondary;
  }
}

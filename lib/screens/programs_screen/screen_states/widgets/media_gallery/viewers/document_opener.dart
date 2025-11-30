import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:application_nutrition/config/colors.dart';

class DocumentOpener {
  static Future<void> open(BuildContext context, String documentUrl) async {
    try {
      final uri = Uri.parse(documentUrl);

      if (await canLaunchUrl(uri)) {
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
      } else {
        if (context.mounted) {
          _showError(context, 'Impossible d\'ouvrir le document');
        }
      }
    } catch (e) {
      if (context.mounted) {
        _showError(context, 'Erreur: ${e.toString()}');
      }
    }
  }

  static void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}

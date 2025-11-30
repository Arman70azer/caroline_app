import 'media.dart';

class NutritionProgram {
  final int id;
  final int userId;
  final String title;
  final String description;
  final String createdAt;
  final String? dateStart;
  final String? dateEnd;
  final List<Media> medias;

  NutritionProgram({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.createdAt,
    this.dateStart,
    this.dateEnd,
    this.medias = const [],
  });

  factory NutritionProgram.fromJson(Map<String, dynamic> json) {
    return NutritionProgram(
      id: json['id'] as int,
      userId: json['user_id'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
      createdAt: json['created_at'] as String,
      dateStart: json['date_start'] as String?,
      dateEnd: json['date_end'] as String?,
      medias: (json['medias'] as List<dynamic>?)
              ?.map((m) => Media.fromJson(m as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'description': description,
      'created_at': createdAt,
      'date_start': dateStart,
      'date_end': dateEnd,
      'medias': medias.map((m) => m.toJson()).toList(),
    };
  }

  // Helper pour afficher la période du programme
  String getPeriodDisplay() {
    if (dateStart != null && dateEnd != null) {
      final start = getFormattedDate(isStart: true);
      final end = getFormattedDate(isStart: false);
      return 'Du $start au $end';
    } else if (dateStart != null) {
      final start = getFormattedDate(isStart: true);
      return 'À partir du $start';
    }
    return 'Pas de dates définies';
  }

  // Helper pour vérifier si le programme est actif
  bool isActive() {
    if (dateStart == null) return true;

    try {
      final start = _parseDate(dateStart!);
      final now = DateTime.now();

      if (dateEnd != null) {
        final end = _parseDate(dateEnd!);
        return now.isAfter(start) && now.isBefore(end);
      }

      return now.isAfter(start);
    } catch (e) {
      return true;
    }
  }

  DateTime _parseDate(String date) {
    // Support pour le format DD-MM-YYYY (français)
    if (date.contains('-') && date.split('-')[0].length == 2) {
      final parts = date.split('-');
      return DateTime(
        int.parse(parts[2]),
        int.parse(parts[1]),
        int.parse(parts[0]),
      );
    }
    // Format ISO par défaut
    return DateTime.parse(date);
  }

  /// Transforme une date du format YYYY-MM-DD en DD-MM-YYYY
  String formatDateToFrench(String? date) {
    if (date == null || date.isEmpty) return '';
    try {
      final parts = date.split('-'); // [YYYY, MM, DD]
      if (parts.length != 3) return date;
      return '${parts[2]}/${parts[1]}/${parts[0]}';
    } catch (_) {
      return date;
    }
  }

  /// Récupère la date formatée selon si c'est start ou end
  String getFormattedDate({required bool isStart}) {
    final date = isStart ? dateStart : dateEnd;
    return formatDateToFrench(date);
  }
}

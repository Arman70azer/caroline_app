class Media {
  final String type;
  final String path;

  Media({
    required this.type,
    required this.path,
  });

  factory Media.fromJson(Map<String, dynamic> json) {
    return Media(
      // Le serveur Python envoie 'media_type' et 'file_path'
      type: json['media_type'] as String,
      path: json['file_path'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'media_type': type,
      'file_path': path,
    };
  }

  bool get isImage => type == 'image';
  bool get isVideo => type == 'video';
  bool get isDocument => type == 'document';
}

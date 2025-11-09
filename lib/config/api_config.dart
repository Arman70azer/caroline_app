/// Configuration de l'API
///
/// Modifiez cette classe pour changer l'URL du serveur
class ApiConfig {
  // URL de base du serveur
  static const String baseUrl = 'http://192.168.1.26:5000';

  // Endpoints de login
  static const String loginEndpoint = '/loginClient';

  // Enpoints de scan
  static const String scanEndpoint = '/client/scan';
  static const String scanManualEndpoint = '/client/scan/manual';
  static const String scanManualBatchEndpoint = '/client/scan/manual/batch';

  // URL complète pour le login
  static String get loginUrl => '$baseUrl$loginEndpoint';

  //Url complète pour le scan
  static String get scanUrl => '$baseUrl$scanEndpoint';
  static String get scanManualUrl => '$baseUrl$scanManualEndpoint';
  static String get scanManualBatchUrl => '$baseUrl$scanManualBatchEndpoint';

  // Timeout pour les requêtes (en secondes)
  static const int requestTimeout = 30;

  // Qualité de compression de l'image (0-100)
  static const int imageQuality = 85;
}

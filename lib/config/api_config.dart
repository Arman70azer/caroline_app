/// Configuration de l'API
///
/// Modifiez cette classe pour changer l'URL du serveur
class ApiConfig {
  // URL de base du serveur
  static const String baseUrl = 'http://192.168.1.26:5000';

  // Endpoints
  static const String loginEndpoint = '/loginClient';

  // URL complète pour le login
  static String get loginUrl => '$baseUrl$loginEndpoint';

  // Timeout pour les requêtes (en secondes)
  static const int requestTimeout = 30;
}

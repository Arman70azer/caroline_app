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

  // Endpoints profil
  static const String profileEndpoint = '/client/profil';
  static const String editProfileEndpoint = '/client/editUser';
  static const String createGoalEndpoint = "/client/createGoal";

  // URL complète pour le login
  static String get loginUrl => '$baseUrl$loginEndpoint';

  //Url complète pour le scan
  static String get scanUrl => '$baseUrl$scanEndpoint';
  static String get scanManualUrl => '$baseUrl$scanManualEndpoint';
  static String get scanManualBatchUrl => '$baseUrl$scanManualBatchEndpoint';

  // URL complète pour le profil
  static String get profileUrl => '$baseUrl$profileEndpoint';
  static String get editProfileUrl => '$baseUrl$editProfileEndpoint';
  static String get createGoalUrl => '$baseUrl$createGoalEndpoint';

  // Timeout pour les requêtes (en secondes)
  static const int requestTimeout = 30;

  // Qualité de compression de l'image (0-100)
  static const int imageQuality = 85;

  static const String tokenKey = 'auth_token';
}

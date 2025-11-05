/// Classe de configuration des constantes de l'application
class AppConstants {
  // Informations de l'application
  static const String appName = 'NutriSport';
  static const String appTagline = 'Votre coach santé personnel';
  static const String appTaglineShort = 'Votre coach santé';

  static final storageKey = StorageKey;

  // Identifiants de test (à retirer en production)
  static const String testUsername = 'Arman';
  static const String testPassword = 'password';

  static final messages = Messages;
}

class StorageKey {
  // Clés de stockage local
  static const String storageKeyAuthToken = 'auth_token';
  static const String storageKeyUsername = 'username';
}

class Messages {
  // Messages
  static const String errorLoginFailed =
      'Nom d\'utilisateur ou mot de passe incorrect';
  static const String errorProfileLoad = 'Erreur de chargement du profil';
  static const String errorProgramsLoad = 'Erreur de chargement des programmes';
  static const String errorScan = 'Erreur lors du scan';
  static const String errorLogout = 'Erreur lors de la déconnexion';
  static const String errorConnection = 'Erreur de connexion';
  // Confirmation messages
  static const String confirmLogout =
      'Êtes-vous sûr de vouloir vous déconnecter ?';
}

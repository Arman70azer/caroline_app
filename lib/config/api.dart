class Api {
  // URLs API
  static const Map<String, String> urlsApi = {
    'uploads': 'https://monserver.com/uploads',
    'programs': 'https://monserver.com/programs',
    'scan': 'https://monserver.com/scan',
    'scanManual': 'https://monserver.com/scan/manual',
  };

  // Getter pour accès facile
  static String get uploadsUrl => urlsApi['uploads']!;
  static String get programsUrl => urlsApi['programs']!;
  static String get scanUrl => urlsApi['scan']!;
  static String get scanManualUrl => urlsApi['scanManual']!;
}

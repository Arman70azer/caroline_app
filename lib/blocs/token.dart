import 'package:application_nutrition/config/api_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

/* Récupère le token d'authentification stocké */
Future<String?> getAuthToken() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(ApiConfig.tokenKey);
  } catch (e) {
    return null;
  }
}

// Utilitaire pour forcer la déconnexion et effacer les tokens
import 'package:shared_preferences/shared_preferences.dart';

Future<void> forceLogout() async {
  print('🧹 Nettoyage complet des données d\'authentification...');

  try {
    final prefs = await SharedPreferences.getInstance();

    // Effacer le token JWT
    await prefs.remove('auth_token');

    // Effacer d'autres données potentielles d'authentification
    await prefs.remove('user_id');
    await prefs.remove('user_data');
    await prefs.remove('remember_me');

    print(
        '✅ Nettoyage terminé. Toutes les données d\'authentification ont été effacées.');
    print(
        '👉 Vous pouvez maintenant vous reconnecter pour obtenir un nouveau token JWT.');
  } catch (e) {
    print('❌ Erreur lors du nettoyage: $e');
  }
}

// Pour utiliser cet utilitaire:
// 1. Importez ce fichier
// 2. Appelez forceLogout() lorsque vous voulez nettoyer complètement les données d'authentification
// 3. Redirigez l'utilisateur vers l'écran de connexion

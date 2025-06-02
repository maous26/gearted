import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/oauth_config.dart';
import 'api_service.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  late final GoogleSignIn _googleSignIn;
  late final ApiService _apiService;

  factory AuthService() {
    return _instance;
  }

  AuthService._internal() {
    _googleSignIn = GoogleSignIn(
      scopes: ['email', 'profile'],
    );
    _apiService = ApiService();
  }

  // Google Sign In
  Future<Map<String, dynamic>?> signInWithGoogle() async {
    // Vérifier la configuration OAuth
    if (!OAuthConfig.isGoogleConfigured) {
      throw Exception(
          'La configuration Google OAuth est manquante. Veuillez vérifier votre fichier .env');
    }

    try {
      print('Tentative de connexion avec Google...');
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        print('Connexion Google annulée par l\'utilisateur');
        return null; // L'utilisateur a annulé la connexion
      }

      print('Compte Google obtenu, authentification en cours...');
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      if (googleAuth.idToken == null || googleAuth.accessToken == null) {
        print('Échec de l\'obtention des tokens Google');
        throw Exception('Impossible d\'obtenir les tokens Google');
      }

      // Envoyer les données au backend
      print('Envoi des informations au serveur...');
      final response = await _apiService.post('/auth/google/mobile', {
        'idToken': googleAuth.idToken,
        'accessToken': googleAuth.accessToken,
        'email': googleUser.email,
        'displayName': googleUser.displayName,
        'photoUrl': googleUser.photoUrl,
      });

      // Sauvegarder le token
      if (response['token'] != null) {
        print('Token reçu du serveur, sauvegarde en cours...');
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', response['token']);
      } else {
        print('Aucun token reçu du serveur');
      }

      return response;
    } catch (error) {
      print('Erreur lors de la connexion Google: $error');
      // Nettoyage en cas d'erreur
      try {
        await _googleSignIn.signOut();
      } catch (e) {
        print('Erreur lors de la déconnexion Google: $e');
      }
      rethrow;
    }
  }

  // Facebook Sign In
  Future<Map<String, dynamic>?> signInWithFacebook() async {
    // Vérifier la configuration OAuth
    if (!OAuthConfig.isFacebookConfigured) {
      throw Exception(
          'La configuration Facebook OAuth est manquante. Veuillez vérifier votre fichier .env');
    }

    try {
      print('Tentative de connexion avec Facebook...');
      final LoginResult result = await FacebookAuth.instance.login();

      if (result.status == LoginStatus.success) {
        final userData = await FacebookAuth.instance.getUserData();

        if (result.accessToken == null) {
          throw Exception('Impossible d\'obtenir le token Facebook');
        }

        // Envoyer les données au backend
        final response = await _apiService.post('/auth/facebook/mobile', {
          'accessToken': result.accessToken!.token,
          'email': userData['email'],
          'name': userData['name'],
          'picture': userData['picture']['data']['url'],
        });

        // Sauvegarder le token
        if (response['token'] != null) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('auth_token', response['token']);
        }

        return response;
      } else if (result.status == LoginStatus.cancelled) {
        return null; // L'utilisateur a annulé la connexion
      } else {
        throw Exception('Erreur Facebook: ${result.message}');
      }
    } catch (error) {
      print('Erreur lors de la connexion Facebook: $error');
      // Nettoyage en cas d'erreur
      try {
        await FacebookAuth.instance.logOut();
      } catch (e) {
        print('Erreur lors de la déconnexion Facebook: $e');
      }
      rethrow;
    }
  }

  // Email/Password Sign In
  Future<Map<String, dynamic>> signInWithEmail(
      String email, String password) async {
    try {
      final response = await _apiService.login(email, password);
      return response;
    } catch (error) {
      rethrow;
    }
  }

  // Email/Password Sign Up
  Future<Map<String, dynamic>> signUpWithEmail(
      String username, String email, String password) async {
    try {
      final response = await _apiService.register(username, email, password);
      return response;
    } catch (error) {
      rethrow;
    }
  }

  // Sign Out
  Future<void> signOut() async {
    try {
      // Déconnexion Google
      await _googleSignIn.signOut();

      // Déconnexion Facebook
      await FacebookAuth.instance.logOut();

      // Déconnexion de l'API
      await _apiService.logout();

      // Nettoyer les tokens locaux
      await clearLocalTokens();
    } catch (error) {
      // Continuer même si la déconnexion échoue
      print('Erreur lors de la déconnexion: $error');
    }
  }

  // Nettoyer les tokens locaux
  Future<void> clearLocalTokens() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_token');
      print('Local tokens cleared.');

      // Additional cleanup could be done here
      // Like clearing any cached user data
    } catch (error) {
      print('Error clearing local tokens: $error');
    }
  }

  // Méthode pour forcer un refresh du token
  Future<bool> refreshToken() async {
    try {
      // D'abord, vérifier si on a un token
      final prefs = await SharedPreferences.getInstance();
      final oldToken = prefs.getString('auth_token');

      if (oldToken == null) {
        print('No token to refresh');
        return false;
      }

      print('Attempting to refresh token...');

      // On peut ajouter ici la logique pour rafraîchir le token
      // par exemple, en appelant un endpoint /auth/refresh
      // Pour l'instant, on va juste valider le token existant

      try {
        final response = await _apiService.getUserProfile();
        if (response['success'] == true) {
          print('Token still valid, no refresh needed');
          return true;
        }
      } catch (e) {
        print('Error validating token: $e');
        await clearLocalTokens();
      }

      return false;
    } catch (error) {
      print('Token refresh failed: $error');
      return false;
    }
  }

  // Vérifier si l'utilisateur est connecté
  Future<bool> isLoggedIn() async {
    print('Checking if user is logged in...');
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null) {
        print('No auth token found.');
        return false;
      }

      // Ne pas afficher le token complet pour des raisons de sécurité
      print('Auth token found: ${token.substring(0, 10)}...');

      // Vérifier brièvement la structure du token
      if (!_isValidTokenFormat(token)) {
        print('Invalid token format detected, clearing token.');
        await clearLocalTokens();
        return false;
      }

      // Vérifier la validité du token avec le backend
      try {
        final response = await _apiService.getUserProfile();
        print('User profile response: ${response['success']}');
        return response['success'] == true;
      } catch (apiError) {
        print('API error during authentication: $apiError');

        // Si le token est invalide ou expiré, le nettoyer
        if (apiError.toString().contains('Token invalide') ||
            apiError.toString().contains('Accès non autorisé')) {
          print('Token expired or invalid, clearing local tokens.');
          await clearLocalTokens();

          // Force fresh login after clearing token
          return false;
        }

        // Pour les autres types d'erreurs (réseau, etc.), préserver le token
        throw apiError;
      }
    } catch (error) {
      print('Error during isLoggedIn check: $error');
      return false;
    }
  }

  // Vérifier basiquement la structure d'un JWT token
  bool _isValidTokenFormat(String token) {
    // Un token JWT valide a 3 parties séparées par des points
    final parts = token.split('.');
    return parts.length == 3;
  }

  // Obtenir l'utilisateur actuel
  Future<Map<String, dynamic>?> getCurrentUser() async {
    try {
      final response = await _apiService.getUserProfile();
      return response['user'];
    } catch (error) {
      return null;
    }
  }
}

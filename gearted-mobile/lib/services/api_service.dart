import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  late final Dio _dio;

  factory ApiService() {
    return _instance;
  }

  ApiService._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: dotenv.env['API_URL'] ?? 'http://localhost:3000/api',
        connectTimeout: const Duration(milliseconds: 10000),
        receiveTimeout: const Duration(milliseconds: 10000),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Ajouter le token aux requêtes si disponible
          final prefs = await SharedPreferences.getInstance();
          final token = prefs.getString('auth_token');

          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }

          return handler.next(options);
        },
        onError: (error, handler) {
          // Gérer les erreurs globalement
          return handler.next(error);
        },
      ),
    );
  }

  // Méthodes d'authentification
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await _dio.post(
        '/auth/login',
        data: {
          'email': email,
          'password': password,
        },
      );

      // Sauvegarder le token
      final token = response.data['token'];
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', token);

      return response.data;
    } catch (e) {
      _handleError(e);
      rethrow;
    }
  }

  Future<Map<String, dynamic>> register(
      String username, String email, String password) async {
    try {
      final response = await _dio.post(
        '/auth/register',
        data: {
          'username': username,
          'email': email,
          'password': password,
        },
      );

      // Sauvegarder le token
      final token = response.data['token'];
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', token);

      return response.data;
    } catch (e) {
      _handleError(e);
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getUserProfile() async {
    try {
      final response = await _dio.get('/auth/me');
      return response.data;
    } catch (e) {
      _handleError(e);
      rethrow;
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }

  // Méthode générique pour les requêtes POST
  Future<Map<String, dynamic>> post(
      String endpoint, Map<String, dynamic> data) async {
    try {
      final response = await _dio.post(endpoint, data: data);
      return response.data;
    } catch (e) {
      _handleError(e);
      rethrow;
    }
  }

  // Gestion des erreurs
  void _handleError(dynamic error) {
    if (error is DioException) {
      final statusCode = error.response?.statusCode;
      final data = error.response?.data;
      final message =
          data is Map ? data['message'] : (error.message ?? 'Erreur réseau');

      // Log more details for debugging
      print('API Error: Status: $statusCode, Message: $message');
      print('Request path: ${error.requestOptions.path}');

      if (statusCode == 401) {
        // Auth error, detailed handling
        if (message.toString().contains('Token invalide') ||
            message.toString().contains('Accès non autorisé')) {
          throw Exception(message);
        }
        throw Exception('Erreur d\'authentification: $message');
      } else if (statusCode == 404) {
        throw Exception('Ressource introuvable: $message');
      } else if (statusCode == 500) {
        throw Exception('Erreur serveur: $message');
      }

      throw Exception(message);
    } else {
      print('Non-Dio error: ${error.toString()}');
      throw Exception('Une erreur est survenue: ${error.toString()}');
    }
  }
}

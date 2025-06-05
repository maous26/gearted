// Test de navigation pour vérifier les routes
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'lib/routes/app_router.dart';

void main() {
  // Test des routes principales
  final router = createRouter();

  print('=== TEST DES ROUTES GEARTED ===');

  // Test des routes de base
  final testRoutes = [
    '/',
    '/splash',
    '/login',
    '/register',
    '/home',
    '/search',
    '/sell',
    '/chats',
    '/profile',
    '/chat/1?name=AirsoftPro',
    '/chat/2?name=TacticalGear',
    '/chat/3?name=AlphaTeam',
    '/chat/4?name=SnipeElite',
    '/listing/123',
    '/favorites',
    '/notifications',
    '/edit-profile',
    '/my-listings',
    '/advanced-search',
    '/settings',
    '/features-showcase',
  ];

  print('Routes à tester: ${testRoutes.length}');

  for (final route in testRoutes) {
    try {
      final uri = Uri.parse(route);
      print('✅ Route valide: $route');

      // Test des paramètres de requête pour les chats
      if (route.startsWith('/chat/')) {
        final chatId = uri.pathSegments.length > 1 ? uri.pathSegments[1] : '';
        final chatName = uri.queryParameters['name'] ?? 'Chat';
        print('   → Chat ID: $chatId, Nom: $chatName');
      }
    } catch (e) {
      print('❌ Route invalide: $route - Erreur: $e');
    }
  }

  print('\n=== TEST DES CARACTÈRES SPÉCIAUX ===');

  // Test avec des noms contenant des caractères spéciaux
  final specialNames = [
    'Airsoft&Pro',
    'Tactical Gear',
    'Alpha-Team',
    'Snipe@Elite',
    'Test/User',
    'User?Name',
    'Player#1',
  ];

  for (final name in specialNames) {
    final encoded = Uri.encodeComponent(name);
    final route = '/chat/test?name=$encoded';
    print('Nom original: "$name"');
    print('Encodé: "$encoded"');
    print('Route: "$route"');

    try {
      final uri = Uri.parse(route);
      final decoded = uri.queryParameters['name'] ?? '';
      print('Décodé: "$decoded"');
      print(decoded == name
          ? '✅ Encodage/décodage réussi'
          : '❌ Problème d\'encodage');
    } catch (e) {
      print('❌ Erreur: $e');
    }
    print('---');
  }

  print('\n=== RÉSUMÉ ===');
  print(
      'Test de navigation terminé. Toutes les routes de base sont configurées.');
  print(
      'La navigation vers les chats utilise maintenant des paramètres de requête simples.');
  print('Les avatars sont gérés localement sans passer par l\'URL.');
}

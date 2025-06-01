import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/layout/main_layout.dart';
import '../features/auth/screens/splash_screen.dart';
import '../features/auth/screens/login_screen.dart';
import '../features/auth/screens/register_screen.dart';
import '../features/home/screens/home_screen.dart';
import '../features/search/screens/search_screen.dart';
import '../features/listing/screens/create_listing_screen.dart';
import '../features/listing/screens/listing_detail_screen.dart';
import '../features/chat/screens/chat_list_screen.dart';
import '../features/profile/screens/profile_screen.dart';
import '../features/favorites/screens/favorites_screen.dart';
import '../features/notifications/screens/notifications_screen.dart';
import '../features/chat/screens/chat_screen.dart';
import '../features/profile/screens/edit_profile_screen.dart';
import '../features/listing/screens/my_listings_screen.dart';
import '../features/search/screens/advanced_search_screen.dart';
import '../features/settings/screens/settings_screen.dart';
import '../features/showcase/screens/features_showcase_screen.dart';

GoRouter createRouter() {
  return GoRouter(
    initialLocation: '/splash',
    routes: [
      // Root route redirect to home
      GoRoute(
        path: '/',
        redirect: (context, state) => '/home',
      ),

      // Splash screen
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),

      // Routes d'authentification
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),

      // Routes principales avec layout
      GoRoute(
        path: '/home',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const MainLayout(
            currentIndex: 0,
            child: HomeScreen(),
          ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      ),
      GoRoute(
        path: '/search',
        pageBuilder: (context, state) {
          final category = state.uri.queryParameters['category'];
          return CustomTransitionPage(
            key: state.pageKey,
            child: MainLayout(
              currentIndex: 1,
              child: SearchScreen(category: category),
            ),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          );
        },
      ),
      GoRoute(
        path: '/sell',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const MainLayout(
            currentIndex: 2,
            child: CreateListingScreen(),
          ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      ),
      GoRoute(
        path: '/chats',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const MainLayout(
            currentIndex: 3,
            child: ChatListScreen(),
          ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      ),
      GoRoute(
        path: '/profile',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const MainLayout(
            currentIndex: 4,
            child: ProfileScreen(),
          ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      ),

      // Détail d'une annonce
      GoRoute(
        path: '/listing/:id',
        builder: (context, state) {
          final listingId = state.pathParameters['id'] ?? '';
          return ListingDetailScreen(listingId: listingId);
        },
      ),

      // Favorites screen
      GoRoute(
        path: '/favorites',
        builder: (context, state) => const FavoritesScreen(),
      ),

      // Notifications screen
      GoRoute(
        path: '/notifications',
        builder: (context, state) => const NotificationsScreen(),
      ),

      // Individual chat conversation
      GoRoute(
        path: '/chat/:chatId',
        builder: (context, state) {
          final chatId = state.pathParameters['chatId'] ?? '';
          final chatName = state.uri.queryParameters['name'] ?? 'Chat';

          print('Navigation vers chat - ID: $chatId');
          print('Nom: $chatName');
          print('URL complète: ${state.uri}');

          return ChatScreen(
            chatId: chatId,
            chatName: chatName,
          );
        },
      ),

      // Edit profile screen
      GoRoute(
        path: '/edit-profile',
        builder: (context, state) => const EditProfileScreen(),
      ),

      // My listings screen
      GoRoute(
        path: '/my-listings',
        builder: (context, state) => const MyListingsScreen(),
      ),

      // Advanced search screen
      GoRoute(
        path: '/advanced-search',
        builder: (context, state) => const AdvancedSearchScreen(),
      ),

      // Settings screen
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),

      // Features showcase screen
      GoRoute(
        path: '/features-showcase',
        builder: (context, state) => const FeaturesShowcaseScreen(),
      ),
    ],
    errorBuilder: (context, state) {
      print('Erreur de routage: ${state.uri}'); // Debug log
      print('Path: ${state.uri.path}'); // Debug log
      print('Query: ${state.uri.queryParameters}'); // Debug log
      return Scaffold(
        appBar: AppBar(
          title: const Text('Erreur de navigation'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.go('/chats'),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text('Route non trouvée: ${state.uri}'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => context.go('/chats'),
                child: const Text('Retour aux conversations'),
              ),
            ],
          ),
        ),
      );
    },
  );
}

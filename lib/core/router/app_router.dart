import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/register_screen.dart';
import '../../features/main/screens/main_navigation_screen.dart';
import '../../features/home/screens/home_screen.dart';
import '../../features/ai_tools/screens/ai_tools_screen.dart';
import '../../features/ai_tools/screens/crop_suggestion_screen.dart';
import '../../features/ai_tools/screens/plant_doctor_screen.dart';
import '../../features/ai_tools/screens/ar_view_screen.dart';
import '../../features/market/screens/market_screen.dart';
import '../../features/market/screens/product_detail_screen.dart';
import '../../features/community/screens/community_screen.dart';
import '../../features/community/screens/forum_post_detail_screen.dart';
import '../../features/profile/screens/profile_screen.dart';
import '../../features/profile/screens/settings_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/main',
    routes: [
      // Auth Routes
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),
      
      // Main Navigation
      ShellRoute(
        builder: (context, state, child) => MainNavigationScreen(child: child),
        routes: [
          GoRoute(
            path: '/main',
            name: 'main',
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: '/home',
            name: 'home',
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: '/ai-tools',
            name: 'ai-tools',
            builder: (context, state) => const AIToolsScreen(),
            routes: [
              GoRoute(
                path: 'crop-suggestion',
                name: 'crop-suggestion',
                builder: (context, state) => const CropSuggestionScreen(),
              ),
              GoRoute(
                path: 'plant-doctor',
                name: 'plant-doctor',
                builder: (context, state) => const PlantDoctorScreen(),
              ),
              GoRoute(
                path: 'ar-view',
                name: 'ar-view',
                builder: (context, state) => const ARViewScreen(),
              ),
            ],
          ),
          GoRoute(
            path: '/market',
            name: 'market',
            builder: (context, state) => const MarketScreen(),
            routes: [
              GoRoute(
                path: 'product/:productId',
                name: 'product-detail',
                builder: (context, state) {
                  final productId = state.pathParameters['productId']!;
                  return ProductDetailScreen(productId: productId);
                },
              ),
            ],
          ),
          GoRoute(
            path: '/community',
            name: 'community',
            builder: (context, state) => const CommunityScreen(),
            routes: [
              GoRoute(
                path: 'post/:postId',
                name: 'forum-post-detail',
                builder: (context, state) {
                  final postId = state.pathParameters['postId']!;
                  return ForumPostDetailScreen(postId: postId);
                },
              ),
            ],
          ),
          GoRoute(
            path: '/profile',
            name: 'profile',
            builder: (context, state) => const ProfileScreen(),
            routes: [
              GoRoute(
                path: 'settings',
                name: 'settings',
                builder: (context, state) => const SettingsScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              'Page not found',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'The page you are looking for does not exist.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go('/main'),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    ),
  );
}

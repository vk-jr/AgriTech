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
import '../utils/page_transitions.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/main',
    routes: [
      // Auth Routes
      GoRoute(
        path: '/login',
        name: 'login',
        pageBuilder: (context, state) => PageTransitions.fadeWithScale(
          const LoginScreen(),
          state,
          name: 'login',
        ),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        pageBuilder: (context, state) => PageTransitions.slideFromRight(
          const RegisterScreen(),
          state,
          name: 'register',
        ),
      ),
      
      // Main Navigation
      ShellRoute(
        builder: (context, state, child) => MainNavigationScreen(child: child),
        routes: [
          GoRoute(
            path: '/main',
            name: 'main',
            pageBuilder: (context, state) => PageTransitions.smoothFade(
              const HomeScreen(),
              state,
              name: 'main',
            ),
          ),
          GoRoute(
            path: '/home',
            name: 'home',
            pageBuilder: (context, state) => PageTransitions.smoothFade(
              const HomeScreen(),
              state,
              name: 'home',
            ),
          ),
          GoRoute(
            path: '/ai-tools',
            name: 'ai-tools',
            pageBuilder: (context, state) => PageTransitions.smoothFade(
              const AIToolsScreen(),
              state,
              name: 'ai-tools',
            ),
            routes: [
              GoRoute(
                path: 'crop-suggestion',
                name: 'crop-suggestion',
                pageBuilder: (context, state) => PageTransitions.slideFromRight(
                  const CropSuggestionScreen(),
                  state,
                  name: 'crop-suggestion',
                ),
              ),
              GoRoute(
                path: 'plant-doctor',
                name: 'plant-doctor',
                pageBuilder: (context, state) => PageTransitions.slideFromRight(
                  const PlantDoctorScreen(),
                  state,
                  name: 'plant-doctor',
                ),
              ),
              GoRoute(
                path: 'ar-view',
                name: 'ar-view',
                pageBuilder: (context, state) => PageTransitions.heroTransition(
                  const ARViewScreen(),
                  state,
                  name: 'ar-view',
                ),
              ),
            ],
          ),
          GoRoute(
            path: '/market',
            name: 'market',
            pageBuilder: (context, state) => PageTransitions.smoothFade(
              const MarketScreen(),
              state,
              name: 'market',
            ),
            routes: [
              GoRoute(
                path: 'product/:productId',
                name: 'product-detail',
                pageBuilder: (context, state) {
                  final productId = state.pathParameters['productId']!;
                  return PageTransitions.heroTransition(
                    ProductDetailScreen(productId: productId),
                    state,
                    name: 'product-detail',
                  );
                },
              ),
            ],
          ),
          GoRoute(
            path: '/community',
            name: 'community',
            pageBuilder: (context, state) => PageTransitions.smoothFade(
              const CommunityScreen(),
              state,
              name: 'community',
            ),
            routes: [
              GoRoute(
                path: 'post/:postId',
                name: 'forum-post-detail',
                pageBuilder: (context, state) {
                  final postId = state.pathParameters['postId']!;
                  return PageTransitions.slideFromBottom(
                    ForumPostDetailScreen(postId: postId),
                    state,
                    name: 'forum-post-detail',
                  );
                },
              ),
            ],
          ),
          GoRoute(
            path: '/profile',
            name: 'profile',
            pageBuilder: (context, state) => PageTransitions.smoothFade(
              const ProfileScreen(),
              state,
              name: 'profile',
            ),
            routes: [
              GoRoute(
                path: 'settings',
                name: 'settings',
                pageBuilder: (context, state) => PageTransitions.slideFromRight(
                  const SettingsScreen(),
                  state,
                  name: 'settings',
                ),
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

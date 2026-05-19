import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hciiii/app/route_observer.dart';
import 'package:hciiii/features/accessibility/presentation/accessibility_settings_screen.dart';
import 'package:hciiii/features/auth/presentation/auth_screen.dart';
import 'package:hciiii/features/auth/presentation/splash_screen.dart';
import 'package:hciiii/features/camera/presentation/camera_screen.dart';
import 'package:hciiii/features/chat/presentation/chat_screen.dart';
import 'package:hciiii/features/profile/presentation/profile_screen.dart';
import 'package:hciiii/features/reels/presentation/reels_screen.dart';
import 'package:hciiii/features/shared/widgets/main_shell_screen.dart';
import 'package:hciiii/features/stories/presentation/stories_screen.dart';

class AppRouter {
  AppRouter();

  late final GoRouter router = GoRouter(
    initialLocation: '/splash',
    observers: [routeObserver],
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/auth',
        builder: (context, state) => const AuthScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainShellScreen(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/app/chat',
                builder: (context, state) => const ChatScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/app/stories',
                builder: (context, state) => const StoriesScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/app/camera',
                builder: (context, state) => const CameraScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/app/reels',
                builder: (context, state) => const ReelsScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/app/profile',
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/accessibility',
        builder: (context, state) => const AccessibilitySettingsScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(child: Text(state.error.toString())),
    ),
  );
}

final appRouterProvider = Provider<GoRouter>((ref) {
  return AppRouter().router;
});

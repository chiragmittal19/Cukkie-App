import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../ui/features/auth/views/login_view.dart';
import '../../ui/features/favourites/views/favourites_view.dart';
import '../../ui/features/home/views/home_view.dart';
import '../../ui/features/onboarding/views/language_selection_view.dart';
import '../../ui/features/preferences/views/preferences_view.dart';
import '../../ui/features/profile/views/profile_view.dart';
import '../../ui/features/recipe/views/recipe_detail_view.dart';
import '../../ui/features/settings/views/settings_view.dart';

import '../../ui/features/splash/views/splash_screen_view.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

GoRouter createAppRouter() {
  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreenView(),
      ),
      GoRoute(
        path: '/',
        redirect: (context, state) => '/splash',
      ),
      GoRoute(
        path: '/language',
        builder: (context, state) {
          final isInitial = state.uri.queryParameters['isInitialOnboarding'] == 'true';
          return LanguageSelectionView(isInitialOnboarding: isInitial);
        },
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) {
          final isInitial = state.uri.queryParameters['isInitialOnboarding'] == 'true';
          return LoginView(isInitialOnboarding: isInitial);
        },
      ),
      GoRoute(
        path: '/preferences',
        builder: (context, state) {
          final isInitial = state.uri.queryParameters['isInitialOnboarding'] == 'true';
          return PreferencesView(isInitialOnboarding: isInitial);
        },
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeView(),
      ),
      GoRoute(
        path: '/favourites',
        builder: (context, state) => const FavouritesView(),
      ),
      GoRoute(
        path: '/recipe/:id',
        builder: (context, state) {
          final dishId = state.pathParameters['id'] ?? 'dish_paratha';
          final stepStr = state.uri.queryParameters['step'];
          final stepIndex = stepStr != null ? int.tryParse(stepStr) : null;
          return RecipeDetailView(dishId: dishId, initialStepIndex: stepIndex);
        },
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfileView(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsView(),
      ),
    ],
  );
}

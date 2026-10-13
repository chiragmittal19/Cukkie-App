import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cukkie/data/services/local/secure_prefs_service.dart';
import 'package:cukkie/data/services/http/http_auth_service.dart';
import 'package:cukkie/data/services/http/http_recipe_service.dart';
import 'package:cukkie/data/services/http/http_content_service.dart';
import 'package:cukkie/data/services/http/http_log_service.dart';
import 'package:cukkie/data/models/user_profile_model.dart';
import 'package:cukkie/data/models/dish_summary_model.dart';

class _RealHttpOverrides extends HttpOverrides {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = _RealHttpOverrides();

  group('Live Backend Microservices HTTP Integration Tests', () {
    late HttpAuthService authService;
    late HttpRecipeService recipeService;
    late HttpContentService contentService;
    late HttpLogService logService;
    late SecurePrefsService prefsService;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      prefsService = SecurePrefsService.instance;
      await prefsService.init();

      authService = HttpAuthService();
      recipeService = HttpRecipeService();
      contentService = HttpContentService();
      logService = HttpLogService();
    });

    test('Live user_service: Content and App Config endpoints deliver localized data', () async {
      final enStrings = await contentService.getAppStrings('en');
      expect(enStrings.appName, 'Cukkie');
      expect(enStrings.get('searchHint'), contains('Search'));

      final hiStrings = await contentService.getAppStrings('hi');
      expect(hiStrings.appName, 'कुक्की');

      final prefConfig = await contentService.getPreferencesConfig('en');
      expect(prefConfig.title, contains('Preferences'));
      expect(prefConfig.groups.isNotEmpty, true);
    });

    test('Live user_service: OTP flow (send + verify 1234) issues valid JWT session', () async {
      const testPhone = '+919876543210';
      final sendOk = await authService.sendOtp(testPhone);
      expect(sendOk, true);

      final profile = await authService.verifyOtp(testPhone, '1234');
      expect(profile.isLoggedIn, true);
      expect(profile.phoneNumber, testPhone);
      expect(profile.token, isNotNull);
      expect(profile.token!.isNotEmpty, true);

      // Verify token persisted in SecurePrefsService
      expect(prefsService.getAuthToken(), profile.token);

      // Update preferences on live user_service
      await authService.updatePreferences(
        const UserPreferencesModel(
          cuisines: ['North Indian', 'Italian'],
          dietaryChoices: ['Vegetarian'],
          spiceLevel: 'Spicy',
          sweetnessLevel: 'Medium',
          hasSavedPreferences: true,
        ),
      );

      // Verify profile fetch returns saved preferences
      final fetchedProfile = await authService.getUserProfile();
      expect(fetchedProfile.isLoggedIn, true);
      expect(fetchedProfile.preferences.hasSavedPreferences, true);
      expect(fetchedProfile.preferences.cuisines, contains('North Indian'));
    });

    test('Live recipe_service: Home feed with single filters query param works correctly', () async {
      // 1. Fetch initial home feed
      final homeData = await recipeService.getHomePageData();
      expect(homeData.dishes.isNotEmpty, true);
      expect(homeData.filterGroups.isNotEmpty, true);
      expect(homeData.sorters.isNotEmpty, true);

      // 2. Query with single 'filters' param (e.g. cuisines:North Indian)
      final filteredHome = await recipeService.getHomePageData(
        selectedFilters: {
          'cuisines': ['North Indian'],
        },
      );
      expect(filteredHome.dishes.isNotEmpty, true);
      for (final dish in filteredHome.dishes) {
        expect(dish.cuisine.toLowerCase(), 'north indian');
      }

      // 3. Query with search param
      final searchHome = await recipeService.getHomePageData(
        searchQuery: 'Paneer',
      );
      expect(searchHome.dishes.isNotEmpty, true);
      for (final dish in searchHome.dishes) {
        expect(dish.name.toLowerCase().contains('paneer'), true);
      }
    });

    test('Live recipe_service: Dish detail by query param ?id=... returns full recipe data', () async {
      final homeData = await recipeService.getHomePageData();
      final firstDishId = homeData.dishes.first.id;

      final dishDetail = await recipeService.getDishDetail(firstDishId);
      expect(dishDetail.id, firstDishId);
      expect(dishDetail.name.isNotEmpty, true);
      expect(dishDetail.portionDefinition.defaultAmount > 0, true);
      expect(dishDetail.ingredients.isNotEmpty, true);
      expect(dishDetail.steps.isNotEmpty, true);
      expect(dishDetail.feedbackFormFields.isNotEmpty, true);
    });

    test('Live recipe_service: Toggle favourite, fetch favourites, and submit feedback', () async {
      // Login first so JWT Bearer is attached to subsequent calls
      await authService.verifyOtp('+919876543210', '1234');

      final homeData = await recipeService.getHomePageData();
      final targetDishId = homeData.dishes.first.id;

      // Toggle favourite idempotently
      final isFavAfterToggle = await recipeService.toggleFavourite(targetDishId);
      // Toggle again to verify toggle mechanism flips state back
      final isFavAfterSecondToggle = await recipeService.toggleFavourite(targetDishId);
      expect(isFavAfterSecondToggle, !isFavAfterToggle);

      // Fetch favourites
      final favs = await recipeService.getFavourites();
      expect(favs, isA<List<DishSummaryModel>>());

      // Submit feedback with query param ?id=targetDishId
      await expectLater(
        recipeService.submitFeedback(targetDishId, {
          'rating': 5,
          'notes': 'Amazing dish with live backend integration!',
        }),
        completes,
      );
    });

    test('Live log_service: Batch event and metric ingestion succeeds', () async {
      await expectLater(
        logService.logEvent('dish_cooked_test', {'dishId': 'dish_pbm', 'portion': 2}),
        completes,
      );

      await expectLater(
        logService.logMetric('test_step_duration_seconds', 42.0, {'step': 'step_1'}),
        completes,
      );
    });
  });
}

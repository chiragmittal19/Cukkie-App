import 'package:flutter_test/flutter_test.dart';
import 'package:cukkie/data/services/mock/mock_auth_service.dart';
import 'package:cukkie/data/services/mock/mock_recipe_service.dart';
import 'package:cukkie/data/services/local/local_sql_database_service.dart';
import 'package:cukkie/core/services/tts_service.dart';
import 'package:cukkie/ui/features/auth/view_models/auth_view_model.dart';
import 'package:cukkie/ui/features/home/view_models/home_view_model.dart';
import 'package:cukkie/ui/features/recipe/view_models/recipe_view_model.dart';

class FakeTtsService extends TtsService {
  @override
  Future<void> speak(String text) async {}

  @override
  Future<void> stop() async {}
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Auth & Recipe ViewModel Integration Tests', () {
    late MockAuthService authService;
    late MockRecipeService recipeService;
    late LocalSqlDatabaseService localDb;
    late FakeTtsService fakeTtsService;
    late AuthViewModel authVm;
    late HomeViewModel homeVm;

    setUp(() async {
      authService = MockAuthService();
      recipeService = MockRecipeService();
      localDb = LocalSqlDatabaseService.instance;
      fakeTtsService = FakeTtsService();

      // Clear local db
      final existing = await localDb.getUnfinishedRecipes();
      for (final e in existing) {
        await localDb.removeRecipe(e.dishId);
      }

      authVm = AuthViewModel(authService: authService);
      homeVm = HomeViewModel(
        recipeService: recipeService,
        authViewModel: authVm,
        localDbService: localDb,
      );
    });

    test('Unauthenticated user favorite action sets pending action and triggers login guard', () async {
      await homeVm.loadHomePageData();
      expect(homeVm.homePayload?.dishes.isNotEmpty, isTrue);

      // Select a dish that is not yet favourited
      final dish = homeVm.homePayload!.dishes.firstWhere((d) => !d.isFavourite);
      expect(authVm.isLoggedIn, isFalse);

      // Attempting toggleFavourite while logged out returns false (triggers view login guard)
      final toggleSuccess = await homeVm.toggleFavourite(dish.id);
      expect(toggleSuccess, isFalse);

      // View records pending action
      authVm.setPendingAction(
        PendingAction(type: PendingActionType.toggleFavourite, targetId: dish.id),
      );
      expect(authVm.pendingAction, isNotNull);
      expect(authVm.pendingAction!.targetId, dish.id);

      // User logs in via OTP
      final verifyOk = await authVm.verifyOtp('9876543210', '1234');
      expect(verifyOk, isTrue);
      expect(authVm.isLoggedIn, isTrue);

      // View consumes pending action and completes favorite toggle
      final pending = authVm.consumePendingAction();
      expect(pending, isNotNull);
      expect(authVm.pendingAction, isNull);

      final loggedInToggle = await homeVm.toggleFavourite(pending!.targetId);
      expect(loggedInToggle, isTrue);
    });

    test('RecipeViewModel immediate render auto-save on initial load and step change', () async {
      final recipeVm = RecipeViewModel(
        recipeService: recipeService,
        ttsService: fakeTtsService,
        localDbService: localDb,
      );

      // Load recipe with valid mock id
      await recipeVm.loadRecipe('dish_paratha');
      expect(recipeVm.dish, isNotNull);
      expect(recipeVm.currentStepIndex, 0);

      // Requirement 8: Step 0 is NOT saved to unfinished recipes
      final savedProgressStep0 = await localDb.getRecipeProgress('dish_paratha');
      expect(savedProgressStep0, isNull);

      // Navigate to step 1 (second step)
      await recipeVm.setStepIndex(1);
      expect(recipeVm.currentStepIndex, 1);
      final savedProgressStep1 = await localDb.getRecipeProgress('dish_paratha');
      expect(savedProgressStep1, isNotNull);
      expect(savedProgressStep1!.stepIndex, 1);

      // Navigate to step 2
      await recipeVm.setStepIndex(2);
      expect(recipeVm.currentStepIndex, 2);

      // Verify immediate update in local database
      final savedProgressStep2 = await localDb.getRecipeProgress('dish_paratha');
      expect(savedProgressStep2!.stepIndex, 2);
      expect(savedProgressStep2.stepHeading, recipeVm.currentStep!.heading);

      // Navigating back to step 1 saves step 1 as resume target
      await recipeVm.prevStep();
      expect(recipeVm.currentStepIndex, 1);
      final savedProgressStep1Again = await localDb.getRecipeProgress('dish_paratha');
      expect(savedProgressStep1Again!.stepIndex, 1);
    });

    test('RecipeViewModel portion updating recalculates and persists', () async {
      final recipeVm = RecipeViewModel(
        recipeService: recipeService,
        ttsService: fakeTtsService,
        localDbService: localDb,
      );

      await recipeVm.loadRecipe('dish_paratha');
      expect(recipeVm.currentPortion, 4.0);

      // Move to step 1 so progress is saved
      await recipeVm.setStepIndex(1);
      await recipeVm.updatePortion(6.0);
      expect(recipeVm.currentPortion, 6.0);

      final saved = await localDb.getRecipeProgress('dish_paratha');
      expect(saved!.portionAmount, 6.0);
    });

    test('RecipeViewModel dynamic feedback submission purges local unfinished recipe', () async {
      final recipeVm = RecipeViewModel(
        recipeService: recipeService,
        ttsService: fakeTtsService,
        localDbService: localDb,
      );

      await recipeVm.loadRecipe('dish_paratha');
      // Advance to step 1 so it gets added to unfinished recipes
      await recipeVm.setStepIndex(1);
      expect(await localDb.getRecipeProgress('dish_paratha'), isNotNull);

      // Provide feedback responses
      recipeVm.setFeedbackResponse('overall_taste', 5);
      recipeVm.setFeedbackResponse('portion_accuracy', 'Just Right');

      // Submit feedback
      final submitSuccess = await recipeVm.submitFeedback();
      expect(submitSuccess, isTrue);
      expect(recipeVm.isRecipeCompleted, isTrue);

      // Recipe must be purged from local SQL database upon completion
      final savedAfterCompletion = await localDb.getRecipeProgress('dish_paratha');
      expect(savedAfterCompletion, isNull);
    });
  });
}

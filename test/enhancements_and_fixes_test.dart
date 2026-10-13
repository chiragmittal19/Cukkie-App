import 'package:cukkie/data/models/unfinished_recipe_model.dart';
import 'package:cukkie/data/services/local/local_sql_database_service.dart';
import 'package:cukkie/data/services/mock/mock_auth_service.dart';
import 'package:cukkie/data/services/mock/mock_recipe_service.dart';
import 'package:cukkie/ui/features/auth/view_models/auth_view_model.dart';
import 'package:cukkie/ui/features/home/view_models/home_view_model.dart';
import 'package:cukkie/ui/features/recipe/view_models/recipe_view_model.dart';
import 'package:flutter_test/flutter_test.dart';

import 'auth_and_recipe_view_model_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Enhancements & Fixes Verification Tests', () {
    late LocalSqlDatabaseService localDb;
    late MockRecipeService recipeService;
    late MockAuthService authService;
    late AuthViewModel authVm;
    late HomeViewModel homeVm;

    setUp(() {
      localDb = LocalSqlDatabaseService.instance;
      recipeService = MockRecipeService();
      authService = MockAuthService();
      authVm = AuthViewModel(authService: authService);
      homeVm = HomeViewModel(
        recipeService: recipeService,
        authViewModel: authVm,
        localDbService: localDb,
      );
    });

    test('LocalSqlDatabaseService broadcasts change event on save and remove', () async {
      int eventsReceived = 0;
      final sub = localDb.onDatabaseChanged.listen((_) {
        eventsReceived++;
      });

      final entry = UnfinishedRecipeModel(
        dishId: 'test_dish_stream',
        dishName: 'Stream Test Biryani',
        dishImage: 'https://images.unsplash.com/photo-test.jpg',
        stepIndex: 1,
        stepHeading: 'Portion Selector',
        portionAmount: 2.0,
        completedTodoIds: [],
        lastInteractedAt: DateTime.now(),
      );

      await localDb.saveProgress(entry);
      expect(eventsReceived, 1);

      await localDb.removeRecipe('test_dish_stream');
      expect(eventsReceived, 2);

      await sub.cancel();
    });

    test('HomeViewModel applyFiltersAndSort atomically applies filters and sorter', () async {
      await homeVm.init();
      expect(homeVm.selectedFilters.isEmpty, isTrue);

      homeVm.applyFiltersAndSort(
        filters: {
          'cuisines': ['North Indian', 'Italian'],
        },
        sortId: 'prep_time_asc',
      );

      expect(homeVm.selectedFilters['cuisines'], containsAll(['North Indian', 'Italian']));
      expect(homeVm.activeSortId, 'prep_time_asc');
    });

    test('RecipeViewModel only saves to unfinished recipes when stepIndex >= 1', () async {
      final fakeTts = FakeTtsService();
      final recipeVm = RecipeViewModel(
        recipeService: recipeService,
        ttsService: fakeTts,
        localDbService: localDb,
      );

      await recipeVm.loadRecipe('dish_paratha');
      expect(recipeVm.currentStepIndex, 0);

      // Step 0: Must NOT be saved
      expect(await localDb.getRecipeProgress('dish_paratha'), isNull);

      // Advance to Step 1 (Portion Selector): Must be saved
      await recipeVm.setStepIndex(1);
      final saved1 = await localDb.getRecipeProgress('dish_paratha');
      expect(saved1, isNotNull);
      expect(saved1!.stepIndex, 1);

      // Clean up
      await localDb.removeRecipe('dish_paratha');
    });

    test('RecipeService returns distinct, accurate recipes for all dishes on home page', () async {
      final misal = await recipeService.getDishDetail('dish_misal');
      expect(misal.id, 'dish_misal');
      expect(misal.name, 'Authentic Misal Pav');
      expect(misal.ingredients.any((i) => i.name.contains('Matki')), isTrue);

      final pizza = await recipeService.getDishDetail('dish_pizza');
      expect(pizza.id, 'dish_pizza');
      expect(pizza.name, 'Neapolitan Margherita Pizza');
      expect(pizza.ingredients.any((i) => i.name.contains('Mozzarella')), isTrue);

      final pasta = await recipeService.getDishDetail('dish_arrabbiata');
      expect(pasta.id, 'dish_arrabbiata');
      expect(pasta.name, 'Penne all\'Arrabbiata');
      expect(pasta.ingredients.any((i) => i.name.contains('Penne')), isTrue);

      final pbm = await recipeService.getDishDetail('dish_pbm');
      expect(pbm.id, 'dish_pbm');
      expect(pbm.name, 'Paneer Butter Masala');
    });
  });
}

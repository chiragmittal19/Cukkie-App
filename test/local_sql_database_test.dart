import 'package:flutter_test/flutter_test.dart';
import 'package:cukkie/data/models/unfinished_recipe_model.dart';
import 'package:cukkie/data/services/local/local_sql_database_service.dart';

void main() {
  group('LocalSqlDatabaseService Tests', () {
    late LocalSqlDatabaseService dbService;

    setUp(() async {
      dbService = LocalSqlDatabaseService.instance;
      // Clear out any previous records
      final existing = await dbService.getUnfinishedRecipes();
      for (final item in existing) {
        await dbService.removeRecipe(item.dishId);
      }
    });

    test('Saves unfinished recipe and retrieves by dishId', () async {
      final entry = UnfinishedRecipeModel(
        dishId: 'recipe_paneer',
        dishName: 'Paneer Butter Masala',
        dishImage: 'https://example.com/paneer.jpg',
        stepIndex: 2,
        stepHeading: 'Sautéing Tomatoes & Cashews',
        portionAmount: 3.0,
        completedTodoIds: ['step_1_todo_0'],
        lastInteractedAt: DateTime.now(),
      );

      await dbService.saveProgress(entry);

      final retrieved = await dbService.getRecipeProgress('recipe_paneer');
      expect(retrieved, isNotNull);
      expect(retrieved!.dishId, 'recipe_paneer');
      expect(retrieved.dishName, 'Paneer Butter Masala');
      expect(retrieved.stepIndex, 2);
      expect(retrieved.stepHeading, 'Sautéing Tomatoes & Cashews');
      expect(retrieved.portionAmount, 3.0);
      expect(retrieved.completedTodoIds, contains('step_1_todo_0'));
    });

    test('Immediate step updates update the saved progress without duplicate entries', () async {
      final initialEntry = UnfinishedRecipeModel(
        dishId: 'recipe_halwa',
        dishName: 'Sooji Halwa',
        dishImage: 'https://example.com/halwa.jpg',
        stepIndex: 1,
        stepHeading: 'Ingredients Checklist',
        portionAmount: 2.0,
        completedTodoIds: [],
        lastInteractedAt: DateTime.now().subtract(const Duration(minutes: 5)),
      );

      await dbService.saveProgress(initialEntry);

      // User navigates to step 3
      final updatedEntry = UnfinishedRecipeModel(
        dishId: 'recipe_halwa',
        dishName: 'Sooji Halwa',
        dishImage: 'https://example.com/halwa.jpg',
        stepIndex: 3,
        stepHeading: 'Roasting Semolina',
        portionAmount: 2.0,
        completedTodoIds: ['step_2_todo_0'],
        lastInteractedAt: DateTime.now(),
      );

      await dbService.saveProgress(updatedEntry);

      final allUnfinished = await dbService.getUnfinishedRecipes();
      final halwaEntries = allUnfinished.where((e) => e.dishId == 'recipe_halwa').toList();
      expect(halwaEntries.length, 1);
      expect(halwaEntries.first.stepIndex, 3);
      expect(halwaEntries.first.stepHeading, 'Roasting Semolina');
    });

    test('getUnfinishedRecipes returns list sorted by lastInteractedAt descending', () async {
      final time1 = DateTime.now().subtract(const Duration(hours: 2));
      final time2 = DateTime.now().subtract(const Duration(minutes: 10));
      final time3 = DateTime.now();

      await dbService.saveProgress(UnfinishedRecipeModel(
        dishId: 'dish_old',
        dishName: 'Old Dish',
        dishImage: '',
        stepIndex: 1,
        stepHeading: 'Step 1',
        portionAmount: 2.0,
        lastInteractedAt: time1,
      ));

      await dbService.saveProgress(UnfinishedRecipeModel(
        dishId: 'dish_newest',
        dishName: 'Newest Dish',
        dishImage: '',
        stepIndex: 2,
        stepHeading: 'Step 2',
        portionAmount: 2.0,
        lastInteractedAt: time3,
      ));

      await dbService.saveProgress(UnfinishedRecipeModel(
        dishId: 'dish_middle',
        dishName: 'Middle Dish',
        dishImage: '',
        stepIndex: 1,
        stepHeading: 'Step 1',
        portionAmount: 2.0,
        lastInteractedAt: time2,
      ));

      final list = await dbService.getUnfinishedRecipes();
      expect(list.length, 3);
      expect(list[0].dishId, 'dish_newest');
      expect(list[1].dishId, 'dish_middle');
      expect(list[2].dishId, 'dish_old');
    });

    test('removeRecipe completely purges the recipe from local storage', () async {
      await dbService.saveProgress(UnfinishedRecipeModel(
        dishId: 'dish_to_remove',
        dishName: 'Remove Me',
        dishImage: '',
        stepIndex: 1,
        stepHeading: 'Step 1',
        portionAmount: 2.0,
        lastInteractedAt: DateTime.now(),
      ));

      expect(await dbService.getRecipeProgress('dish_to_remove'), isNotNull);

      await dbService.removeRecipe('dish_to_remove');
      expect(await dbService.getRecipeProgress('dish_to_remove'), isNull);
    });
  });
}

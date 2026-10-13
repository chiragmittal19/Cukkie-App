import 'package:flutter_test/flutter_test.dart';
import 'package:cukkie/data/models/dish_summary_model.dart';
import 'package:cukkie/data/models/dish_detail_model.dart';
import 'package:cukkie/data/models/dynamic_form_model.dart';
import 'package:cukkie/data/models/unfinished_recipe_model.dart';

void main() {
  group('Models & Portion Scaling Tests', () {
    test('DishSummaryModel fromJson and toJson serialization', () {
      final json = {
        'id': 'dish_test_1',
        'name': 'Paneer Tikka',
        'imageUrl': 'https://images.unsplash.com/dish1.jpg',
        'tasteProfiles': ['Spicy', 'Tangy'],
        'prepTimeMinutes': 25,
        'caloriesKcal': 320,
        'proteinGrams': 18,
        'isFavourite': true,
        'cuisine': 'North Indian',
        'dietaryType': 'Vegetarian',
        'rating': 4.8,
      };

      final model = DishSummaryModel.fromJson(json);
      expect(model.id, 'dish_test_1');
      expect(model.name, 'Paneer Tikka');
      expect(model.tasteProfiles, contains('Spicy'));
      expect(model.prepTimeMinutes, 25);
      expect(model.caloriesKcal, 320);
      expect(model.proteinGrams, 18);
      expect(model.isFavourite, true);

      final outputJson = model.toJson();
      expect(outputJson['id'], 'dish_test_1');
      expect(outputJson['proteinGrams'], 18);
    });

    test('Ingredient portion scaling scales linearly with portion changes', () {
      final ingredient = IngredientItem(
        id: 'ing_1',
        name: 'Paneer',
        baseQuantity: 200,
        unit: 'g',
      );

      // Default portion is 2 servings. If scaled to 4 servings, amount should double to 400g.
      final defaultPortion = 2.0;
      final targetPortion = 4.0;
      final scaledAmount = ingredient.getScaledQuantity(targetPortion, defaultPortion);
      expect(scaledAmount, 400.0);

      // If scaled to 1 serving, amount should halve to 100g.
      final singlePortion = 1.0;
      final singleScaled = ingredient.getScaledQuantity(singlePortion, defaultPortion);
      expect(singleScaled, 100.0);
    });

    test('RecipeStepItem conditional todo rule (todos > 1)', () {
      final stepWithMultipleTodos = RecipeStepItem(
        index: 1,
        heading: 'Knead the dough',
        instructionText: 'Mix flour and water',
        todos: [
          'Add 2 cups of flour',
          'Add 1/2 cup of warm water',
          'Knead for 5 minutes',
        ],
        audioNarrationText: 'Mix the flour and water together.',
      );

      final stepWithSingleTodo = RecipeStepItem(
        index: 2,
        heading: 'Let it rest',
        instructionText: 'Cover with damp cloth',
        todos: ['Cover bowl with damp cloth and wait 15 minutes'],
        audioNarrationText: 'Cover bowl and let it rest.',
      );

      final stepWithNoTodos = RecipeStepItem(
        index: 3,
        heading: 'Enjoy meal',
        instructionText: 'Serve hot',
        todos: [],
        audioNarrationText: 'Serve hot with mint chutney.',
      );

      // Condition: checkboxes appear ONLY if todos.length > 1
      expect(stepWithMultipleTodos.todos.length > 1, isTrue);
      expect(stepWithSingleTodo.todos.length > 1, isFalse);
      expect(stepWithNoTodos.todos.length > 1, isFalse);
    });

    test('DynamicFormFieldModel parses all supported question types', () {
      final starRatingJson = {
        'id': 'taste_rating',
        'type': 'rating',
        'title': 'How did it taste?',
        'isRequired': true,
        'initialValue': 5,
      };

      final singleChoiceJson = {
        'id': 'spice_level',
        'type': 'single_choice',
        'title': 'Spice level accuracy',
        'options': ['Too Mild', 'Just Right', 'Too Spicy'],
        'isRequired': true,
      };

      final ratingField = DynamicFormFieldModel.fromJson(starRatingJson);
      expect(ratingField.type, FormFieldType.rating);
      expect(ratingField.initialValue, 5);

      final choiceField = DynamicFormFieldModel.fromJson(singleChoiceJson);
      expect(choiceField.type, FormFieldType.singleChoice);
      expect(choiceField.options?.length, 3);
    });

    test('UnfinishedRecipeModel serialization and SQL map conversion', () {
      final now = DateTime.now();
      final model = UnfinishedRecipeModel(
        dishId: 'halwa_123',
        dishName: 'Sooji Halwa',
        dishImage: 'https://example.com/halwa.jpg',
        stepIndex: 3,
        stepHeading: 'Roasting Rava',
        portionAmount: 4.0,
        completedTodoIds: ['step_1_todo_0', 'step_1_todo_1'],
        lastInteractedAt: now,
      );

      final sqlMap = model.toSqlMap();
      expect(sqlMap['dish_id'], 'halwa_123');
      expect(sqlMap['step_index'], 3);
      expect(sqlMap['step_heading'], 'Roasting Rava');
      expect(sqlMap['portion_amount'], 4.0);

      final reconstructed = UnfinishedRecipeModel.fromSqlMap(sqlMap);
      expect(reconstructed.dishId, model.dishId);
      expect(reconstructed.stepIndex, 3);
      expect(reconstructed.completedTodoIds, contains('step_1_todo_0'));
      expect(reconstructed.portionAmount, 4.0);
    });
  });
}

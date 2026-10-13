import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/services/sensory_service.dart';
import '../../../../../data/models/dish_detail_model.dart';
import '../../../settings/view_models/settings_view_model.dart';
import '../../view_models/recipe_view_model.dart';

class IngredientsChecklistStep extends StatelessWidget {
  const IngredientsChecklistStep({
    super.key,
    required this.dish,
    required this.recipeVm,
  });

  final DishDetailModel dish;
  final RecipeViewModel recipeVm;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final strings = context.watch<SettingsViewModel>().strings;
    final currentPortion = recipeVm.currentPortion;
    final basePortion = dish.portionDefinition.defaultAmount;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.basilGreen.withAlpha(25),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.checklist_rounded, color: AppColors.basilGreen, size: 24),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      strings.miseEnPlace,
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 20),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      strings.scaledFor(currentPortion, dish.portionDefinition.unit),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.basilGreen,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            strings.ingredientsChecklistInstructions,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 20),

          // Ingredients List
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: dish.ingredients.length,
            separatorBuilder: (_, index) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final ingredient = dish.ingredients[index];
              final scaledQty = ingredient.getScaledQuantity(currentPortion, basePortion);
              final isChecked = recipeVm.isTodoChecked(2, index); // step 2 is ingredients

              final formattedQty = scaledQty % 1 == 0
                  ? scaledQty.toInt().toString()
                  : scaledQty.toStringAsFixed(1);

              return InkWell(
                onTap: () {
                  SensoryService.instance.mediumImpact();
                  recipeVm.toggleTodo(2, index);
                },
                borderRadius: BorderRadius.circular(16),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: isChecked
                        ? AppColors.basilGreen.withAlpha(isDark ? 25 : 15)
                        : isDark
                            ? AppColors.cardDark
                            : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isChecked
                          ? AppColors.basilGreen
                          : isDark
                              ? AppColors.borderDark
                              : AppColors.borderLight,
                      width: isChecked ? 1.5 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      // Checkbox
                      Icon(
                        isChecked
                            ? Icons.check_box_rounded
                            : Icons.check_box_outline_blank_rounded,
                        color: isChecked
                            ? AppColors.basilGreen
                            : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
                        size: 24,
                      ),
                      const SizedBox(width: 14),

                      // Ingredient Name
                      Expanded(
                        child: Text(
                          ingredient.name,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            decoration: isChecked ? TextDecoration.lineThrough : null,
                            color: isChecked
                                ? (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight)
                                : null,
                          ),
                        ),
                      ),

                      // Scaled Quantity & Unit
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: isChecked
                              ? AppColors.basilGreen.withAlpha(30)
                              : AppColors.saffronPrimary.withAlpha(isDark ? 30 : 15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '$formattedQty ${ingredient.unit}'.trim(),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: isChecked
                                ? AppColors.basilGreen
                                : (isDark ? AppColors.saffronLight : AppColors.saffronPrimary),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

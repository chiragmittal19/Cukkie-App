import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/services/sensory_service.dart';
import '../../../../../data/models/dish_detail_model.dart';
import '../../../settings/view_models/settings_view_model.dart';
import '../../view_models/recipe_view_model.dart';

class PortionSelectorStep extends StatelessWidget {
  const PortionSelectorStep({
    super.key,
    required this.dish,
    required this.recipeVm,
  });

  final DishDetailModel dish;
  final RecipeViewModel recipeVm;

  @override
  Widget build(BuildContext context) {
    final strings = context.watch<SettingsViewModel>().strings;
    final portionDef = dish.portionDefinition;
    final currentAmount = recipeVm.currentPortion;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final formattedValue = currentAmount % 1 == 0
        ? currentAmount.toInt().toString()
        : currentAmount.toStringAsFixed(1);

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
                  color: AppColors.saffronPrimary.withAlpha(25),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.scale_rounded, color: AppColors.saffronPrimary, size: 24),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      strings.choosePortionSize,
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 20),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${strings.unit}: ${portionDef.unit.toUpperCase()}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.saffronPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            strings.portionInstructions,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 36),

          // Central Counter Card
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: isDark ? AppColors.surfaceDark : Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: isDark ? AppColors.borderDark : AppColors.borderLight,
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(isDark ? 40 : 15),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  strings.quantityToPrepare,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      formattedValue,
                      style: TextStyle(
                        fontSize: 56,
                        fontWeight: FontWeight.w900,
                        color: isDark ? AppColors.saffronLight : AppColors.saffronPrimary,
                        letterSpacing: -1,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      portionDef.unit,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Plus / Minus Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildRoundActionButton(
                      icon: Icons.remove_rounded,
                      enabled: currentAmount > portionDef.minAmount,
                      onTap: () {
                        SensoryService.instance.selectionClick();
                        recipeVm.updatePortion(currentAmount - portionDef.stepIncrement);
                      },
                    ),
                    const SizedBox(width: 32),
                    _buildRoundActionButton(
                      icon: Icons.add_rounded,
                      enabled: currentAmount < portionDef.maxAmount,
                      onTap: () {
                        SensoryService.instance.selectionClick();
                        recipeVm.updatePortion(currentAmount + portionDef.stepIncrement);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 28),

          // Informative Tip Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.turmericGold.withAlpha(isDark ? 25 : 15),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.turmericGold.withAlpha(60),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.lightbulb_outline_rounded, color: AppColors.turmericGold, size: 22),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    strings.portionTip,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: isDark ? Colors.white70 : AppColors.textPrimaryLight,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoundActionButton({
    required IconData icon,
    required bool enabled,
    required VoidCallback onTap,
  }) {
    return Material(
      color: enabled ? AppColors.saffronPrimary : Colors.grey.withAlpha(80),
      shape: const CircleBorder(),
      elevation: enabled ? 2 : 0,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: enabled ? onTap : null,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Icon(icon, color: Colors.white, size: 28),
        ),
      ),
    );
  }
}

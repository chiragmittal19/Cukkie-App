import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/services/sensory_service.dart';
import '../../../../core/services/tts_service.dart';
import '../../../../data/models/dish_detail_model.dart';
import '../view_models/recipe_view_model.dart';
import '../../home/view_models/home_view_model.dart';
import '../../settings/view_models/settings_view_model.dart';
import 'widgets/cooking_step_item.dart';
import 'widgets/dynamic_feedback_step.dart';
import 'widgets/ingredients_checklist_step.dart';
import 'widgets/portion_selector_step.dart';
import 'widgets/sticky_step_bar.dart';

class RecipeDetailView extends StatefulWidget {
  const RecipeDetailView({
    super.key,
    required this.dishId,
    this.initialStepIndex,
  });

  final String dishId;
  final int? initialStepIndex;

  @override
  State<RecipeDetailView> createState() => _RecipeDetailViewState();
}

class _RecipeDetailViewState extends State<RecipeDetailView> with WidgetsBindingObserver {
  late final TtsService _ttsService;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _ttsService = context.read<TtsService>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RecipeViewModel>().loadRecipe(
            widget.dishId,
            initialStepIndex: widget.initialStepIndex,
          );
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive ||
        state == AppLifecycleState.hidden) {
      _ttsService.stop();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _ttsService.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final recipeVm = context.watch<RecipeViewModel>();
    final strings = context.watch<SettingsViewModel>().strings;
    final dish = recipeVm.dish;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (recipeVm.isLoading || dish == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(
          child: CircularProgressIndicator(color: AppColors.saffronPrimary),
        ),
      );
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        // Requirement 6: Clicking system back button takes user to previous step.
        // If there is no previous step (step 0), take user back to home page.
        if (recipeVm.currentStepIndex > 0) {
          recipeVm.prevStep();
        } else {
          _ttsService.stop();
          context.go('/home');
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leadingWidth: 84,
          leading: TextButton.icon(
            key: const ValueKey('recipe_exit_button'),
            onPressed: () {
              SensoryService.instance.lightTap();
              _ttsService.stop();
              // Requirement 7: Exit button takes user back to home page, irrespective of current step
              context.go('/home');
            },
            icon: const Icon(Icons.close_rounded, size: 18, color: AppColors.saffronPrimary),
            label: Text(
              strings.exit,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.saffronPrimary,
              ),
            ),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 8),
            ),
          ),
          title: Text(
            dish.name,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.share_outlined, color: AppColors.saffronPrimary),
              tooltip: strings.share,
              onPressed: () {
                SensoryService.instance.lightTap();
                recipeVm.shareRecipe();
              },
            ),
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              // Sticky Bar at Top with clickable Step Headings
              StickyStepBar(
                dish: dish,
                recipeVm: recipeVm,
                currentStepIndex: recipeVm.currentStepIndex,
              ),

              // Active Step Content
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  transitionBuilder: (child, animation) =>
                      FadeTransition(opacity: animation, child: child),
                  child: KeyedSubtree(
                    key: ValueKey<int>(recipeVm.currentStepIndex),
                    child: _buildCurrentStepWidget(context, dish, recipeVm, isDark, strings),
                  ),
                ),
              ),

              // Persistent Bottom Navigation Controls (Previous / Next)
              _buildBottomControls(context, recipeVm, isDark, strings),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentStepWidget(
    BuildContext context,
    DishDetailModel dish,
    RecipeViewModel recipeVm,
    bool isDark,
    dynamic strings,
  ) {
    final stepIndex = recipeVm.currentStepIndex;

    // Step 0: Overview (Lore, History, Nutritional Facts)
    if (stepIndex == 0) {
      return _buildOverviewStep(context, dish, isDark, strings);
    }

    // Step 1: Portion Size Selector
    if (stepIndex == 1) {
      return PortionSelectorStep(dish: dish, recipeVm: recipeVm);
    }

    // Step 2: Ingredients Checklist
    if (stepIndex == 2) {
      return IngredientsChecklistStep(dish: dish, recipeVm: recipeVm);
    }

    // Final Step: Tasting & Feedback
    if (recipeVm.isLastStep) {
      return DynamicFeedbackStep(
        dish: dish,
        recipeVm: recipeVm,
        onFinishCompleted: () => _handleRecipeFinished(context, strings),
      );
    }

    // Middle Steps (Steps 3..N-1): Cooking Steps
    final stepItem = recipeVm.currentStep;
    if (stepItem != null) {
      return CookingStepItem(step: stepItem, recipeVm: recipeVm);
    }

    return const SizedBox.shrink();
  }

  Widget _buildOverviewStep(
    BuildContext context,
    DishDetailModel dish,
    bool isDark,
    dynamic strings,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hero Dish Banner
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Hero(
              tag: 'dish_hero_${dish.id}',
              child: CachedNetworkImage(
                imageUrl: dish.imageUrl,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  height: 200,
                  color: isDark ? AppColors.surfaceDark : AppColors.backgroundLight,
                  child: const Center(
                    child: CircularProgressIndicator(color: AppColors.saffronPrimary),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  height: 200,
                  color: isDark ? AppColors.surfaceDark : AppColors.backgroundLight,
                  child: const Icon(Icons.restaurant_menu, size: 48, color: AppColors.saffronPrimary),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Dish Description
          Text(
            strings.aboutThisDish,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            dish.description,
            style: TextStyle(
              fontSize: 14,
              height: 1.5,
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
            ),
          ),
          const SizedBox(height: 20),

          // Culinary Lore & History
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.saffronPrimary.withAlpha(isDark ? 25 : 15),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.saffronPrimary.withAlpha(60),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.history_edu_rounded, color: AppColors.saffronPrimary, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      strings.culinaryHeritage,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.saffronPrimary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  dish.history,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.4),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Nutritional Breakdown
          Text(
            strings.nutritionalProfile,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: dish.nutritionalBreakdown.entries.map((entry) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.surfaceDark : Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isDark ? AppColors.borderDark : AppColors.borderLight,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.key,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 11),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      entry.value.toString(),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.saffronPrimary,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildBottomControls(
    BuildContext context,
    RecipeViewModel recipeVm,
    bool isDark,
    dynamic strings,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        border: Border(
          top: BorderSide(
            color: isDark ? AppColors.borderDark : AppColors.borderLight,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // Previous button
          if (!recipeVm.isFirstStep)
            Expanded(
              child: OutlinedButton(
                key: const ValueKey('recipe_prev_button'),
                onPressed: () {
                  SensoryService.instance.lightTap();
                  recipeVm.prevStep();
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.saffronPrimary),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.arrow_back_rounded, size: 18, color: AppColors.saffronPrimary),
                    const SizedBox(width: 6),
                    Text(
                      strings.previous,
                      style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.saffronPrimary),
                    ),
                  ],
                ),
              ),
            ),

          if (!recipeVm.isFirstStep) const SizedBox(width: 14),

          // Next button (or hidden on final feedback step where submit button handles completion)
          if (!recipeVm.isLastStep)
            Expanded(
              child: ElevatedButton(
                key: const ValueKey('recipe_next_button'),
                onPressed: () {
                  SensoryService.instance.lightTap();
                  recipeVm.nextStep();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.saffronPrimary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  elevation: 0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      strings.next,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(width: 6),
                    const Icon(Icons.arrow_forward_rounded, size: 18),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _handleRecipeFinished(BuildContext context, dynamic strings) {
    _ttsService.stop();
    // Refresh unfinished recipes and home data
    context.read<HomeViewModel>().loadUnfinishedRecipes();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(Icons.celebration_rounded, color: AppColors.saffronPrimary, size: 28),
            const SizedBox(width: 10),
            Text(strings.bonAppetit),
          ],
        ),
        content: Text(
          strings.recipeCompleteMessage,
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              context.go('/home');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.saffronPrimary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text(strings.returnToHome),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/services/sensory_service.dart';
import '../../../../../core/services/tts_service.dart';
import '../../../../../data/models/dish_detail_model.dart';
import '../../../settings/view_models/settings_view_model.dart';
import '../../view_models/recipe_view_model.dart';

class CookingStepItem extends StatelessWidget {
  const CookingStepItem({
    super.key,
    required this.step,
    required this.recipeVm,
  });

  final RecipeStepItem step;
  final RecipeViewModel recipeVm;

  @override
  Widget build(BuildContext context) {
    final ttsService = context.watch<TtsService>();
    final strings = context.watch<SettingsViewModel>().strings;
    final isSpeaking = ttsService.isPlaying;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Condition per user requirement: Checkboxes only shown if todos.length > 1
    final showCheckboxes = step.todos.length > 1;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Step Heading and Audio Speaker Button
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      step.heading,
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 22),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      strings.stepProgress(step.index + 1, recipeVm.dish?.steps.length ?? 0),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.saffronPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              // Speaker button to read step in audio
              Material(
                color: isSpeaking
                    ? AppColors.saffronPrimary
                    : AppColors.saffronPrimary.withAlpha(isDark ? 35 : 20),
                shape: const CircleBorder(),
                child: InkWell(
                  key: const ValueKey('recipe_speaker_button'),
                  customBorder: const CircleBorder(),
                  onTap: () {
                    SensoryService.instance.lightTap();
                    recipeVm.toggleStepAudio();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Icon(
                      isSpeaking ? Icons.volume_up_rounded : Icons.volume_up_outlined,
                      color: isSpeaking ? Colors.white : AppColors.saffronPrimary,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Main instruction text
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: isDark ? AppColors.surfaceDark : Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: isDark ? AppColors.borderDark : AppColors.borderLight,
                width: 1,
              ),
            ),
            child: Text(
              step.instructionText,
              style: TextStyle(
                fontSize: 15,
                height: 1.5,
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Action Checklist (Only if todos.length > 1)
          if (showCheckboxes) ...[
            Text(
              strings.actionChecklist,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: step.todos.length,
              separatorBuilder: (_, index) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final todoText = step.todos[index];
                final isChecked = recipeVm.isTodoChecked(step.index, index);

                return InkWell(
                  onTap: () {
                    SensoryService.instance.mediumImpact();
                    recipeVm.toggleTodo(step.index, index);
                  },
                  borderRadius: BorderRadius.circular(14),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: isChecked
                          ? AppColors.saffronPrimary.withAlpha(isDark ? 25 : 15)
                          : isDark
                              ? AppColors.cardDark
                              : Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isChecked
                            ? AppColors.saffronPrimary
                            : isDark
                                ? AppColors.borderDark
                                : AppColors.borderLight,
                        width: isChecked ? 1.5 : 1,
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          isChecked
                              ? Icons.check_circle_rounded
                              : Icons.radio_button_unchecked_rounded,
                          color: isChecked
                              ? AppColors.saffronPrimary
                              : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
                          size: 22,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            todoText,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              height: 1.3,
                              decoration: isChecked ? TextDecoration.lineThrough : null,
                              color: isChecked
                                  ? (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight)
                                  : null,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ] else if (step.todos.isNotEmpty) ...[
            // Single todo rendered as clean tip without checkbox per user rule
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.saffronPrimary.withAlpha(15),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline_rounded, color: AppColors.saffronPrimary, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      step.todos.first,
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/services/sensory_service.dart';
import '../../../../../data/models/unfinished_recipe_model.dart';
import '../../../settings/view_models/settings_view_model.dart';
import '../../view_models/home_view_model.dart';

class UnfinishedRecipesDock extends StatelessWidget {
  const UnfinishedRecipesDock({
    super.key,
    required this.unfinishedRecipes,
    required this.homeVm,
  });

  final List<UnfinishedRecipeModel> unfinishedRecipes;
  final HomeViewModel homeVm;

  @override
  Widget build(BuildContext context) {
    if (unfinishedRecipes.isEmpty) return const SizedBox.shrink();

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final strings = context.watch<SettingsViewModel>().strings;

    return Container(
      height: 72,
      margin: const EdgeInsets.only(bottom: 8),
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: unfinishedRecipes.length,
        separatorBuilder: (_, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final item = unfinishedRecipes[index];
          return _buildFloatingSnackbar(context, item, isDark, strings);
        },
      ),
    );
  }

  Widget _buildFloatingSnackbar(
    BuildContext context,
    UnfinishedRecipeModel item,
    bool isDark,
    dynamic strings,
  ) {
    return Container(
      width: 280,
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.saffronPrimary.withAlpha(isDark ? 80 : 50),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(isDark ? 50 : 20),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          key: ValueKey('dock_resume_${item.dishId}'),
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            SensoryService.instance.lightTap();
            // Resume directly into saved step!
            context.push('/recipe/${item.dishId}?step=${item.stepIndex}');
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Row(
              children: [
                // Dish thumbnail
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                    imageUrl: item.dishImage,
                    width: 48,
                    height: 48,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      width: 48,
                      height: 48,
                      color: AppColors.saffronPrimary.withAlpha(30),
                      child: const Icon(Icons.restaurant, size: 20, color: AppColors.saffronPrimary),
                    ),
                    errorWidget: (context, url, error) => Container(
                      width: 48,
                      height: 48,
                      color: AppColors.saffronPrimary.withAlpha(30),
                      child: const Icon(Icons.restaurant, size: 20, color: AppColors.saffronPrimary),
                    ),
                  ),
                ),
                const SizedBox(width: 10),

                // Dish Name and Step Heading
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        item.dishName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          const Icon(
                            Icons.play_circle_filled_rounded,
                            size: 13,
                            color: AppColors.saffronPrimary,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              strings.resumeAt(item.stepHeading),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: isDark ? AppColors.saffronLight : AppColors.saffronPrimary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Cross / dismiss icon
                IconButton(
                  key: ValueKey('dock_dismiss_${item.dishId}'),
                  icon: const Icon(Icons.close_rounded, size: 18),
                  splashRadius: 18,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                  tooltip: strings.dismiss,
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                  onPressed: () async {
                    await SensoryService.instance.lightTap();
                    await homeVm.removeUnfinishedRecipe(item.dishId);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

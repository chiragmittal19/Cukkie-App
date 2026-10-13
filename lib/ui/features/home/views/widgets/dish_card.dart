import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/services/sensory_service.dart';
import '../../../../../data/models/dish_summary_model.dart';
import '../../../auth/view_models/auth_view_model.dart';
import '../../../settings/view_models/settings_view_model.dart';
import '../../view_models/home_view_model.dart';

class DishCard extends StatelessWidget {
  const DishCard({
    super.key,
    required this.dish,
  });

  final DishSummaryModel dish;

  @override
  Widget build(BuildContext context) {
    final homeVm = context.read<HomeViewModel>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      key: ValueKey('dish_card_${dish.id}'),
      onTap: () async {
        SensoryService.instance.lightTap();
        await context.push('/recipe/${dish.id}');
        if (context.mounted) {
          context.read<HomeViewModel>().loadUnfinishedRecipes();
        }
      },
      borderRadius: BorderRadius.circular(18),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isDark ? AppColors.borderDark : AppColors.borderLight,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(isDark ? 30 : 10),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Dish Image with Floating Favorite Heart and Dietary Badge
            Stack(
              children: [
                Hero(
                  tag: 'dish_hero_${dish.id}',
                  child: CachedNetworkImage(
                    imageUrl: dish.imageUrl,
                    height: 165,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      height: 165,
                      color: isDark ? AppColors.surfaceDark : AppColors.backgroundLight,
                      child: const Center(
                        child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.saffronPrimary),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      height: 165,
                      color: isDark ? AppColors.surfaceDark : AppColors.backgroundLight,
                      child: const Icon(Icons.restaurant_menu, size: 40, color: AppColors.saffronPrimary),
                    ),
                  ),
                ),
                // Dietary tag badge
                Positioned(
                  top: 10,
                  left: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withAlpha(160),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: dish.dietaryType.toLowerCase() == 'vegetarian' ||
                                    dish.dietaryType.toLowerCase() == 'vegan' ||
                                    dish.dietaryType.toLowerCase() == 'jain'
                                ? AppColors.basilGreen
                                : AppColors.chiliRed,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          dish.dietaryType,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Favorite Heart Toggle Button (Guarded by Login)
                Positioned(
                  top: 10,
                  right: 10,
                  child: Material(
                    color: Colors.black.withAlpha(140),
                    shape: const CircleBorder(),
                    child: InkWell(
                      key: ValueKey('dish_fav_${dish.id}'),
                      customBorder: const CircleBorder(),
                      onTap: () => _handleFavoriteTap(context, homeVm),
                      child: Padding(
                        padding: const EdgeInsets.all(7),
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 250),
                          transitionBuilder: (child, animation) =>
                              ScaleTransition(scale: animation, child: child),
                          child: Icon(
                            dish.isFavourite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                            key: ValueKey<bool>(dish.isFavourite),
                            size: 20,
                            color: dish.isFavourite ? AppColors.chiliRed : Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Taste profiles badges
                  Wrap(
                    spacing: 4,
                    runSpacing: 4,
                    children: dish.tasteProfiles.map((t) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.saffronPrimary.withAlpha(isDark ? 35 : 20),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          t,
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: AppColors.saffronPrimary,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 6),

                  // Dish Name
                  Text(
                    dish.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 6),

                  // Nutritional & Time Metrics
                  Row(
                    children: [
                      const Icon(Icons.timer_outlined, size: 14, color: AppColors.saffronPrimary),
                      const SizedBox(width: 4),
                      Text(
                        '${dish.prepTimeMinutes}m',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 12),
                      ),
                      const Spacer(),
                      const Icon(Icons.local_fire_department_outlined, size: 14, color: AppColors.chiliRed),
                      const SizedBox(width: 3),
                      Text(
                        '${dish.caloriesKcal} kcal',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 12),
                      ),
                      const Spacer(),
                      const Icon(Icons.fitness_center_rounded, size: 13, color: AppColors.basilGreen),
                      const SizedBox(width: 3),
                      Text(
                        '${dish.proteinGrams}g pro',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleFavoriteTap(BuildContext context, HomeViewModel homeVm) async {
    SensoryService.instance.lightTap();
    final authVm = context.read<AuthViewModel>();

    final success = await homeVm.toggleFavourite(dish.id);
    if (!success && !authVm.isLoggedIn && context.mounted) {
      // User is not logged in: Set pending action and redirect to login!
      authVm.setPendingAction(PendingAction(
        type: PendingActionType.toggleFavourite,
        targetId: dish.id,
      ));

      final strings = context.read<SettingsViewModel>().strings;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(strings.loginRequiredForFavourite),
          duration: const Duration(seconds: 2),
        ),
      );

      context.push('/login');
    }
  }
}

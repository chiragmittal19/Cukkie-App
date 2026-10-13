import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/services/sensory_service.dart';
import '../../../../../data/models/dish_detail_model.dart';
import '../../view_models/recipe_view_model.dart';

class StickyStepBar extends StatefulWidget {
  const StickyStepBar({
    super.key,
    required this.dish,
    required this.recipeVm,
    required this.currentStepIndex,
  });

  final DishDetailModel dish;
  final RecipeViewModel recipeVm;
  final int currentStepIndex;

  @override
  State<StickyStepBar> createState() => _StickyStepBarState();
}

class _StickyStepBarState extends State<StickyStepBar> {
  final ScrollController _scrollController = ScrollController();
  late List<GlobalKey> _stepKeys;
  int _lastScrolledIndex = -1;

  @override
  void initState() {
    super.initState();
    _stepKeys = List.generate(widget.dish.steps.length, (_) => GlobalKey());
    _lastScrolledIndex = widget.currentStepIndex;
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToSelectedStep());
  }

  @override
  void didUpdateWidget(covariant StickyStepBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_stepKeys.length != widget.dish.steps.length) {
      _stepKeys = List.generate(widget.dish.steps.length, (_) => GlobalKey());
    }
    if (oldWidget.currentStepIndex != widget.currentStepIndex ||
        _lastScrolledIndex != widget.currentStepIndex) {
      _lastScrolledIndex = widget.currentStepIndex;
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToSelectedStep());
    }
  }

  void _scrollToSelectedStep() {
    final idx = widget.currentStepIndex;
    if (idx < 0 || idx >= _stepKeys.length) return;
    if (!_scrollController.hasClients) return;

    final ctx = _stepKeys[idx].currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(
        ctx,
        alignment: 0.5,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOutCubic,
      );
    } else {
      // Fallback: estimate centered scroll offset
      final viewport = _scrollController.position.viewportDimension;
      final target = (idx * 148.0) - (viewport / 2) + 74.0;
      final clamped = target.clamp(0.0, _scrollController.position.maxScrollExtent);
      _scrollController.animateTo(
        clamped,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        border: Border(
          bottom: BorderSide(
            color: isDark ? AppColors.borderDark : AppColors.borderLight,
            width: 1,
          ),
        ),
      ),
      child: ListView.separated(
        controller: _scrollController,
        scrollCacheExtent: const ScrollCacheExtent.viewport(4.0),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: widget.dish.steps.length,
        separatorBuilder: (_, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final step = widget.dish.steps[index];
          final isCurrent = index == widget.recipeVm.currentStepIndex;
          final isCompleted = index < widget.recipeVm.currentStepIndex;

          return Center(
            key: _stepKeys[index],
            child: InkWell(
              key: ValueKey('step_chip_$index'),
              onTap: () {
                SensoryService.instance.selectionClick();
                widget.recipeVm.setStepIndex(index);
              },
              borderRadius: BorderRadius.circular(20),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: isCurrent
                      ? AppColors.saffronPrimary
                      : isCompleted
                          ? AppColors.saffronPrimary.withAlpha(25)
                          : isDark
                              ? AppColors.cardDark
                              : AppColors.backgroundLight,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isCurrent
                        ? AppColors.saffronPrimary
                        : isCompleted
                            ? AppColors.saffronPrimary.withAlpha(80)
                            : isDark
                                ? AppColors.borderDark
                                : AppColors.borderLight,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isCompleted) ...[
                      const Icon(
                        Icons.check_circle_rounded,
                        size: 14,
                        color: AppColors.saffronPrimary,
                      ),
                      const SizedBox(width: 5),
                    ],
                    Text(
                      '${index + 1}. ${step.heading}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: isCurrent ? FontWeight.w800 : FontWeight.w600,
                        color: isCurrent
                            ? Colors.white
                            : isCompleted
                                ? AppColors.saffronPrimary
                                : isDark
                                    ? AppColors.textPrimaryDark
                                    : AppColors.textSecondaryLight,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

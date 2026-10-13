import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/services/sensory_service.dart';
import '../../settings/view_models/settings_view_model.dart';
import '../view_models/home_view_model.dart';
import 'widgets/app_drawer.dart';
import 'widgets/dish_card.dart';
import 'widgets/filter_bottom_sheet.dart';
import 'widgets/unfinished_recipes_dock.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeViewModel>().init();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final homeVm = context.watch<HomeViewModel>();
    final strings = context.watch<SettingsViewModel>().strings;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final hasQuickFilters = homeVm.homePayload != null &&
        homeVm.homePayload!.filterGroups.isNotEmpty;
    final headerHeight = hasQuickFilters ? 164.0 : 116.0;

    return Scaffold(
      drawer: const AppDrawer(),
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            RefreshIndicator(
              color: AppColors.saffronPrimary,
              onRefresh: () async {
                await homeVm.loadHomePageData();
                await homeVm.loadUnfinishedRecipes();
              },
              child: CustomScrollView(
                slivers: [
                  // Requirement 9: Search bar and filters are NOT sticky.
                  // They scroll out when scrolled up, but snap back immediately on scrolling down a little.
                  SliverAppBar(
                    floating: true,
                    snap: true,
                    pinned: false,
                    elevation: 0,
                    scrolledUnderElevation: 2,
                    automaticallyImplyLeading: false,
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    toolbarHeight: headerHeight,
                    titleSpacing: 0,
                    title: SizedBox(
                      height: headerHeight,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // 1. Top App Bar with Hamburger, Logo & Filter action
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 6, 16, 4),
                            child: Row(
                              children: [
                                Builder(
                                  builder: (scaffoldContext) => IconButton(
                                    key: const ValueKey('home_drawer_button'),
                                    icon: const Icon(Icons.menu_rounded, size: 26),
                                    tooltip: 'Menu',
                                    onPressed: () {
                                      SensoryService.instance.lightTap();
                                      Scaffold.of(scaffoldContext).openDrawer();
                                    },
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Cukkie',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: -0.5,
                                    color: isDark ? AppColors.saffronLight : AppColors.saffronPrimary,
                                  ),
                                ),
                                const Spacer(),
                                // Filter Bottom Sheet Button with Badge
                                Stack(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.tune_rounded, size: 22),
                                      tooltip: 'Filters',
                                      onPressed: () => _openFilters(context, homeVm),
                                    ),
                                    if (homeVm.totalActiveFilterCount > 0)
                                      Positioned(
                                        right: 8,
                                        top: 8,
                                        child: Container(
                                          padding: const EdgeInsets.all(4),
                                          decoration: const BoxDecoration(
                                            color: AppColors.saffronPrimary,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Text(
                                            '${homeVm.totalActiveFilterCount}',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          // 2. Search Bar
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                            child: SizedBox(
                              height: 46,
                              child: TextField(
                                controller: _searchController,
                                onChanged: homeVm.onSearchChanged,
                                decoration: InputDecoration(
                                  hintText: homeVm.homePayload?.searchBarHint ?? strings.searchHint,
                                  hintStyle: TextStyle(
                                    fontSize: 13,
                                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                                  ),
                                  prefixIcon: const Icon(Icons.search_rounded, size: 22, color: AppColors.saffronPrimary),
                                  suffixIcon: _searchController.text.isNotEmpty
                                      ? IconButton(
                                          icon: const Icon(Icons.clear_rounded, size: 18),
                                          onPressed: () {
                                            _searchController.clear();
                                            homeVm.onSearchChanged('');
                                          },
                                        )
                                      : null,
                                  filled: true,
                                  fillColor: Theme.of(context).cardTheme.color,
                                  contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: BorderSide(
                                      color: isDark ? AppColors.borderDark : AppColors.borderLight,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: BorderSide(
                                      color: isDark ? AppColors.borderDark : AppColors.borderLight,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: const BorderSide(color: AppColors.saffronPrimary, width: 1.5),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          // 3. Quick Filter Chips Bar
                          if (hasQuickFilters) ...[
                            const SizedBox(height: 2),
                            _buildQuickFilterBar(context, homeVm),
                          ],
                        ],
                      ),
                    ),
                  ),

                  // Feed Content: Loading, Empty, or Responsive Dish Grid
                  if (homeVm.isLoading && homeVm.dishes.isEmpty)
                    const SliverFillRemaining(
                      child: Center(
                        child: CircularProgressIndicator(color: AppColors.saffronPrimary),
                      ),
                    )
                  else if (homeVm.dishes.isEmpty)
                    SliverFillRemaining(
                      child: _buildEmptyState(context, homeVm, strings),
                    )
                  else
                    SliverPadding(
                      padding: EdgeInsets.fromLTRB(
                        16,
                        10,
                        16,
                        homeVm.unfinishedRecipes.isNotEmpty ? 92 : 24,
                      ),
                      sliver: _buildSliverDishGrid(context, homeVm),
                    ),
                ],
              ),
            ),

            // Floating Unfinished Recipes Snackbars Dock at the bottom
            if (homeVm.unfinishedRecipes.isNotEmpty)
              Positioned(
                left: 0,
                right: 0,
                bottom: MediaQuery.of(context).padding.bottom + 8,
                child: UnfinishedRecipesDock(
                  unfinishedRecipes: homeVm.unfinishedRecipes,
                  homeVm: homeVm,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickFilterBar(BuildContext context, HomeViewModel homeVm) {
    final cuisineGroup = homeVm.homePayload!.filterGroups.firstWhere(
      (g) => g.id == 'cuisines',
      orElse: () => homeVm.homePayload!.filterGroups.first,
    );
    final selectedCuisines = homeVm.selectedFilters[cuisineGroup.id] ?? [];

    return SizedBox(
      height: 38,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: cuisineGroup.options.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final option = cuisineGroup.options[index];
          final isSelected = selectedCuisines.contains(option.id);

          return FilterChip(
            label: Text(option.label),
            selected: isSelected,
            onSelected: (_) {
              SensoryService.instance.lightTap();
              homeVm.toggleFilter(cuisineGroup.id, option.id);
            },
            selectedColor: AppColors.saffronPrimary.withAlpha(35),
            checkmarkColor: AppColors.saffronPrimary,
            labelStyle: TextStyle(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: isSelected ? AppColors.saffronPrimary : null,
            ),
          );
        },
      ),
    );
  }

  Widget _buildSliverDishGrid(BuildContext context, HomeViewModel homeVm) {
    return SliverLayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount = 1;
        double childAspectRatio = 1.15;

        final width = constraints.crossAxisExtent;
        if (width > 900) {
          crossAxisCount = 4;
          childAspectRatio = 0.82;
        } else if (width > 650) {
          crossAxisCount = 3;
          childAspectRatio = 0.85;
        } else if (width > 420) {
          crossAxisCount = 2;
          childAspectRatio = 0.82;
        } else {
          crossAxisCount = 1;
          childAspectRatio = 1.30;
        }

        return SliverGrid(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: childAspectRatio,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
          ),
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final dish = homeVm.dishes[index];
              return DishCard(dish: dish);
            },
            childCount: homeVm.dishes.length,
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context, HomeViewModel homeVm, dynamic strings) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.search_off_rounded, size: 64, color: AppColors.saffronPrimary),
            const SizedBox(height: 16),
            Text(
              strings.noDishesFound,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              strings.noDishesSubtitle,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                SensoryService.instance.lightTap();
                _searchController.clear();
                homeVm.onSearchChanged('');
                homeVm.clearAllFilters();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.saffronPrimary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(strings.resetAllFilters),
            ),
          ],
        ),
      ),
    );
  }

  void _openFilters(BuildContext context, HomeViewModel homeVm) {
    SensoryService.instance.lightTap();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => FractionallySizedBox(
        heightFactor: 0.75,
        child: FilterBottomSheet(homeVm: homeVm),
      ),
    );
  }
}

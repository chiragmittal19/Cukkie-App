import '../api/recipe_service.dart';
import '../../models/dish_detail_model.dart';
import '../../models/dish_summary_model.dart';
import '../../models/drawer_payload_model.dart';
import '../../models/home_payload_model.dart';
import '../local/secure_prefs_service.dart';
import 'mock_recipe_data.dart';

class MockRecipeService implements RecipeService {
  MockRecipeService({SecurePrefsService? prefsService})
      : _prefsService = prefsService ?? SecurePrefsService.instance;

  final SecurePrefsService _prefsService;

  // Track favorited dish IDs in memory for the mock session
  final Set<String> _favouriteDishIds = {'dish_pbm', 'dish_halwa'};

  @override
  Future<HomePayloadModel> getHomePageData({
    int page = 1,
    String? searchQuery,
    Map<String, List<String>>? selectedFilters,
    String? sortById,
  }) async {
    await Future.delayed(const Duration(milliseconds: 350));
    final lang = _prefsService.getLanguageCode();

    final allDishes = MockRecipeData.getDishes(lang);
    var list = List<DishSummaryModel>.from(allDishes.map((dish) {
      return dish.copyWith(isFavourite: _favouriteDishIds.contains(dish.id));
    }));

    // Apply Search Query filter
    if (searchQuery != null && searchQuery.trim().isNotEmpty) {
      final q = searchQuery.toLowerCase().trim();
      // Search matches against current localized fields AND canonical English equivalents
      list = list.where((d) {
        final matchesLocalized = d.name.toLowerCase().contains(q) ||
            d.cuisine.toLowerCase().contains(q) ||
            d.dietaryType.toLowerCase().contains(q) ||
            d.tasteProfiles.any((t) => t.toLowerCase().contains(q));

        final canonicalCuisine = MockRecipeData.canonicalCuisines[d.id] ?? '';
        final canonicalDiet = MockRecipeData.canonicalDietary[d.id] ?? '';
        final canonicalTastes = MockRecipeData.canonicalTastes[d.id] ?? [];

        final matchesCanonical = canonicalCuisine.toLowerCase().contains(q) ||
            canonicalDiet.toLowerCase().contains(q) ||
            canonicalTastes.any((t) => t.toLowerCase().contains(q));

        return matchesLocalized || matchesCanonical;
      }).toList();
    }

    // Apply Generic Filter Groups if provided
    if (selectedFilters != null && selectedFilters.isNotEmpty) {
      // Cuisines filter (options match canonical IDs like 'North Indian')
      final selectedCuisines = selectedFilters['cuisines'] ?? [];
      if (selectedCuisines.isNotEmpty) {
        list = list.where((d) {
          final canonical = MockRecipeData.canonicalCuisines[d.id];
          return selectedCuisines.any((c) =>
              (canonical != null && canonical.toLowerCase() == c.toLowerCase()) ||
              d.cuisine.toLowerCase() == c.toLowerCase());
        }).toList();
      }

      // Dietary filter (options match canonical IDs like 'Vegetarian')
      final selectedDietary = selectedFilters['dietary'] ?? [];
      if (selectedDietary.isNotEmpty) {
        list = list.where((d) {
          final canonical = MockRecipeData.canonicalDietary[d.id];
          return selectedDietary.any((diet) =>
              (canonical != null && canonical.toLowerCase() == diet.toLowerCase()) ||
              d.dietaryType.toLowerCase() == diet.toLowerCase());
        }).toList();
      }

      // Taste Profiles filter
      final selectedTastes = selectedFilters['taste'] ?? [];
      if (selectedTastes.isNotEmpty) {
        list = list.where((d) {
          final canonicalList = MockRecipeData.canonicalTastes[d.id] ?? [];
          return d.tasteProfiles.any((t) => selectedTastes.any((st) => st.toLowerCase() == t.toLowerCase())) ||
              canonicalList.any((t) => selectedTastes.any((st) => st.toLowerCase() == t.toLowerCase()));
        }).toList();
      }
    }

    // Apply Sorters
    if (sortById != null) {
      switch (sortById) {
        case 'prep_time_asc':
          list.sort((a, b) => a.prepTimeMinutes.compareTo(b.prepTimeMinutes));
          break;
        case 'prep_time_desc':
          list.sort((a, b) => b.prepTimeMinutes.compareTo(a.prepTimeMinutes));
          break;
        case 'calories_asc':
          list.sort((a, b) => a.caloriesKcal.compareTo(b.caloriesKcal));
          break;
        case 'rating_desc':
        default:
          list.sort((a, b) => b.rating.compareTo(a.rating));
      }
    }

    return HomePayloadModel(
      headerTitle: MockRecipeData.getHeaderTitle(lang),
      headerSubtitle: MockRecipeData.getHeaderSubtitle(lang),
      searchBarHint: MockRecipeData.getSearchBarHint(lang),
      filterGroups: MockRecipeData.getFilterGroups(lang),
      sorters: MockRecipeData.getSorters(lang),
      dishes: list,
      totalDishes: list.length,
      currentPage: 1,
      hasMorePages: false,
    );
  }

  @override
  Future<DrawerPayloadModel> getDrawerConfig() async {
    await Future.delayed(const Duration(milliseconds: 150));
    final lang = _prefsService.getLanguageCode();
    final isLoggedIn = _prefsService.isLoggedIn;
    final phoneNumber = _prefsService.getPhoneNumber();

    final items = MockRecipeData.getDrawerItems(lang, isLoggedIn);

    return DrawerPayloadModel(
      isLoggedIn: isLoggedIn,
      phoneNumber: phoneNumber,
      displayName: isLoggedIn ? MockRecipeData.getChefDisplayName(lang) : null,
      avatarUrl: isLoggedIn
          ? 'https://images.unsplash.com/photo-1577219491135-ce391730fb2c?w=150'
          : null,
      items: items,
    );
  }

  @override
  Future<DishDetailModel> getDishDetail(String dishId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final lang = _prefsService.getLanguageCode();
    final dish = MockRecipeData.getDishDetail(dishId, lang);
    return dish.copyWith(isFavourite: _favouriteDishIds.contains(dishId));
  }

  @override
  Future<bool> toggleFavourite(String dishId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    if (_favouriteDishIds.contains(dishId)) {
      _favouriteDishIds.remove(dishId);
      return false;
    } else {
      _favouriteDishIds.add(dishId);
      return true;
    }
  }

  @override
  Future<List<DishSummaryModel>> getFavourites() async {
    await Future.delayed(const Duration(milliseconds: 250));
    final lang = _prefsService.getLanguageCode();
    final allDishes = MockRecipeData.getDishes(lang);
    return allDishes
        .where((d) => _favouriteDishIds.contains(d.id))
        .map((d) => d.copyWith(isFavourite: true))
        .toList();
  }

  @override
  Future<void> submitFeedback(String dishId, Map<String, dynamic> responses) async {
    await Future.delayed(const Duration(milliseconds: 600));
    // Simulation: feedback recorded successfully
  }
}

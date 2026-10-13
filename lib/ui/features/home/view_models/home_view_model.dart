import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../../../data/models/dish_summary_model.dart';
import '../../../../data/models/drawer_payload_model.dart';
import '../../../../data/models/home_payload_model.dart';
import '../../../../data/models/unfinished_recipe_model.dart';
import '../../../../data/services/api/recipe_service.dart';
import '../../../../data/services/local/local_sql_database_service.dart';
import '../../auth/view_models/auth_view_model.dart';
import '../../settings/view_models/settings_view_model.dart';

class HomeViewModel with ChangeNotifier {
  HomeViewModel({
    required this.recipeService,
    required this.authViewModel,
    this.settingsViewModel,
    LocalSqlDatabaseService? localDbService,
  })  : _localDbService = localDbService ?? LocalSqlDatabaseService.instance {
    authViewModel.addListener(_onAuthStatusChanged);
    settingsViewModel?.addListener(_onSettingsChanged);
    _lastLanguageCode = settingsViewModel?.locale.languageCode;
    _dbSubscription = _localDbService.onDatabaseChanged.listen((_) {
      loadUnfinishedRecipes();
    });
  }

  final RecipeService recipeService;
  final AuthViewModel authViewModel;
  final SettingsViewModel? settingsViewModel;
  final LocalSqlDatabaseService _localDbService;
  StreamSubscription? _dbSubscription;
  String? _lastLanguageCode;

  bool _isLoading = false;
  String? _errorMessage;

  HomePayloadModel? _homePayload;
  DrawerPayloadModel? _drawerPayload;
  List<UnfinishedRecipeModel> _unfinishedRecipes = [];

  String _searchQuery = '';
  Timer? _searchDebounceTimer;
  final Map<String, List<String>> _selectedFilters = {};
  String? _activeSortId = 'rating_desc';

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  HomePayloadModel? get homePayload => _homePayload;
  DrawerPayloadModel? get drawerPayload => _drawerPayload;
  List<DishSummaryModel> get dishes => _homePayload?.dishes ?? [];
  List<UnfinishedRecipeModel> get unfinishedRecipes => _unfinishedRecipes;
  String get searchQuery => _searchQuery;
  Map<String, List<String>> get selectedFilters => Map.unmodifiable(_selectedFilters);
  String? get activeSortId => _activeSortId;

  int get totalActiveFilterCount {
    int count = 0;
    for (final list in _selectedFilters.values) {
      count += list.length;
    }
    return count;
  }

  void _onAuthStatusChanged() {
    // Refresh drawer and home data when auth status changes
    loadDrawerConfig();
    loadHomePageData();
  }

  void _onSettingsChanged() {
    final currentLang = settingsViewModel?.locale.languageCode;
    if (currentLang != null && currentLang != _lastLanguageCode) {
      _lastLanguageCode = currentLang;
      loadHomePageData();
      loadDrawerConfig();
    }
  }

  Future<void> init() async {
    await Future.wait([
      loadHomePageData(),
      loadDrawerConfig(),
      loadUnfinishedRecipes(),
    ]);
  }

  Future<void> loadHomePageData() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _homePayload = await recipeService.getHomePageData(
        searchQuery: _searchQuery,
        selectedFilters: _selectedFilters,
        sortById: _activeSortId,
      );
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadDrawerConfig() async {
    try {
      _drawerPayload = await recipeService.getDrawerConfig();
      notifyListeners();
    } catch (_) {}
  }

  Future<void> loadUnfinishedRecipes() async {
    try {
      _unfinishedRecipes = await _localDbService.getUnfinishedRecipes();
      notifyListeners();
    } catch (_) {}
  }

  void onSearchChanged(String query) {
    _searchQuery = query;
    _searchDebounceTimer?.cancel();
    _searchDebounceTimer = Timer(const Duration(milliseconds: 300), () {
      loadHomePageData();
    });
  }

  void toggleFilter(String groupId, String optionId) {
    final currentList = _selectedFilters[groupId] ?? [];
    if (currentList.contains(optionId)) {
      currentList.remove(optionId);
      if (currentList.isEmpty) {
        _selectedFilters.remove(groupId);
      } else {
        _selectedFilters[groupId] = currentList;
      }
    } else {
      _selectedFilters[groupId] = [...currentList, optionId];
    }
    loadHomePageData();
  }

  void clearAllFilters() {
    _selectedFilters.clear();
    loadHomePageData();
  }

  void applyFiltersAndSort({
    required Map<String, List<String>> filters,
    required String? sortId,
  }) {
    _selectedFilters.clear();
    filters.forEach((k, v) {
      if (v.isNotEmpty) {
        _selectedFilters[k] = List<String>.from(v);
      }
    });
    _activeSortId = sortId;
    loadHomePageData();
  }

  void setSortOption(String sortId) {
    if (_activeSortId == sortId) return;
    _activeSortId = sortId;
    loadHomePageData();
  }

  /// Toggles favorite status for a dish.
  /// If user is not logged in, returns false so View can trigger login guard!
  Future<bool> toggleFavourite(String dishId) async {
    if (!authViewModel.isLoggedIn) {
      return false; // Requires login
    }

    try {
      final isFav = await recipeService.toggleFavourite(dishId);
      // Update local state in dishes list
      if (_homePayload != null) {
        final updatedList = _homePayload!.dishes.map((dish) {
          if (dish.id == dishId) {
            return dish.copyWith(isFavourite: isFav);
          }
          return dish;
        }).toList();

        _homePayload = HomePayloadModel(
          headerTitle: _homePayload!.headerTitle,
          headerSubtitle: _homePayload!.headerSubtitle,
          searchBarHint: _homePayload!.searchBarHint,
          filterGroups: _homePayload!.filterGroups,
          sorters: _homePayload!.sorters,
          dishes: updatedList,
          totalDishes: updatedList.length,
          currentPage: _homePayload!.currentPage,
          hasMorePages: _homePayload!.hasMorePages,
        );
        notifyListeners();
      }
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<void> removeUnfinishedRecipe(String dishId) async {
    await _localDbService.removeRecipe(dishId);
    _unfinishedRecipes.removeWhere((item) => item.dishId == dishId);
    notifyListeners();
  }

  @override
  void dispose() {
    _searchDebounceTimer?.cancel();
    _dbSubscription?.cancel();
    authViewModel.removeListener(_onAuthStatusChanged);
    settingsViewModel?.removeListener(_onSettingsChanged);
    super.dispose();
  }
}

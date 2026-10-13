import 'dish_summary_model.dart';

class FilterOption {
  const FilterOption({
    required this.id,
    required this.label,
    this.iconUrl,
  });

  final String id;
  final String label;
  final String? iconUrl;

  factory FilterOption.fromJson(Map<String, dynamic> json) => FilterOption(
    id: json['id'] as String,
    label: json['label'] as String,
    iconUrl: json['iconUrl'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'label': label,
    'iconUrl': iconUrl,
  };
}

class FilterGroup {
  const FilterGroup({
    required this.id,
    required this.title,
    required this.options,
    this.isMultiSelect = true,
  });

  final String id; // e.g. "cuisine", "dietary", "taste", "prep_time"
  final String title; // E.g. "Cuisines", "Dietary Preferences", "Taste Profile"
  final List<FilterOption> options;
  final bool isMultiSelect;

  factory FilterGroup.fromJson(Map<String, dynamic> json) => FilterGroup(
    id: json['id'] as String,
    title: json['title'] as String,
    isMultiSelect: json['isMultiSelect'] as bool? ?? true,
    options: (json['options'] as List<dynamic>?)
            ?.map((e) => FilterOption.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'isMultiSelect': isMultiSelect,
    'options': options.map((e) => e.toJson()).toList(),
  };
}

class SortOption {
  const SortOption({
    required this.id,
    required this.label,
    this.iconUrl,
    this.isDefault = false,
  });

  final String id; // e.g. "prep_time_asc", "ingredient_count_asc", "calories_asc", "rating_desc"
  final String label;
  final String? iconUrl;
  final bool isDefault;

  factory SortOption.fromJson(Map<String, dynamic> json) => SortOption(
    id: json['id'] as String,
    label: json['label'] as String,
    iconUrl: json['iconUrl'] as String?,
    isDefault: json['isDefault'] as bool? ?? false,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'label': label,
    'iconUrl': iconUrl,
    'isDefault': isDefault,
  };
}

class HomePayloadModel {
  const HomePayloadModel({
    required this.headerTitle,
    required this.headerSubtitle,
    required this.searchBarHint,
    required this.filterGroups,
    required this.sorters,
    required this.dishes,
    this.totalDishes = 0,
    this.currentPage = 1,
    this.hasMorePages = false,
  });

  final String headerTitle;
  final String headerSubtitle;
  final String searchBarHint;
  final List<FilterGroup> filterGroups;
  final List<SortOption> sorters;
  final List<DishSummaryModel> dishes;
  final int totalDishes;
  final int currentPage;
  final bool hasMorePages;

  factory HomePayloadModel.fromJson(Map<String, dynamic> json) => HomePayloadModel(
    headerTitle: json['headerTitle'] as String? ?? 'Cukkie Recipes',
    headerSubtitle: json['headerSubtitle'] as String? ?? 'What would you like to cook today?',
    searchBarHint: json['searchBarHint'] as String? ?? 'Search dishes, cuisines, ingredients...',
    filterGroups: (json['filterGroups'] as List<dynamic>?)
            ?.map((e) => FilterGroup.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [],
    sorters: (json['sorters'] as List<dynamic>?)
            ?.map((e) => SortOption.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [],
    dishes: (json['dishes'] as List<dynamic>?)
            ?.map((e) => DishSummaryModel.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [],
    totalDishes: json['totalDishes'] as int? ?? 0,
    currentPage: json['currentPage'] as int? ?? 1,
    hasMorePages: json['hasMorePages'] as bool? ?? false,
  );

  Map<String, dynamic> toJson() => {
    'headerTitle': headerTitle,
    'headerSubtitle': headerSubtitle,
    'searchBarHint': searchBarHint,
    'filterGroups': filterGroups.map((e) => e.toJson()).toList(),
    'sorters': sorters.map((e) => e.toJson()).toList(),
    'dishes': dishes.map((e) => e.toJson()).toList(),
    'totalDishes': totalDishes,
    'currentPage': currentPage,
    'hasMorePages': hasMorePages,
  };
}

import '../api/recipe_service.dart';
import '../../models/dish_detail_model.dart';
import '../../models/dish_summary_model.dart';
import '../../models/drawer_payload_model.dart';
import '../../models/home_payload_model.dart';
import 'api_client.dart';

class HttpRecipeService implements RecipeService {
  HttpRecipeService({ApiClient? client}) : _client = client ?? ApiClient.instance;

  final ApiClient _client;

  String? _formatFiltersParam(Map<String, List<String>>? filters) {
    if (filters == null || filters.isEmpty) return null;
    final parts = <String>[];
    filters.forEach((group, values) {
      if (values.isNotEmpty) {
        parts.add('$group:${values.join(",")}');
      }
    });
    return parts.isEmpty ? null : parts.join(';');
  }

  @override
  Future<HomePayloadModel> getHomePageData({
    int page = 1,
    String? searchQuery,
    Map<String, List<String>>? selectedFilters,
    String? sortById,
  }) async {
    final queryParams = <String, String>{
      'page': page.toString(),
    };

    if (searchQuery != null && searchQuery.trim().isNotEmpty) {
      queryParams['search'] = searchQuery.trim();
    }

    final filtersStr = _formatFiltersParam(selectedFilters);
    if (filtersStr != null && filtersStr.isNotEmpty) {
      queryParams['filters'] = filtersStr;
    }

    if (sortById != null && sortById.isNotEmpty) {
      queryParams['sort_by'] = sortById;
    }

    final baseUri = Uri.parse('${ApiClient.recipeServiceUrl}/api/v1/recipes/home');
    final uri = baseUri.replace(queryParameters: queryParams);

    final res = await _client.get(uri);
    return HomePayloadModel.fromJson(res as Map<String, dynamic>);
  }

  @override
  Future<DrawerPayloadModel> getDrawerConfig() async {
    final uri = Uri.parse('${ApiClient.recipeServiceUrl}/api/v1/recipes/drawer');
    final res = await _client.get(uri);
    return DrawerPayloadModel.fromJson(res as Map<String, dynamic>);
  }

  @override
  Future<DishDetailModel> getDishDetail(String dishId) async {
    final uri = Uri.parse('${ApiClient.recipeServiceUrl}/api/v1/recipes/detail')
        .replace(queryParameters: {'id': dishId});
    final res = await _client.get(uri);
    return DishDetailModel.fromJson(res as Map<String, dynamic>);
  }

  @override
  Future<bool> toggleFavourite(String dishId) async {
    final uri = Uri.parse('${ApiClient.recipeServiceUrl}/api/v1/recipes/favourite')
        .replace(queryParameters: {'id': dishId});
    final res = await _client.post(uri);
    if (res is Map && res['isFavourite'] != null) {
      return res['isFavourite'] as bool;
    }
    return false;
  }

  @override
  Future<List<DishSummaryModel>> getFavourites() async {
    try {
      final uri = Uri.parse('${ApiClient.recipeServiceUrl}/api/v1/recipes/favourites');
      final res = await _client.get(uri);
      if (res is List) {
        return res
            .map((e) => DishSummaryModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
    } catch (_) {}
    return [];
  }

  @override
  Future<void> submitFeedback(String dishId, Map<String, dynamic> responses) async {
    final uri = Uri.parse('${ApiClient.recipeServiceUrl}/api/v1/recipes/feedback')
        .replace(queryParameters: {'id': dishId});
    await _client.post(uri, body: {
      'responses': responses,
    });
  }
}

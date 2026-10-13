import '../../models/dish_detail_model.dart';
import '../../models/dish_summary_model.dart';
import '../../models/drawer_payload_model.dart';
import '../../models/home_payload_model.dart';

abstract class RecipeService {
  /// Fetches the complete Home page payload including filters, sorters, search hints, and dishes
  Future<HomePayloadModel> getHomePageData({
    int page = 1,
    String? searchQuery,
    Map<String, List<String>>? selectedFilters,
    String? sortById,
  });

  /// Fetches pre-configured drawer items and profile header according to auth status
  Future<DrawerPayloadModel> getDrawerConfig();

  /// Fetches full dish detail for cooking page
  Future<DishDetailModel> getDishDetail(String dishId);

  /// Toggles favorite status for a dish
  Future<bool> toggleFavourite(String dishId);

  /// Fetches user's favorited dishes
  Future<List<DishSummaryModel>> getFavourites();

  /// Submits dynamic tasting feedback and marks recipe completed on backend
  Future<void> submitFeedback(String dishId, Map<String, dynamic> responses);
}

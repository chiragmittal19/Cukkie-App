import '../api/content_service.dart';
import '../../models/app_strings_model.dart';
import '../../models/preferences_config_model.dart';
import 'api_client.dart';

class HttpContentService implements ContentService {
  HttpContentService({ApiClient? client}) : _client = client ?? ApiClient.instance;

  final ApiClient _client;

  @override
  Future<AppStringsModel> getAppStrings(String languageCode) async {
    try {
      final uri = Uri.parse('${ApiClient.userServiceUrl}/api/v1/config/strings');
      final res = await _client.get(uri, customLanguage: languageCode);
      if (res is Map) {
        final map = res.map((k, v) => MapEntry(k.toString(), v.toString()));
        return AppStringsModel(map);
      }
    } catch (_) {}
    return AppStringsModel.fallback();
  }

  @override
  Future<PreferencesConfigModel> getPreferencesConfig(String languageCode) async {
    final uri = Uri.parse('${ApiClient.userServiceUrl}/api/v1/config/preferences');
    final res = await _client.get(uri, customLanguage: languageCode);
    return PreferencesConfigModel.fromJson(res as Map<String, dynamic>);
  }
}

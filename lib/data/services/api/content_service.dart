import '../../models/app_strings_model.dart';
import '../../models/preferences_config_model.dart';

abstract class ContentService {
  /// Fetches the complete dictionary of UI strings for the requested language from the backend
  Future<AppStringsModel> getAppStrings(String languageCode);

  /// Fetches backend-driven preferences screen structure, categories, and options
  Future<PreferencesConfigModel> getPreferencesConfig(String languageCode);
}

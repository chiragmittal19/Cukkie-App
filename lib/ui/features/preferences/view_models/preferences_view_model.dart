import 'package:flutter/foundation.dart';
import '../../../../data/models/preferences_config_model.dart';
import '../../../../data/models/user_profile_model.dart';
import '../../../../data/services/api/content_service.dart';
import '../../../../data/services/http/http_content_service.dart';
import '../../auth/view_models/auth_view_model.dart';
import '../../settings/view_models/settings_view_model.dart';

class PreferencesViewModel with ChangeNotifier {
  PreferencesViewModel({
    required this.authViewModel,
    this.settingsViewModel,
    ContentService? contentService,
    String languageCode = 'en',
  }) : _contentService = contentService ?? HttpContentService() {
    initFromAuth();
    settingsViewModel?.addListener(_onSettingsChanged);
    _lastLanguageCode = settingsViewModel?.locale.languageCode ?? languageCode;
    loadBackendConfig(_lastLanguageCode!);
  }

  final AuthViewModel authViewModel;
  final SettingsViewModel? settingsViewModel;
  final ContentService _contentService;
  String? _lastLanguageCode;

  PreferencesConfigModel? _config;
  bool _isLoadingConfig = false;

  PreferencesConfigModel? get config => _config;
  bool get isLoadingConfig => _isLoadingConfig;

  List<String> _selectedCuisines = [];
  List<String> _selectedDietaryChoices = [];
  String _selectedSpiceLevel = 'Medium';
  String _selectedSweetnessLevel = 'Balanced';
  bool _isSaving = false;

  List<String> get selectedCuisines => _selectedCuisines;
  List<String> get selectedDietaryChoices => _selectedDietaryChoices;
  String get selectedSpiceLevel => _selectedSpiceLevel;
  String get selectedSweetnessLevel => _selectedSweetnessLevel;
  bool get isSaving => _isSaving;

  Future<void> loadBackendConfig(String languageCode) async {
    _isLoadingConfig = true;
    notifyListeners();
    try {
      _config = await _contentService.getPreferencesConfig(languageCode);
    } catch (_) {}
    _isLoadingConfig = false;
    notifyListeners();
  }

  void _onSettingsChanged() {
    final currentLang = settingsViewModel?.locale.languageCode;
    if (currentLang != null && currentLang != _lastLanguageCode) {
      _lastLanguageCode = currentLang;
      loadBackendConfig(currentLang);
    }
  }

  @override
  void dispose() {
    settingsViewModel?.removeListener(_onSettingsChanged);
    super.dispose();
  }

  void initFromAuth() {
    final prefs = authViewModel.user.preferences;
    _selectedCuisines = List.from(prefs.cuisines);
    _selectedDietaryChoices = List.from(prefs.dietaryChoices);
    _selectedSpiceLevel = prefs.spiceLevel;
    _selectedSweetnessLevel = prefs.sweetnessLevel;
    notifyListeners();
  }

  void toggleCuisine(String cuisine) {
    if (_selectedCuisines.contains(cuisine)) {
      _selectedCuisines.remove(cuisine);
    } else {
      _selectedCuisines.add(cuisine);
    }
    notifyListeners();
  }

  void toggleDietaryChoice(String choice) {
    if (_selectedDietaryChoices.contains(choice)) {
      _selectedDietaryChoices.remove(choice);
    } else {
      _selectedDietaryChoices.add(choice);
    }
    notifyListeners();
  }

  void setSpiceLevel(String level) {
    _selectedSpiceLevel = level;
    notifyListeners();
  }

  void setSweetnessLevel(String level) {
    _selectedSweetnessLevel = level;
    notifyListeners();
  }

  Future<bool> savePreferences() async {
    _isSaving = true;
    notifyListeners();

    try {
      final updated = UserPreferencesModel(
        cuisines: _selectedCuisines,
        dietaryChoices: _selectedDietaryChoices,
        spiceLevel: _selectedSpiceLevel,
        sweetnessLevel: _selectedSweetnessLevel,
        hasSavedPreferences: true,
      );
      await authViewModel.updatePreferences(updated);
      return true;
    } catch (_) {
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }
}

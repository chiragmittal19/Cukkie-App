import 'package:flutter/material.dart';
import '../../../../data/models/app_strings_model.dart';
import '../../../../data/services/api/content_service.dart';
import '../../../../data/services/http/http_content_service.dart';
import '../../../../data/services/local/secure_prefs_service.dart';
import '../../../../core/services/sensory_service.dart';
import '../../../../core/services/tts_service.dart';

class SettingsViewModel with ChangeNotifier {
  SettingsViewModel({
    SecurePrefsService? prefsService,
    SensoryService? sensoryService,
    ContentService? contentService,
    this.ttsService,
  })  : _prefsService = prefsService ?? SecurePrefsService.instance,
        _sensoryService = sensoryService ?? SensoryService.instance,
        _contentService = contentService ?? HttpContentService() {
    _loadSettings();
  }

  final SecurePrefsService _prefsService;
  final SensoryService _sensoryService;
  final ContentService _contentService;
  final TtsService? ttsService;

  Locale _locale = const Locale('en');
  ThemeMode _themeMode = ThemeMode.system;
  bool _soundEnabled = true;
  bool _hapticsEnabled = true;
  AppStringsModel _strings = AppStringsModel.fallback();

  Locale get locale => _locale;
  ThemeMode get themeMode => _themeMode;
  bool get soundEnabled => _soundEnabled;
  bool get hapticsEnabled => _hapticsEnabled;
  AppStringsModel get strings => _strings;

  bool get isRtl => _locale.languageCode == 'ar';

  Future<void> _loadSettings() async {
    final langCode = _prefsService.getLanguageCode();
    _locale = Locale(langCode);
    _themeMode = _prefsService.getThemeMode();
    _soundEnabled = _prefsService.isSoundEnabled();
    _hapticsEnabled = _prefsService.isHapticsEnabled();
    _sensoryService.updateSettings(haptics: _hapticsEnabled, sound: _soundEnabled);
    ttsService?.setLanguage(langCode);
    _strings = await _contentService.getAppStrings(langCode);
    notifyListeners();
  }

  Future<void> setLanguage(String code) async {
    if (_locale.languageCode == code) return;
    await ttsService?.stop();
    _locale = Locale(code);
    await _prefsService.setLanguageCode(code);
    await ttsService?.setLanguage(code);
    _strings = await _contentService.getAppStrings(code);
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode == mode) return;
    _themeMode = mode;
    await _prefsService.setThemeMode(mode);
    notifyListeners();
  }

  Future<void> toggleSound(bool enabled) async {
    _soundEnabled = enabled;
    await _prefsService.setSoundEnabled(enabled);
    _sensoryService.updateSettings(haptics: _hapticsEnabled, sound: _soundEnabled);
    notifyListeners();
  }

  Future<void> toggleHaptics(bool enabled) async {
    _hapticsEnabled = enabled;
    await _prefsService.setHapticsEnabled(enabled);
    _sensoryService.updateSettings(haptics: _hapticsEnabled, sound: _soundEnabled);
    notifyListeners();
  }
}

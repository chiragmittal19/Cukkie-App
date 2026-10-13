import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SecurePrefsService {
  SecurePrefsService._();
  static final SecurePrefsService instance = SecurePrefsService._();

  static const String _keyToken = 'cukkie_auth_token';
  static const String _keyPhone = 'cukkie_phone_number';
  static const String _keyLanguage = 'cukkie_selected_language';
  static const String _keyThemeMode = 'cukkie_theme_mode';
  static const String _keyFirstLaunch = 'cukkie_is_first_launch_done';
  static const String _keySoundEnabled = 'cukkie_sound_enabled';
  static const String _keyHapticsEnabled = 'cukkie_haptics_enabled';

  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  // Auth Session
  String? getAuthToken() => _prefs?.getString(_keyToken);

  Future<void> saveAuthSession(String token, String phone) async {
    await _prefs?.setString(_keyToken, token);
    await _prefs?.setString(_keyPhone, phone);
  }

  String? getPhoneNumber() => _prefs?.getString(_keyPhone);

  Future<void> clearAuthSession() async {
    await _prefs?.remove(_keyToken);
    await _prefs?.remove(_keyPhone);
  }

  bool get isLoggedIn => getAuthToken() != null && getAuthToken()!.isNotEmpty;

  // Language Setting (stored locally only)
  String getLanguageCode() => _prefs?.getString(_keyLanguage) ?? 'en';

  Future<void> setLanguageCode(String code) async {
    await _prefs?.setString(_keyLanguage, code);
  }

  // Theme Setting (stored locally only)
  ThemeMode getThemeMode() {
    final modeStr = _prefs?.getString(_keyThemeMode);
    if (modeStr == 'light') return ThemeMode.light;
    if (modeStr == 'dark') return ThemeMode.dark;
    return ThemeMode.system;
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    String modeStr = 'system';
    if (mode == ThemeMode.light) modeStr = 'light';
    if (mode == ThemeMode.dark) modeStr = 'dark';
    await _prefs?.setString(_keyThemeMode, modeStr);
  }

  // Onboarding / First Launch
  bool isFirstLaunchDone() => _prefs?.getBool(_keyFirstLaunch) ?? false;

  Future<void> setFirstLaunchDone() async {
    await _prefs?.setBool(_keyFirstLaunch, true);
  }

  // Sound & Haptics
  bool isSoundEnabled() => _prefs?.getBool(_keySoundEnabled) ?? true;
  Future<void> setSoundEnabled(bool enabled) async {
    await _prefs?.setBool(_keySoundEnabled, enabled);
  }

  bool isHapticsEnabled() => _prefs?.getBool(_keyHapticsEnabled) ?? true;
  Future<void> setHapticsEnabled(bool enabled) async {
    await _prefs?.setBool(_keyHapticsEnabled, enabled);
  }
}

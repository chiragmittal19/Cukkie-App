import 'package:flutter/services.dart';

class SensoryService {
  SensoryService._();
  static final SensoryService instance = SensoryService._();

  bool _isHapticsEnabled = true;
  bool _isSoundEnabled = true;

  bool get isHapticsEnabled => _isHapticsEnabled;
  bool get isSoundEnabled => _isSoundEnabled;

  void updateSettings({required bool haptics, required bool sound}) {
    _isHapticsEnabled = haptics;
    _isSoundEnabled = sound;
  }

  /// Light tap for button clicks, chip selections
  Future<void> lightTap() async {
    if (!_isHapticsEnabled) return;
    try {
      await HapticFeedback.lightImpact();
    } catch (_) {}
  }

  /// Medium tap for step completions, checkbox toggles
  Future<void> mediumImpact() async {
    if (!_isHapticsEnabled) return;
    try {
      await HapticFeedback.mediumImpact();
    } catch (_) {}
  }

  /// Heavy impact for completion celebration, submitting feedback
  Future<void> heavyImpact() async {
    if (!_isHapticsEnabled) return;
    try {
      await HapticFeedback.heavyImpact();
    } catch (_) {}
  }

  /// Selection click for sorter / portion size adjustments
  Future<void> selectionClick() async {
    if (!_isHapticsEnabled) return;
    try {
      await HapticFeedback.selectionClick();
    } catch (_) {}
  }
}

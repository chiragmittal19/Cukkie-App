import 'package:flutter/widgets.dart';
import 'package:flutter_tts/flutter_tts.dart';

class TtsService with ChangeNotifier {
  TtsService({FlutterTts? flutterTts})
      : _flutterTts = flutterTts ?? FlutterTts() {
    _initTts();
  }

  final FlutterTts _flutterTts;

  bool _isPlaying = false;
  String? _currentlySpeakingText;
  String _activeLanguageTag = 'en-US';
  String _currentLanguageCode = 'en';

  bool get isPlaying => _isPlaying;
  String? get currentlySpeakingText => _currentlySpeakingText;
  String get activeLanguageTag => _activeLanguageTag;
  String get currentLanguageCode => _currentLanguageCode;

  Future<void> _initTts() async {
    try {
      await _flutterTts.setSpeechRate(0.48); // Slightly calmer culinary cooking pace
      await _flutterTts.setVolume(1.0);
      await _flutterTts.setPitch(1.0);

      _flutterTts.setStartHandler(() {
        _isPlaying = true;
        notifyListeners();
      });

      _flutterTts.setCompletionHandler(() {
        _isPlaying = false;
        _currentlySpeakingText = null;
        notifyListeners();
      });

      _flutterTts.setCancelHandler(() {
        _isPlaying = false;
        _currentlySpeakingText = null;
        notifyListeners();
      });

      _flutterTts.setErrorHandler((msg) {
        debugPrint('FlutterTts synthesis error: $msg');
        _isPlaying = false;
        _currentlySpeakingText = null;
        notifyListeners();
      });
    } catch (_) {}
  }

  Future<void> setLanguage(String languageCode) async {
    try {
      _currentLanguageCode = languageCode;

      // 1. Determine device country from PlatformDispatcher
      final deviceLocale = WidgetsBinding.instance.platformDispatcher.locale;
      final countryCode = deviceLocale.countryCode?.toUpperCase();

      // 2. Build candidate language tags in priority order
      final List<String> candidates = [];
      if (languageCode == 'en') {
        if (countryCode == 'IN') {
          candidates.addAll(['en-IN', 'en_IN', 'en-GB', 'en_GB', 'en-US', 'en_US']);
        } else if (countryCode == 'GB' || countryCode == 'UK') {
          candidates.addAll(['en-GB', 'en_GB', 'en-US', 'en_US', 'en-IN', 'en-IN']);
        } else if (countryCode == 'AU') {
          candidates.addAll(['en-AU', 'en_AU', 'en-GB', 'en_GB', 'en-US', 'en_US']);
        } else if (countryCode == 'CA') {
          candidates.addAll(['en-CA', 'en_CA', 'en-US', 'en_US']);
        } else if (countryCode != null && countryCode.isNotEmpty) {
          candidates.addAll(['en-$countryCode', 'en_${countryCode.toLowerCase()}', 'en-US', 'en-GB']);
        } else {
          candidates.addAll(['en-US', 'en_US', 'en-GB', 'en-IN']);
        }
      } else if (languageCode == 'hi') {
        candidates.addAll(['hi-IN', 'hi_IN', 'hi']);
      } else if (languageCode == 'ar') {
        if (countryCode == 'EG') {
          candidates.addAll(['ar-EG', 'ar_EG', 'ar-SA', 'ar_SA', 'ar']);
        } else if (countryCode == 'AE') {
          candidates.addAll(['ar-AE', 'ar_AE', 'ar-SA', 'ar_SA', 'ar']);
        } else if (countryCode != null && countryCode.isNotEmpty) {
          candidates.addAll(['ar-$countryCode', 'ar_${countryCode.toLowerCase()}', 'ar-SA', 'ar_SA', 'ar']);
        } else {
          candidates.addAll(['ar-SA', 'ar_SA', 'ar-AE', 'ar-EG', 'ar']);
        }
      } else {
        candidates.addAll([languageCode]);
      }

      // 3. Best effort match against installed engine languages
      String selectedTag = candidates.first;
      try {
        final dynamic available = await _flutterTts.getLanguages;
        if (available is List && available.isNotEmpty) {
          final Set<String> normalizedSet = available
              .map((e) => e.toString().toLowerCase().trim())
              .toSet();

          for (final c in candidates) {
            final lower = c.toLowerCase();
            final withHyphen = lower.replaceAll('_', '-');
            final withUnderscore = lower.replaceAll('-', '_');
            if (normalizedSet.contains(lower) ||
                normalizedSet.contains(withHyphen) ||
                normalizedSet.contains(withUnderscore)) {
              selectedTag = c;
              break;
            }
          }
        }
      } catch (_) {}

      _activeLanguageTag = selectedTag;
      await _flutterTts.setLanguage(selectedTag);

      // 4. Voice selection
      try {
        final dynamic voices = await _flutterTts.getVoices;
        if (voices is List && voices.isNotEmpty) {
          final targetPrefix = selectedTag.toLowerCase().replaceAll('_', '-');
          Map<String, String>? chosenVoice;
          for (final v in voices) {
            if (v is Map) {
              final loc = (v['locale'] ?? v['name'] ?? '').toString().toLowerCase().replaceAll('_', '-');
              final name = (v['name'] ?? '').toString().toLowerCase();
              if (loc.startsWith(targetPrefix)) {
                if (name.contains('local') || name.contains('embedded')) {
                  chosenVoice = {
                    'name': v['name']?.toString() ?? '',
                    'locale': v['locale']?.toString() ?? '',
                  };
                  break;
                } else if (chosenVoice == null && !name.contains('network') && !name.contains('server')) {
                  chosenVoice = {
                    'name': v['name']?.toString() ?? '',
                    'locale': v['locale']?.toString() ?? '',
                  };
                }
              }
            }
          }
          if (chosenVoice != null) {
            await _flutterTts.setVoice(chosenVoice);
          }
        }
      } catch (_) {}

      notifyListeners();
    } catch (_) {}
  }

  Future<void> speak(String text) async {
    if (text.trim().isEmpty) return;

    if (_isPlaying && _currentlySpeakingText == text) {
      await stop();
      return;
    }

    // Stop any existing playback first
    await stop();

    _currentlySpeakingText = text;
    _isPlaying = true;
    notifyListeners();

    try {
      final dynamic result = await _flutterTts.speak(text);
      if (result == 0) {
        _isPlaying = false;
        _currentlySpeakingText = null;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Native speak exception: $e');
      _isPlaying = false;
      _currentlySpeakingText = null;
      notifyListeners();
    }
  }

  Future<void> stop() async {
    try {
      await _flutterTts.stop();
    } catch (_) {}
    _isPlaying = false;
    _currentlySpeakingText = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _flutterTts.stop();
    super.dispose();
  }
}
